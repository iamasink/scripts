#Requires AutoHotkey v2.0


folder := A_ScriptDir "/MonitorProfileSwitcher/"


RunWait(folder "/MonitorSwitcher.exe -load:myprofile.xml", folder)
Sleep(5000)
; doing this often causes a lot of issues, so restart explorer for good measure
; restartExplorer()
Sleep(1000)
Sleep(5000)
; restart littlebigmouse
Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --start")
Sleep(1000)