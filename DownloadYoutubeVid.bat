@echo off
REM Ask the user to choose between downloading video or audio
echo What would you like to do:&echo\1)downloads video&echo\2)downloads audio only&echo\
set /p choice=">>"

REM Ask the user for the path of the video
set /p videopath="Enter the path of the video: "


REM ----checks if ffmpeg is in PATH----
where /q ffmpeg
if ERRORLEVEL 1 (
	echo ffmpeg not found in PATH. using local install
	if not exist ffmpeg\bin\ffmpeg.exe (
		echo local install not found. downloading ffmpeg
		REM ----downloads ffmpeg, extracts it, puts it into a file called \ffmpeg\, deletes the ffmpeg document and zip file, and deletes any ffmpeg namings left behind ----
		curl -L -o %cd%\ffmpeg.zip "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-lgpl.zip"
		tar -xf %cd%\ffmpeg.zip -C %cd%
		move %cd%\ffmpeg-* %~dp0\ffmpeg
		rmdir /s /q %cd%\ffmpeg\doc
		del %cd%\ffmpeg.zip 
		for /d %%i in ("%cd%\ffmpeg-*") do (
			if not "%%~nxi"=="ffmpeg" (
				rmdir /s /q "%%i"
			)
		)
	)
	if "%choice%"=="1" (
		call "%~dp0yt-dlp\yt-dlp.cmd" "%videopath%" --ffmpeg-location "%~dp0ffmpeg\bin\ffmpeg.exe" --paths "%cd%\Temp"
	) else if "%choice%"=="2" (
		call "%~dp0yt-dlp\yt-dlp.cmd" "%videopath%" --extract-audio --ffmpeg-location "%~dp0ffmpeg\bin\ffmpeg.exe" --paths "%cd%\Temp"
	) else (
		echo Invalid choice. Please enter 1 or 2.
	)
) else (
	if "%choice%"=="1" (
		call "%~dp0yt-dlp\yt-dlp.cmd" "%videopath%" --paths "%cd%\Temp"
	) else if "%choice%"=="2" (
		call "%~dp0yt-dlp\yt-dlp.cmd" "%videopath%" --extract-audio --paths "%cd%\Temp"
	) else (
		echo Invalid choice. Please enter 1 or 2.
	)	
)
move %cd%\Temp\* %cd%

echo file(s) output to %cd%
pause