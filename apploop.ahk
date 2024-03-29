#Requires AutoHotkey v2.0
#SingleInstance force
TraySetIcon(A_ScriptDir "\icon\ahkocean16.ico")

; current app loop
; detects the currently running app, and changes stuff for them
win := 0
openapps := Map("osu", false, "bs", false, "fn", false)
while true {
	prev := win
	win := WinWaitActive("A")
	; SoundBeep
	if (win != prev) {
		; ToolTip("Switched to " WinGetProcessName(win))
	}

	if WinExist("osu! ahk_exe osu!.exe") {
		if (openapps["osu"] != true) {
			; when this app is launched
			; run some code
			RunWait("taskkill /im obs64.exe", , "Hide")
			ToolTip("Closed obs!")
			Sleep(3000)
			ToolTip()
		}
		openapps["osu"] := true
	} else {
		if (openapps["osu"] != false) {
			; when this app is closed
			; run some code
			Run("`"C:\Program Files\obs-studio\bin\64bit\obs64.exe`" --startreplaybuffer --scene default", "C:\Program Files\obs-studio\bin\64bit", "Hide")
			ToolTip("Re-launched obs!")
			Sleep(3000)
			ToolTip()

		}
		openapps["osu"] := false
	}

	if WinExist("ahk_exe Beat Saber.exe") {
		if (openapps["bs"] != true) {
			; when this app is launched
			; run some code
			RunWait("taskkill /im obs64.exe", , "Hide")
			ToolTip("Closed obs!")
			Sleep(3000)
			ToolTip()
		}
		openapps["bs"] := true
	} else {
		if (openapps["bs"] != false) {
			; when this app is closed
			; run some code
			Run("`"C:\Program Files\obs-studio\bin\64bit\obs64.exe`" --startreplaybuffer --scene default", "C:\Program Files\obs-studio\bin\64bit", "Hide")
			ToolTip("Re-launched obs!")
			Sleep(3000)
			ToolTip()

		}
		openapps["bs"] := false
	}

	; these break with littlebigmouse
	if (WinExist("ahk_exe FortniteClient-Win64-Shipping.exe")
		|| WinExist("ahk_exe Palworld-Win64-Shipping.exe")
		|| WinExist("ahk_exe League of Legends.exe")
	) {
		if (openapps["fn"] != true) {
			; when this app is launched
			; run some code
			Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --exit")

			ToolTip("Closed lbm!")
			Sleep(3000)
			ToolTip()
		}
		openapps["fn"] := true
	} else {
		if (openapps["fn"] != false) {
			; when this app is closed
			; run some code
			Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --start")
			ToolTip("Re-launched lbm!")
			Sleep(3000)
			ToolTip()

		}
		openapps["fn"] := false
	}


	if (ProcessExist("obs64.exe")) {
		; obs open yey
		SetNumLockState("Off")

	} else {
		SetNumLockState("On")

	}

	Sleep(2500) ; this should be fine considering obs takes a bit to launch
}


#HotIf WinActive(A_ScriptName " ahk_exe Code.exe")
~^s::
{
	; Send("^s")
	ToolTip("Reloading " A_ScriptName ".", A_ScreenWidth / 2, A_ScreenHeight / 2)
	Sleep(250)
	Reload()
	; MsgBox("reloading !")
	Return
}