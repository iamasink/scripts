@REM this converts the file dragged onto the .bat
@REM converts to mp3 in high quality
ffmpeg -i %1 -ab 320k -map_metadata 0 -id3v2_version 3 %1.mp3
timeout 5