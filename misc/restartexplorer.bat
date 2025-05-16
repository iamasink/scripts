@echo off
powershell -Command "Start-Process PowerShell -ArgumentList '-ExecutionPolicy Bypass -Command \"Stop-Process -Name explorer -Force; Start-Process explorer.exe\"' -Verb RunAs"
