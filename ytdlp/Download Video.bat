@REM This is a comment
@REM Download yt-dlp.exe from https://github.com/yt-dlp/yt-dlp/releases, and put it in the same folder as this .bat file.

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
@REM "-f" is format (best video and audio)
@REM "--no-mtime" makes the modified time the current time, instead of the time the video was uploaded
@REM "--sub-langs all --embed-subs --sub-format best" downloads the subs and embeds them into the video file (excludes live chat and auto-generated subs)
@REM the rest just embed other info self explanatory 
@REM %url% is the url the user enters when the script is ran
@REM "|| pause" pauses the script if theres any issue (to show the error), else it will just close
yt-dlp -P %DownloadLocation% -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --no-mtime --sub-langs all --embed-subs --sub-format best --embed-thumbnail --write-thumbnail --embed-metadata --embed-chapters --embed-info-json %url% --cookies-from-browser firefox || pause
timeout /t 5
