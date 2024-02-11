#Requires AutoHotkey v2.0

; close obs and give it time to close

Run(A_ComSpec " /C " "taskkill /im obs64.exe", , "hide")
Sleep(15000)
if (ProcessExist("obs64.exe")) {
    Sleep(10000)
    RunWait(A_ComSpec " /C " "taskkill /f /im obs64.exe", , "hide")
}

; if it didn 't, force close it.

Run(A_ComSpec " /C " "`"C:\Program Files\obs-studio\bin\64bit\obs64.exe`" --startreplaybuffer --scene default --disable-shutdown-check", "C:\Program Files\obs-studio\bin\64bit\", "hide")