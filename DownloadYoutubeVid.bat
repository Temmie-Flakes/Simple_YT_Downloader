@echo off
REM Checks if parameters were passed into this file
if not "%~1"=="" (
	call "%~dp0yt-dlp\yt-dlp.cmd" %*
	EXIT /B %ERRORLEVEL% 
)
REM Ask user for what they want to do
REM pasteing youtube link will use last setting or if first time, just video.
REM 1=download
echo What would you like to do:&echo\1)download video&echo\2)download audio only&echo\Paste URL)download using last settings&echo\
set /p videochoice=">>"

call :check_for_YTDLP

call :check_for_FFMPEG


set /a flag=1
if "%videochoice%"=="1" (
	set extractAudio=
	call :choose_video_format
) else if "%videochoice%"=="2" (
	set extractAudio=--extract-audio
	call :choose_audio_format
) else (
	set /a flag=0
	set videopath=%videochoice%
)

if defined audioFormat (
	set audioFormat=--audio-format %audioFormat%
)
if defined videoFormat (
	set videoFormat=--format %videoFormat%
)


if %flag%==1 (
	if not defined videopath (
		REM Ask the user for the path of the video
		echo Enter the path of the video: 
		set /p videopath=">>"
	)
	echo "%~dp0yt-dlp\yt-dlp.cmd" "%%videopath%%" %extractAudio% %ffmpegLocation% --paths "%~dp0Temp" %audioFormat% %videoFormat%> "%~dp0currentCommand.txt"
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
EXIT /B %ERRORLEVEL% 


REM --------------------FUNCTIONS---------------------------

:choose_video_format
REM Ask the user for the format of video
echo What video format should it be:&echo\Paste URL)same as source (usually webm^)&echo\Leave Blank)same as source&echo\1)mp4&echo\2)3gp&echo\3)webm&echo\4)Custom format&echo\
set /p videoFormatChoice=">>"
if "%videoFormatChoice%"=="1" (
	set videoFormat="bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]"
) else if "%videoFormatChoice%"=="2" (
	set videoFormat="bv*[ext=3gp]+ba[ext=m4a]/b[ext=3gp]"
) else if "%videoFormatChoice%"=="3" (
	set videoFormat="bv*[ext=webm]+ba[ext=webm]/b[ext=webm]"
) else if "%videoFormatChoice%"=="4" (
	echo  Enter format:
	set /p videoFormat=">>"
) else (
	echo using same format as source&echo\
	set videoFormat=
	if defined videoFormatChoice (
	set videopath=%videoFormatChoice%
	)
)
EXIT /B 0

:choose_audio_format
REM Ask the user for the format of audio
echo What audio format should it be:&echo\Paste URL)same as source&echo\Leave Blank)same as source&echo\1)mp3&echo\2)m4a&echo\3)wav&echo\4)flac&echo\5)aac&echo\6)Opus&echo\7)Vorbis&echo\8)Custom format&echo\
set /p audioFormatChoice=">>"
if "%audioFormatChoice%"=="1" (
	set audioFormat=mp3
) else if "%audioFormatChoice%"=="2" (
	set audioFormat=m4a
) else if "%audioFormatChoice%"=="3" (
	set audioFormat=wav
) else if "%audioFormatChoice%"=="4" (
	set audioFormat=flac
) else if "%audioFormatChoice%"=="5" (
	set audioFormat=aac
) else if "%audioFormatChoice%"=="6" (
	set audioFormat=opus
) else if "%audioFormatChoice%"=="7" (
	set audioFormat=vorbis
) else if "%audioFormatChoice%"=="8" (
	echo  Enter format:
	set /p audioFormat=">>"
) else (
	echo using same format as source&echo\
	set audioFormat=
	if defined audioFormatChoice (
		set videopath=%audioFormatChoice%
	)
)
EXIT /B 0


:check_for_FFMPEG
REM ----checks if ffmpeg is in PATH----
where /q ffmpeg
if ERRORLEVEL 1 (
	echo ffmpeg not found in PATH. using local install&echo\
	if not exist "%~dp0ffmpeg\bin\ffmpeg.exe" (
		echo local install not found. downloading ffmpeg...
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
EXIT /B 0

:check_for_YTDLP
REM ----Downloads yt-dlp if not arleady installed----
if not exist "%~dp0yt-dlp" (
	echo downloading yt-dlp
	curl -L "https://github.com/yt-dlp/yt-dlp/archive/refs/heads/master.zip" -o "%~dp0yt-dlp.zip"
	tar -xf "%~dp0yt-dlp.zip" -C "%~dp0\"
	move "%~dp0yt-dlp-*" "%~dp0yt-dlp"
	del "%~dp0yt-dlp.zip"
)
EXIT /B 0
