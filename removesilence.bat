@REM this converts the file dragged onto the .bat
ffmpeg -i %1 -af "atrim=start=0.2,silenceremove=start_periods=1:start_silence=0.1:start_threshold=0.02" %1-converted.mp3
timeout 5