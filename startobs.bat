@REM this script runs when pc unlocked
@REM close obs and give it time to close
taskkill /im obs64.exe
timeout 5
@REM if it didn't, force close it.
taskkill /f /im obs64.exe
cd "C:\Program Files\obs-studio\bin\64bit\"
timeout 3
@REM Run OBS, start replay buffer and set the scene to one named "default".
start "" "C:\Program Files\obs-studio\bin\64bit\obs64.exe" --startreplaybuffer --scene default --disable-shutdown-check