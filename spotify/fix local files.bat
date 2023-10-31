@echo off
@REM this deletes the config for local files. this will make spotify re-do the metadata if you fucked it up
@REM actually, you can just toggle the location in spotify settings.
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo You should run this as administrator!
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
timeout /t 30

taskkill /f /im spotify.exe
timeout /t 5
cd "%appdata%\Spotify\Users"
del local-files.bnk /a /s
timeout /t 5
taskkill /f /im spotify.exe

echo !!!!! Now open spotify and disable and re-enable local files in settings
timeout /t 15