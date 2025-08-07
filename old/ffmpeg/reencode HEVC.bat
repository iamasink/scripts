@echo off
setlocal enabledelayedexpansion

REM Check if a file was dragged
if "%~1"=="" (
    echo Drag and drop a video file onto this script.
    timeout /t 5
    exit /b
)

REM Input file
set "input=%~1"
set "filename=%~n1"
set "output=%filename%-hevc19.mkv"

REM Run FFmpeg with encoding
ffmpeg -i "%input%" -c:v hevc_nvenc -preset p7 -tune uhq -rc vbr -cq 39 -c:a copy "%output%"

echo Done! Output file: %output%
timeout /t 5
