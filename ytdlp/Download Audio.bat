@REM This is a comment
@REM Download yt-dlp.exe from https://github.com/yt-dlp/yt-dlp/releases, and put it in the same folder as this .bat file. (or add it to Path)

@REM Hide the location and stuff, it makes it prettier
@echo off

@REM the location to download to. change this if you want! (default is your user's downloads folder)
SET DownloadLocation="%userprofile%\Downloads"

@REM this will show as an input when you run the script, so you can paste the url. do not change this
SET /P url=Enter URL: 

@REM Update YT-DLP
yt-dlp -U

@REM download the file
@REM "-P" is Path %DownloadLocation% is the variable from above, 
@REM "-f" is format (best audio)
@REM "--no-mtime" makes the modified time the current time, instead of the time the video was uploaded
@REM "--extract-audio" extracts only the audio and ignores video
@REM %url% is the url the user enters when the script is ran
@REM "|| pause" pauses the script if theres any issue (to show the error), else it will just close
yt-dlp -P %DownloadLocation% -f bestaudio --no-mtime --extract-audio %url% || pause
