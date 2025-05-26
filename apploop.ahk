#Requires AutoHotkey v2.0
#SingleInstance force
TraySetIcon(A_ScriptDir "\icon\ahkocean16.ico")
SetTitleMatchMode("RegEx")
CoordMode("ToolTip")
homeassistantToken := Fileread("secrets\homeassistant.txt") ; load the token from file

; current app loop
; detects the currently running app, and does stuff for them on open/close

; if not admin, start as admin
; taken from https://www.autohotkey.com/boards/viewtopic.php?p=523250#p523250
if (!A_IsAdmin) {
	try {
		Run("*RunAs `"" A_ScriptFullPath "`"")
	}
	catch {
		MsgBox("Couldn't run " A_ScriptName " as admin! Some things may not work")
	}
}

; Define applications
closeobs := [
	; "ahk_exe osu!\.exe$",
	; "ahk_exe Beat Saber\.exe$",
	; "ahk_exe prismlauncher\.exe$",
	; "ahk_exe LosslessCut\.exe$",
]
closelbm := [
	"ahk_exe .*-Win64-Shipping\.exe$", ; unreal engine stuff usually doesnt work well
	"ahk_exe osu!\.exe$",
	; "ahk_exe prismlauncher\.exe$",
	"ahk_exe League of Legends\.exe$",
]
highperf := ["ahk_exe cs2\.exe$"]
league := ["ahk_exe LeagueClientUx\.exe$"]

; Initialize variables to track the state of applications
openapps := Map("closeobs", false, "closelbm", false, "idle", false, "highperf", false, "league", false)

; Function to check if any application in the given list is running
AnyAppRunning(appList) {
	for _, app in appList {
		if (WinExist(app))
			return true
	}
	return false
}
; tooltip in middle of screen
CenteredTooltip(text, time := 2500, number := 1) {
	ToolTip(text, A_ScreenWidth / 2, A_ScreenHeight / 2 - number * 50, number)
	SetTimer () => ToolTip(, , , number), -time
}

while true {
	; Check if any application in the closeobs group is running
	closeobsappRunning := AnyAppRunning(closeobs)
	if (closeobsappRunning) {
		if (!openapps["closeobs"]) {
			; when this app is launched
			CenteredTooltip("Closing OBS", , 1)
			RunWait("taskkill /im obs64.exe", , "Hide")
			; try WinKill("ahk_exe obs64.exe")

		}
		openapps["closeobs"] := true
	} else {
		if (openapps["closeobs"]) {
			; when this app is closed
			CenteredTooltip("Launched OBS", , 1)
			Run("`"C:\Program Files\obs-studio\bin\64bit\obs64.exe`" --startreplaybuffer --scene default",
				"C:\Program Files\obs-studio\bin\64bit", "Hide")

		}
		openapps["closeobs"] := false
	}

	; Check if any application in the closeobs group is running
	closelbmappRunning := AnyAppRunning(closelbm)
	if (closelbmappRunning) {
		if (!openapps["closelbm"]) {
			; when this app is launched
			CenteredTooltip("Closing LBM", , 2)
			Run("taskkill /f /im LittleBigMouse.Hook.exe", , "Hide")
			Run("taskkill /f /im LittleBigMouse.Ui.Avalonia.exe", , "Hide")
		}
		openapps["closelbm"] := true
	} else {
		if (openapps["closelbm"]) {
			; when this app is closed
			CenteredTooltip("Launched LBM", , 2)
			; Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --start")
			Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse.Ui.Avalonia.exe`" --start")
			 
		}
		openapps["closelbm"] := false
	}

	; Check if any application in the closeobs group is running
	highperfappRunning := AnyAppRunning(highperf)
	if (highperfappRunning) {
		if (!openapps["highperf"]) {
			; when this app is launched
			; CenteredTooltip("High performance plan enabled", , 3)
			; set power plan to high performance
			; Run("powercfg.exe /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c")
		}
		openapps["highperf"] := true
	} else {
		if (openapps["highperf"]) {
			; when this app is closed
			; CenteredTooltip("Returned to balanced plan", , 3)
			; set power plan to balanced
			; Run("powercfg.exe /setactive 381b4222-f694-41f0-9685-ff5bb260df2e")

		}
		openapps["highperf"] := false
	}

	leagueappRunning := AnyAppRunning(league)
	if (leagueappRunning) {
		if (!openapps["league"]) {
			; when this app is launched
			CenteredTooltip("League client opened`nRunning Blitz", , 4)
			Run("C:\Users\Lily\AppData\Local\Programs\Blitz\Blitz.exe")
			Run("D:\tools\cslol\cslol-manager\cslol-manager.exe")
		}
		openapps["league"] := true
	} else {
		if (openapps["league"]) {
			; when this app is closed
			CenteredTooltip("League client closed`nClosing Blitz", , 4)
			Run("taskkill /f /im Blitz.exe", , "Hide")
			Run("taskkill /im cslol-manager.exe", , "Hide")
		}
		openapps["league"] := false
	}

	if (ProcessExist("obs64.exe")) {
		; obs open yey
		; SetNumLockState("Off")

	} else {
		; SetNumLockState("On")

	}

	Sleep(5000)

}

