@REM this script runs when pc idle


echo idle

@REM close obs and give it time to close
taskkill /im obs64.exe
timeout 10
@REM if it didn't, force close it.
taskkill /f /im obs64.exe

pause