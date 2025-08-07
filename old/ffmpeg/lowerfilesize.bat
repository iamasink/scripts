@REM this converts the file dragged onto the .bat
ffmpeg -i %1 -vcodec libx265 -crf 28 %1-converted.mp4
timeout 5