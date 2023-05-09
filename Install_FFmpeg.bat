cd %~dp0
winget uninstall ffmpeg 
winget install ffmpeg -l %~dp0 

PAUSE