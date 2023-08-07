@REM windows' time keeps getting out of sync, so this is a script to sync it
@echo off

@REM if there is no argument (ie the script is ran not from the ahk), warn the user that they should run it as admin
if (%1)==() (
    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    echo You should run this as administrator!
    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    timeout /t 30
)


echo Syncing time...

@REM start the time service
net start w32time 
@REM set the time service's peers and stuff
@REM syncfromflags:manual means that the time service will only sync from the peers specified in the manualpeerlist
w32tm /config /manualpeerlist:"time.windows.com time.cloudflare.com time.google.com" /syncfromflags:manual /update
@REM resync the time
w32tm /resync

if (%1)==() (
    timeout /t 10   
)

exit