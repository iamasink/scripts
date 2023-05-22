@REM this script runs when pc unlocked
@REM change power plan to balanced
powercfg.exe /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
cd "C:\Program Files\obs-studio\bin\64bit\"
timeout 5
@REM Run OBS, start replay buffer and set the scene to default.
start "" "C:\Program Files\obs-studio\bin\64bit\obs64.exe" --startreplaybuffer --scene default 
