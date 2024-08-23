@REM backup upgrade and apply spicetify 

@echo off
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo You should run this as administrator!
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
timeout /t 30

taskkill /f /im spotify.exe

@REM spicetify's backup sometimes messes it up for me, maybe I'm stupid, but this should help incase it breaks again

@REM delete old backup
if exist "C:\spicetifybackup\roamingspicetify.old" rmdir /s /q C:\spicetifybackup\roamingspicetify.old
if exist "C:\spicetifybackup\localspicetify.old" rmdir /s /q C:\spicetifybackup\localspicetify.old
@REM rename current backup to old backup
if exist "C:\spicetifybackup\roamingspicetify" rename "C:\spicetifybackup\roamingspicetify" "roamingspicetify.old"
if exist "C:\spicetifybackup\localspicetify" rename "C:\spicetifybackup\localspicetify" "localspicetify.old"
@REM create new backup
robocopy "%appdata%\spicetify" "C:\spicetifybackup\roamingspicetify" /E
robocopy "%localappdata%\spicetify" "C:\spicetifybackup\localspicetify" /E

spicetify
spicetify update
spicetify backup
spicetify upgrade
spicetify backup apply
pause