; while true {

; 	For (index, value in closeobs)
; 	{
; 		if (WinExist(value))
; 		{
; 			if (!openapps["closeobs"]) {
; 				openapps["closeobs"] := true
; 				tooltip "Closing OBS!"
; 			} else {
; 				tooltip "(nothing)"
; 			}

; 			; ; on launch of closeobs game
; 			; windowexist := true
; 			; ToolTip true
; 			break
; 		} else {
; 			if (!openapps["closeobs"]) {
; 				openapps["closeobs"] := true
; 				tooltip "Closing OBS!"
; 			} else {
; 				tooltip "(nothing)"
; 			}
; 		}
; 	}

; For (index, value in closelbm)
; {
; 	if (WinExist(value))
; 	{
; 		windowexist2 := true
; 		ToolTip true
; 		break
; 	} else {
; 		ToolTip false
; 		continue
; 	}
; }

; on close of closeobs game

; if WinExist("osu! ahk_exe osu!.exe") {
; 	if (openapps["osu"] != true) {
; 		; when this app is launched
; 		; run some code
; 		RunWait("taskkill /im obs64.exe", , "Hide")
; 		ToolTip("Closed obs!")
; 		Sleep(3000)
; 		ToolTip()
; 	}
; 	openapps["osu"] := true
; } else {
; 	if (openapps["osu"] != false) {
; 		; when this app is closed
; 		; run some code
; 		Run("`"C:\Program Files\obs-studio\bin\64bit\obs64.exe`" --startreplaybuffer --scene default", "C:\Program Files\obs-studio\bin\64bit", "Hide")
; 		ToolTip("Re-launched obs!")
; 		Sleep(3000)
; 		ToolTip()

; 	}
; 	openapps["osu"] := false
; }

; if WinExist("ahk_exe Beat Saber.exe") {
; 	if (openapps["bs"] != true) {
; 		; when this app is launched
; 		; run some code
; 		RunWait("taskkill /im obs64.exe", , "Hide")
; 		ToolTip("Closed obs!")
; 		Sleep(3000)
; 		ToolTip()
; 	}
; 	openapps["bs"] := true
; } else {
; 	if (openapps["bs"] != false) {
; 		; when this app is closed
; 		; run some code
; 		Run("`"C:\Program Files\obs-studio\bin\64bit\obs64.exe`" --startreplaybuffer --scene default", "C:\Program Files\obs-studio\bin\64bit", "Hide")
; 		ToolTip("Re-launched obs!")
; 		Sleep(3000)
; 		ToolTip()

; 	}
; 	openapps["bs"] := false
; }

; ; these break with littlebigmouse
; if (WinExist("ahk_exe FortniteClient-Win64-Shipping.exe")
; 	|| WinExist("ahk_exe Palworld-Win64-Shipping.exe")
; 	|| WinExist("ahk_exe League of Legends.exe")
; ) {
; 	if (openapps["fn"] != true) {
; 		; when this app is launched
; 		; run some code
; 		Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --exit")

; 		ToolTip("Closed lbm!")
; 		Sleep(3000)
; 		ToolTip()
; 	}
; 	openapps["fn"] := true
; } else {
; 	if (openapps["fn"] != false) {
; 		; when this app is closed
; 		; run some code
; 		Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --start")
; 		ToolTip("Re-launched lbm!")
; 		Sleep(3000)
; 		ToolTip()

; 	}
; 	openapps["fn"] := false
; }

; 	if (ProcessExist("obs64.exe")) {
; 		; obs open yey
; 		SetNumLockState("Off")

; 	} else {
; 		SetNumLockState("On")

; 	}

; 	Sleep(2500) ; this should be fine considering obs takes a bit to launch
; }

#HotIf WinActive(A_ScriptName " ahk_exe Code.exe")
~^s::
{
	; Send("^s")
	ToolTip("Reloading " A_ScriptName ".", A_ScreenWidth / 2, A_ScreenHeight / 2)
	Sleep(250)
	Reload()
	; MsgBox("reloading !")
	return
}

homeassistantRequest(requestJSON, url, wait := false) {
	; get token from variable earlier
	global homeassistantToken
	if (wait) {
		RunWait(A_ComSpec " /C " "curl -X POST -H `"Authorization: Bearer " homeassistantToken "`" -H `"Content-Type: application/json`" -d `"" requestJSON "`" http://homeassistant.local:8123/api/" url, ,
			"hide")
	} else {
		Run(A_ComSpec " /C " "curl -X POST -H `"Authorization: Bearer " homeassistantToken "`" -H `"Content-Type: application/json`" -d `"" requestJSON "`" http://homeassistant.local:8123/api/" url, ,
			"hide")
	}
}
