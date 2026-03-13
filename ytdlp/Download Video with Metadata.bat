@REM This is a comment
@REM Download yt-dlp.exe from https://github.com/yt-dlp/yt-dlp/releases, and put it in the same folder as this .bat file.

@REM Hide the location and stuff, it makes it prettier
@echo off

@REM the location to download to. change this if you want! (default is your user's downloads folder)
SET DownloadLocation="%userprofile%\Downloads"

@REM this will show as an input when you run the script, so you can paste the url. do not change this
SET /P "url=Enter URL: "

@REM replace urls
call SET url=%url:deer.social=bsky.app%
echo new url %url%

@REM prompt for mode
echo.
echo Select download type:
echo   1 = Video + Audio
echo   2 = Audio only
SET /P "mode=Enter choice (1/2): "

@REM Update YT-DLP
yt-dlp -U

@REM common output template
SET "OutputTemplate=[%%(upload_date>%%Y-%%m-%%d)s] %%(uploader)s - %%(title)s [%%(id)s]\%%(title)s.%%(ext)s"

@REM branch by choice
IF "%mode%"=="2" GOTO AUDIO

:VIDEO
yt-dlp ^
 -P %DownloadLocation% ^
 -o "%OutputTemplate%" ^
 -f "bestvideo+bestaudio/best" ^
 --no-mtime ^
 --sub-langs all --embed-subs --sub-format best ^
 --embed-thumbnail --embed-metadata --embed-chapters --embed-info-json ^
 --cookies-from-browser firefox ^
 --write-description --write-info-json ^
 --merge-output-format mkv --remux-video mkv --add-metadata -k ^
 --sponsorblock-mark "chapter" ^
 %url% || pause
GOTO END

:AUDIO
yt-dlp ^
 -P %DownloadLocation% ^
 -o "%OutputTemplate%" ^
 -f "bestaudio/best" ^
 --no-mtime ^
 --extract-audio --audio-quality 0 ^
 --embed-thumbnail --embed-metadata --embed-info-json ^
 --cookies-from-browser firefox ^
 --write-description --write-info-json ^
 --add-metadata -k ^
 --sponsorblock-mark "chapter" ^
 %url% || pause
GOTO END

:END
timeout /t 5