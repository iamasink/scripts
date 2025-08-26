@echo off
setlocal

if "%~1"=="" (
  echo Usage: %~nx0 "C:\path\to\script.ps1"
  exit /b 1
)

set "ps1=%~1"

set "dir=%~dp1"
set "base=%~n1"
set "wrapper=%dir%%base%.bat"

> "%wrapper%" echo @echo off
>> "%wrapper%" echo PowerShell -NoProfile -ExecutionPolicy Bypass -File "%ps1%"

echo Created: "%wrapper%"
endlocal

timeout /t 10