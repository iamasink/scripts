@echo off
title scrcpy
cd scrcpy
adb kill-server
@REM run 'adb get-serialno' and save output to variable
FOR /F "tokens=*" %%g IN ('adb get-serialno') do (SET device=%%g)
echo %device%

@REM read pin from file
SET /p pin=<../../secrets/adbpin-%device%.txt
@REM echo %pin%

@REM press the power button
@REM adb -s %device% shell input keyevent KEYCODE_POWER || adb -s 192.168.0.200:5555 shell input keyevent KEYCODE_POWER
adb -s %device% shell input keyevent KEYCODE_POWER

timeout /t 1 /nobreak

@REM input the pin
@REM adb -s %device% shell input text %pin% || adb -s 192.168.0.200:5555 shell input text %pin%
adb -s %device% shell input text %pin%

timeout /t 1 /nobreak

@REM Adjust the screen size
adb shell wm size 1350x2400

timeout /t 1 /nobreak

@REM turn-screen-off turns off the screen
@REM stay-awake keeps the device awake
@REM power-off-on-close turns off the device when scrcpy is closed or unplugg
@REM show-touches shows touches on the screen
cmd /c scrcpy.exe --stay-awake --show-touches --select-usb --max-fps=60 --window-width=540 --window-height=900
adb shell wm size reset
timeout /t 5