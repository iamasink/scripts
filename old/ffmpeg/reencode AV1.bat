@echo off
setlocal enabledelayedexpansion

REM Check if files were dragged
if "%~1"=="" (
    echo Drag and drop video files onto this script.
    timeout /t 5
    exit /b
)

REM Encoding parameters (adjust these as needed)
set "preset=8"
set "crf=35"

REM Process all dragged files
for %%F in (%*) do (
    set "input=%%~F"
    set "filename=%%~nF"
    set "output=%%~dpnF-av1-p%preset%-crf%crf%.mkv"
    
    echo Encoding "%%~nxF"...
    
    start "" /b /low /wait ffmpeg -hide_banner -i "!input!" -c:v libsvtav1 -svtav1-params "preset=%preset%:keyint=300:input-depth=10:crf=%crf%:rc=0:film-grain=0" -c:a copy "!output!"

)

echo.
echo.
echo.
echo.
echo All files processed!
powershell -C [char]7
timeout /t 15