Super simple, super fast, Uses youtube-dl's python library. Just open, and paste the link to the video.

To install:
----
1. download this repo as a zip or using Git.
2. There is no step two. you have been fooled. maybe extract the zip i guess.

how to use:
----
1.	run the batch file
2.	type 1 for video or 2 for audio or just paste a youtube link to use the most recent settings  
If it's the first time running the script (or currentCommand.txt is missing) it will default to downloading video 
3.  (if you chose 1 or 2)  
choose which format you want from the list (or custom format) or leave blank to auto format to same as source  
you can paste the URL to download the source format of audio or video (depending on step 1)
4. Paste video link
- the output will appear in the same directory as the batch file (or wherever the main commandline is being run)

Notes:
----
- It checks if you have ffmpeg in your PATH. If not then it downloads it to a folder named ffmpeg in the batch directory
- It will automatically download yt-dlp on first run.

Todo:
----
- [ ] add more flags to be added if wanted through the console interface
- [ ] add ability to download multiple videos at once.

