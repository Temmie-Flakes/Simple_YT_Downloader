rem Ask the user to choose between downloading video or audio
echo What would you like to do:&echo\1)downloads video&echo\2)downloads audio only&echo\
set /p choice=">>"

rem Ask the user for the path of the video
set /p videopath="Enter the path of the video: "

rem Call the appropriate batch file based on the user's choice
if "%choice%"=="1" (
    call "%~dp0yt-dlp\yt-dlp.cmd" "%videopath%" --ffmpeg-location "%~dp0ffmpeg-6.0-full_build\bin\ffmpeg.exe" --write-thumbnail --paths "%cd%"
) else if "%choice%"=="2" (
    call "%~dp0yt-dlp\yt-dlp.cmd" "%videopath%" --extract-audio --ffmpeg-location "%~dp0ffmpeg-6.0-full_build\bin\ffmpeg.exe" --paths "%cd%"
) else (
    echo Invalid choice. Please enter 1 or 2.
)
echo file output to %cd%
pause