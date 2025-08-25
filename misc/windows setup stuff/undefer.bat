
@echo off

:: ================================================ ::
:: Feature Updates can be deferred 0-365 days
set "FEATURE_DAYS=0"
:: Quality Updates can be deferred 0-30 days
set "QUALITY_DAYS=0"
:: ================================================ ::



echo Checking for Admin privileges..
net session >nul 2>&1
cls
if %errorlevel% neq 0 (
    echo This script requires Administrator privileges.
    echo Please run it as Administrator.
    pause
    exit /b
)

echo.
echo ==================================================
echo Configuring Windows Update deferrals
echo Feature Updates will be deferred for: %FEATURE_DAYS% days
echo Quality Updates will be deferred for: %QUALITY_DAYS% days
echo ==================================================
echo.
pause
cls

echo Creating the WindowsUpdate registry key
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /f
echo.

echo Enabling deferring Feature Updates
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DeferFeatureUpdates /t REG_DWORD /d 0 /f
echo.

echo Setting the number of days to defer Feature Updates
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DeferFeatureUpdatesPeriodInDays /t REG_DWORD /d %FEATURE_DAYS% /f
echo.

echo Enabling deferring Quality Updates
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DeferQualityUpdates /t REG_DWORD /d 0 /f
echo.

echo Setting the number of days to defer Quality Updates
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DeferQualityUpdatesPeriodInDays /t REG_DWORD /d %QUALITY_DAYS% /f
echo.

echo.
echo Windows Update deferral settings have been applied:
echo  - Feature Updates: %FEATURE_DAYS% days
echo  - Quality Updates: %QUALITY_DAYS% days
echo.
pause
