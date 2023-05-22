@REM this script runs when pc locked
@REM close obs and give it time to close
taskkill /im obs64.exe
timeout 3
@REM if it didn't, force close it.
taskkill /f /im obs64.exe
@REM set power plan to power saver
powercfg.exe /setactive a1841308-3541-4fab-bc81-f71556f20b4a