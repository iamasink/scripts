#Requires AutoHotkey v2.0
SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory. #
SetTitleMatchMode(2) ; change title match mode so GTA is detected

MsgBox("script started. Press Ctrl + W or End to force close GTA.")

End:: ; when End pressed (if not in gta or whateverr)
{
	RunWait("taskkill /im GTA5.exe /f") ; run taskkill, /im = imagename GTA5.exe, /f = force
	Return
} ; V1toV2: Added

#HotIf WinActive("Grand Theft Auto",) ; if GTA is the active window
^w:: ; when ctrl w pressed,
{
	RunWait("taskkill /im GTA5.exe /f") ; run taskkill, /im = imagename GTA5.exe, /f = force
	Return
} ; V1toV2: Added
