@REM removes silence from all .mp3s in folder
@REM removes silence from the beginning of the audio
for %%f in (*.mp3) do (  ffmpeg -i %%f -af "atrim=start=0.2,silenceremove=start_periods=1:start_silence=0.1:start_threshold=0.02" %%f-converted.mp3 ) 
timeout 5