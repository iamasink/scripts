@echo off
title scrcpy
cd scrcpy
adb kill-server

cmd /c scrcpy --video-source=camera
timeout /t 5