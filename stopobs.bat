@REM this script runs when pc locked
@REM close obs and give it time to close
taskkill /im obs64.exe
taskkill /im firefox.exe
timeout 5
@REM if it didn't, force close it.
taskkill /f /im obs64.exe
taskkill /im /f firefox.exe