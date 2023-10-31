@REM this converts the file dragged onto the .bat
@REM removes silence from the beginning of the audio
ffmpeg -i %1 -ab 320k -map_metadata 0 -id3v2_version 3 %1.mp3
timeout 5