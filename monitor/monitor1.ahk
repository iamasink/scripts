#Requires AutoHotkey v2.0

folder := A_ScriptDir "/MonitorProfileSwitcher/"

ToolTip("TV display")
Sleep(250)
; Run("C:\Windows\System32\DisplaySwitch.exe /internal")
RunWait(folder "MonitorSwitcher.exe -load:myprofile2.xml", folder)
Sleep(2000)
; doing this often causes a lot of issues, so restart explorer for good measure (i mean displayport takes so long to wake up that this'll probably be ran before the monitors even turn on)
; restartExplorer()
; kill spotify because it sometimes just starts playing idk
RunWait("taskkill.exe /F /IM Spotify.exe", , "Hide")
Sleep(10000)
; restart littlebigmouse, it can wait to ensure everything is settled
Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --exit")
Sleep(1000)
ToolTip("")