@echo off
:: Check for admin
>nul 2>&1 net session
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Commands that require elevation
net stop audiosrv
net stop AudioEndpointBuilder
net start AudioEndpointBuilder
net start audiosrv
