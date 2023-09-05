@echo off
REM Ask user for what they want to do
REM pasteing youtube link will use last setting or if first time, just video.
REM 1=download
echo What would you like to do:&echo\1)download video&echo\2)download audio only&echo\Paste URL)download using last settings&echo\
set /p videochoice=">>"

REM ----Downloads yt-dlp if not arleady installed----
if not exist "%~dp0yt-dlp" (
	echo downloading yt-dlp
	curl -L "https://github.com/yt-dlp/yt-dlp/archive/refs/heads/master.zip" -o "%~dp0yt-dlp.zip"
	tar -xf "%~dp0yt-dlp.zip" -C "%~dp0\"
	move "%~dp0yt-dlp-*" "%~dp0yt-dlp"
	del "%~dp0yt-dlp.zip"
)

REM ----checks if ffmpeg is in PATH----
where /q ffmpeg
if ERRORLEVEL 1 (
	echo ffmpeg not found in PATH. using local install
	if not exist "%~dp0ffmpeg\bin\ffmpeg.exe" (
		echo local install not found. downloading ffmpeg
		REM ----downloads ffmpeg, extracts it, puts it into a file called \ffmpeg\, deletes the ffmpeg document and zip file, and deletes any ffmpeg namings left behind ----
		curl -L "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-lgpl-shared.zip" -o "%~dp0ffmpeg.zip"
		tar -xf "%~dp0ffmpeg.zip" -C "%~dp0\"
		move "%~dp0ffmpeg-*" "%~dp0ffmpeg"
		rmdir /s /q "%~dp0ffmpeg\doc"
		rmdir /s /q "%~dp0ffmpeg\include"
		rmdir /s /q "%~dp0ffmpeg\lib"
		del "%~dp0ffmpeg.zip"
		for /d %%i in ("%~dp0ffmpeg-*") do (
			if not "%%~nxi"=="ffmpeg" (
				rmdir /s /q "%%i"
			)
		)
		REM curl -L "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-lgpl.zip" -o "%cd%\ffmpeg.zip"
		REM tar -xf "%cd%\ffmpeg.zip" -C "%cd%"
		REM move "%cd%\ffmpeg-*" "%~dp0\ffmpeg"
		REM rmdir /s /q "%cd%\ffmpeg\doc"
		REM del "%cd%\ffmpeg.zip"
		REM for /d %%i in ("%cd%\ffmpeg-*") do (
			REM if not "%%~nxi"=="ffmpeg" (
				REM rmdir /s /q "%%i"
			REM )
		REM )
	)
	set ffmpegLocation=--ffmpeg-location "%~dp0ffmpeg\bin\ffmpeg.exe"
) else (
	set ffmpegLocation=
)
set /a flag=1
if "%videochoice%"=="1" (
	set extractAudio=
) else if "%videochoice%"=="2" (
	set extractAudio=--extract-audio
	REM Ask the user for the format of audio
	echo What audio format should it be (ex:mp3^)(leave blank to be same as source^)
	set /p audioFormat=">>"
) else (
	set /a flag=0
	set videopath=%videochoice%
)

if defined audioFormat (
	set audioFormat=--audio-format %audioFormat%
)

if %flag%==1 (
	REM Ask the user for the path of the video
	echo Enter the path of the video: 
	set /p videopath=">>"
	echo "%~dp0yt-dlp\yt-dlp.cmd" "%%videopath%%" %extractAudio% %ffmpegLocation% --paths "%~dp0Temp" %audioFormat%> "%~dp0currentCommand.txt"
) else (
	if not exist "%~dp0currentCommand.txt" (
		echo couldent find last command. defaulting to video download.
		echo "%~dp0yt-dlp\yt-dlp.cmd" "%%videopath%%" %ffmpegLocation% --paths "%~dp0Temp"> "%~dp0currentCommand.txt"
	)
)
for /f "usebackq delims=" %%i in ("%~dp0currentCommand.txt") do (
	REM @echo %%i
	call %%i
)
rem call "%~dp0yt-dlp\yt-dlp.cmd" "%videopath%" %extractAudio% %ffmpegLocation% --paths "%~dp0Temp" --audio-format mp3
move "%~dp0Temp\*" "%cd%"

echo file(s) output to %cd%
pause