#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory. #
SetTitleMatchMode, 2 ; change title match mode so GTA is detected

MsgBox, script started. Press Ctrl + W or End to force close GTA.

NumpadEnd:: ; when End pressed (if not in gta or whateverr)
	Runwait, taskkill /im GTA5.exe /f ; run taskkill, /im = imagename GTA5.exe, /f = force
Return

#IfWinActive Grand Theft Auto ; if GTA is the active window
^w:: ; when ctrl w pressed,
	Runwait, taskkill /im GTA5.exe /f ; run taskkill, /im = imagename GTA5.exe, /f = force
Return

