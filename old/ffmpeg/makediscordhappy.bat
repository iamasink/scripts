@REM this converts the file dragged onto the .bat 
@REM this makes discord embed the file :D

ffmpeg -i %1  -vcodec libx264 -acodec aac %1-converted.mp4
timeout 5