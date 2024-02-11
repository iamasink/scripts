@REM doesnt work

ffmpeg -i replay.mkv -i 1.mkv -filter_complex "[1]setpts=PTS-STARTPTS+25/TB[top];[0:0][top]overlay=enable='between(t\,10,15)'[out]" -map [out] -map 0:1    -c:a copy -c:v libx264 -crf 29 output5.mkv

pause