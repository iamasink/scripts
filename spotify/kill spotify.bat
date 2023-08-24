@echo off
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo You should run this as administrator!
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
timeout /t 30

taskkill /f /im spotify.exe
timeout /t 5
taskkill /f /im spotify.exe
timeout /t 15