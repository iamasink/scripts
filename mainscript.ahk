; main script.
#Requires AutoHotkey v2.0
SetTitleMatchMode(2) ;A window's title can contain WinTitle anywhere inside it to be a match.
Persistent(true)
;keeps num and caps off permanently
SetCapsLockState("AlwaysOff")
SetNumlockState "AlwaysOff"
SetDefaultMouseSpeed(0)
CoordMode("Mouse")
SetWorkingDir(A_ScriptDir) ; Ensures a consistent starting directory.
#SingleInstance Force


; ----- Current F13-24 Binds -----
; Mouse: G502
;   - Side  / DPI shift   - F21
;   - DPI Up  /  G8       - F22
;   - DPI Down  /  G7     - F23
;   - Top middle  / G9    - F24
; Keyboard: Wooting 2 HE
;   - A1	- F13
;   - A2	- F14
;   - A3	- F15
;   - Mode 	- F16
;   The original functions for these keys (switching keyboard profile) are available in the FN layer.

; read secrets, this runs on script start so the script must be restarted to update the toke
homeassistantToken := Fileread("secrets\homeassistant.txt") ; load the token from file

; set display on start
if (MonitorGetCount() = 1) { ; only if only 1 monitor is on
	Run("C:\Windows\System32\DisplaySwitch.exe /extend")
	Sleep(2000)
	; tell littlebigmouse to open and start
	Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --start")
}

; if not admin, start as admin
; taken from https://www.autohotkey.com/boards/viewtopic.php?p=523250#p523250
If (!A_IsAdmin)
{
	Try {
		Run("*RunAs `"" A_ScriptFullPath "`"")
	}
	catch {
		MsgBox("Couldn't run as admin! Some things may not work")
	}
}

ProcessSetPriority("H") ; set priority to high
; Low (or L)
; BelowNormal (or B)
; Normal (or N)
; AboveNormal (or A)
; High (or H)
; Realtime (or R)
; this chooses the script itself- https://www.autohotkey.com/docs/v2/lib/ProcessSetPriority.htm "If unset or omitted, the script's own process is used"


; ====== functions ======

/**
 * Send a POST request thing to homeassistant
 * @param requestJSON a string containing json for the request body
 * @param url the url suffix, past /api/
 */
homeassistantRequest(requestJSON, url, wait := false)
{
	; get token from variable earlier
	global homeassistantToken
	if (wait) {
		RunWait(A_ComSpec " /C " "curl -X POST -H `"Authorization: Bearer " homeassistantToken "`" -H `"Content-Type: application/json`" -d `"" requestJSON "`" http://homeassistant.local:8123/api/" url, , "hide")
	} else {
		Run(A_ComSpec " /C " "curl -X POST -H `"Authorization: Bearer " homeassistantToken "`" -H `"Content-Type: application/json`" -d `"" requestJSON "`" http://homeassistant.local:8123/api/" url, , "hide")
	}
}
homeassistantGet(url, wait := false) {
	global homeassistantToken
	if (wait) {
		return ComObject("WScript.Shell").Exec("curl -H `"Authorization: Bearer " homeassistantToken "`" -H `"Content-Type: application/json`" http://homeassistant.local:8123/api/" url).StdOut.ReadAll()
	} else {
		return Run(A_ComSpec " /C " "curl -H `"Authorization: Bearer " homeassistantToken "`" -H `"Content-Type: application/json`" http://homeassistant.local:8123/api/" url, , "hide")
	}

}

homeassistantGetLightState() ; returns on or off
{
	str := homeassistantGet("states/light.wiz_rgbw_tunable_b0afb2", true) ; returns a json string
	index := InStr(str, "`"state`":`"") ; find the index of the state
	state := SubStr(str, index + 9, 2) ; get the state (on or of)
	if (state = "on") {
		return 1 ; on
	} else {
		return 0 ; off or unknown or something fucked up
	}
}

lighttoggle(r, g, b, w, brightness, wait := false)
{
	; remember that `" is the escape for " within autohotkey, a \ escapes that " for the CMD that runs
	; so CMD sees (eg) {\"entity_id\":\"light.wiz_rgbw_tunable_b0afb2\"}
	; which then curls {"entity_id":"light.wiz_rgbw_tunable_b0afb2"}
	; autohotkey inherently concatenates strings, so within the rgbw_color array, the main "" ends so it can concatenate the variable.
	; yes its complicated and i'll probably have to relearn everything next time i want to touch this 😭😭
	; it's possible some of the " are avoidable, but i really do not want to do this any longer

	; this toggle function includes a rgbw and brightness, because it still sets the light to these if turning on
	homeassistantRequest("{\`"entity_id\`":\`"light.wiz_rgbw_tunable_b0afb2\`", \`"rgbw_color\`":[" r "," g "," b "," w "], \`"brightness_pct\`": " brightness "}", "services/light/toggle", wait)
}

lighttoggletemp(k, brightness, wait := false)
{
	homeassistantRequest("{\`"entity_id\`":\`"light.wiz_rgbw_tunable_b0afb2\`", \`"color_temp_kelvin\`":" k ", \`"brightness_pct\`": " brightness "}", "services/light/toggle", wait)
}

lighton(r, g, b, w, brightness, wait := false)
{
	homeassistantRequest("{\`"entity_id\`":\`"light.wiz_rgbw_tunable_b0afb2\`", \`"rgbw_color\`":[" r "," g "," b "," w "], \`"brightness_pct\`": " brightness "}", "services/light/turn_on", wait)
}

lightoff(wait := false)
{
	if (homeassistantGetLightState() = 0) {
		; already off
	} else {
		lighttemp(6500, 100, false) ; the light should always be reset to this value before turning off, so it turns on as expected when via other means
		Sleep(100) ; sleep so it actually does it first because yes
		homeassistantRequest("{\`"entity_id\`":\`"light.wiz_rgbw_tunable_b0afb2\`"}", "services/light/turn_off", wait)
	}
}

lighttemp(k, brightness, wait := false)
{
	homeassistantRequest("{\`"entity_id\`":\`"light.wiz_rgbw_tunable_b0afb2\`", \`"color_temp_kelvin\`":" k ", \`"brightness_pct\`": " brightness "}", "services/light/turn_on", wait)
}

; ====== hotkeys ======

^!l:: ;Control-Alt-L
{
	; Timeout duration (in milliseconds)
	timeoutDuration := 2500

	; Start the input with a timeout
	SetTimer(CheckTimeout, timeoutDuration)
	ToolTip("Light switch mode")

	; Wait for a key and run a function based on the key
	; this doesn't differentiate numpad keys and the others because its literally taking the text so like whatever
	ihkey := InputHook("L1"), ihkey.Start(), ihkey.Wait(), pressedkey := ihkey.Input

	; If a key is pressed, execute the corresponding function
	switch pressedkey {
		case "0":
			lightoff()
		case "1":
			lighton(0, 255, 0, 0, 100) ; green
		case "2":
			lighttemp(6500, 100) ; normal
		case "3":
			lighton(254, 0, 76, 13, 100) ; red purple thing
		default:
			ToolTip("invalid key")
			Sleep(1000)
			ToolTip() ;clear tooltip after 1 second
	}

	; Clear the timer if a key is pressed before timeout
	SetTimer(CheckTimeout, 0)
	ToolTip()

	CheckTimeout()
	{
		; no key
		ToolTip()
		return
	}

}

+`::~
Shift & CapsLock:: {
	; KeyWait("Shift")
	; https://www.autohotkey.com/docs/v2/lib/Send.htm#Blind
	;"Modifier keys are restored differently to allow a Send to turn off a hotkey's modifiers even if the user is still physically holding them down."
	; this ensures that the shift key is (logically) released before the delete key is pressed, even if the user is still holding shift
	Send("{Blind}{Shift Up}")
	Send("{Delete}")
}
Ctrl & CapsLock:: Send("^{BackSpace}")
^+CapsLock:: Send("!{Delete}")


Alt & CapsLock:: ; this could cause some issues on other applications, like explorer where it deletes everything in the folder
{
	; if the window is explorer (note only file explorer, but also alt tab menu i think?, and desktop), don't do anything
	if (WinActive("ahk_exe explorer.exe")) {
		ToolTip("explorer")
		Sleep(1000)
		ToolTip()
		return
	}
	; backspace entire line
	Send("{Home}{Home}{Shift Down}{End}{Shift Up}{Delete}")
}
CapsLock & e:: {

	if (!WinExist("ahk_exe Spotify.exe")) { ; if spotify isn't open, open it!
		Run(A_AppData "\Spotify\Spotify.exe")
		WinWait("ahk_exe Spotify.exe")
		Sleep(1000)
	}
	PostMessage(0x319, , 0xB0000, , "ahk_exe Spotify.exe")	 ;Send  Media_Next to spotifye
}
CapsLock & w:: {
	if (!WinExist("ahk_exe Spotify.exe")) { ; if spotify isn't open, open it!
		Run(A_AppData "\Spotify\Spotify.exe")
		WinWait("ahk_exe Spotify.exe")
		Sleep(1000)
	}
	PostMessage(0x319, , 0xE0000, , "ahk_exe Spotify.exe")	; Send Media_Play_Pause to spotify
}
CapsLock & q:: {
	if (!WinExist("ahk_exe Spotify.exe")) { ; if spotify isn't open, open it!
		Run(A_AppData "\Spotify\Spotify.exe")
		WinWait("ahk_exe Spotify.exe")
		Sleep(1000)
	}
	PostMessage(0x319, , 0xC0000, , "ahk_exe Spotify.exe")	 ;Send  Media_Prev to spotify
}
CapsLock & Space:: {
	if (!WinExist("ahk_exe Everything.exe")) {
		Run("C:\Program Files\Everything\Everything.exe")
	} else if (WinActive("ahk_exe Everything.exe")) {
		WinKill("ahk_exe Everything.exe")
	}
	else {
		WinActivate("ahk_exe Everything.exe")
	}
}
CapsLock & d:: {
	if (!WinExist("ahk_exe Discord.exe")) {
		SoundBeep(500, 150)
		Run(A_AppData "\..\Local\Discord\Update.exe")
		WinWait("ahk_exe Discord.exe")
		try WinActivate("ahk_exe Discord.exe")
	} else if (WinActive("ahk_exe Discord.exe")) {
		Send "!{Esc}" ; activate last active window
	}
	else {
		WinActivate("ahk_exe Discord.exe")
		SoundPlay("C:\Windows\Media\Speech Misrecognition.wav")
	}
}
CapsLock & i::Up
CapsLock & j::Left
CapsLock & k::Down
CapsLock & l::Right
CapsLock & u::Home
CapsLock & o::End
; CapsLock & v:: {
; 	Send("^!+{v}")
; }

CapsLock::
{
	Send("{Backspace}") ; when CapsLock released,, maybe theres a better way to do it but idk.
	SetCapsLockState("alwaysoff") ; sometimes it gets stuck on soo im adding this
}
!+e:: Send("{Media_Next}")
!+w:: Send("{Media_Play_Pause}")
!+q:: Send("{Media_Prev}")

;set num pad with num lock off
SC04F::Numpad1
SC050::Numpad2
SC051::Numpad3
SC04B::Numpad4
SC04C::Numpad5
SC04D::Numpad6
SC047::Numpad7
SC048::Numpad8
SC049::Numpad9
SC052::Numpad0
SC053::NumpadDot
NumLock::BackSpace ; i replaced the numlock key with the small backspace keycap :3


; Win+Numpad1 is run on SteamVR dashboard open (thanks to OVR advanced settings)
#Numpad1:: lighttemp(6500, 100)
; Win+Numpad2 is on dashboard close
#Numpad2:: lightoff()

; on lock
#L::
{
	; there might be multiple media trying to play, sometimes theyre being weird so do it 4 times :)
	Send("{Media_Stop}")
	Sleep(50)
	Send("{Media_Stop}")
	Sleep(250)
	Send("{Media_Stop}")
	Sleep(250)
	Send("{Media_Stop}")
	Return
}


#InputLevel 1

F13:: ; A1
{
	lighttoggletemp(6500, 100)
}
F14:: ; A2
{
	static Toggle := false
	Toggle := !Toggle
	If Toggle {
		ToolTip("Main display")
		Sleep(250)
		Run("C:\Windows\System32\DisplaySwitch.exe /internal")
		Sleep(1000)
		; tell littlebigmouse to exit
		Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --exit")
		Sleep(1000) ; this delay prevents spamming the button
		ToolTip("")
	} else {
		ToolTip("All displays")
		Sleep(250)
		Run("C:\Windows\System32\DisplaySwitch.exe /extend")
		Sleep(500)
		; tell littlebigmouse to open and start
		Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --start")
		Sleep(1000) ; this delay prevents spamming the button
		ToolTip("")
	}
}

; yt-dlp download from url
^#Down::
{
	; theres probably a better way to do this than pasting like this but whatever
	Run(A_ComSpec " /c `"" A_ScriptDir "\ytdlp\Download Video.bat`"", A_ScriptDir "\ytdlp\")
	Sleep(1000)
	Send("^v")
	Sleep(100)
	Send("{Enter}")
	Sleep(50)
	Send("#{Down}")
	Return
}

; run scrcpy
^#Right::
{
	Run(A_ScriptDir "\scrcpy\scrcpy.bat", A_ScriptDir "\scrcpy\")
}


showdesktop() {
	lastactivewindow := WinExist("A") ; get last active window
	KeyWait("LWin") ; wait for windows key to be released, so it doesnt get picked up by the inputhook
	WinMinimizeAll() ; minimize all windows (like pressing win+d)
	; move rainmeter clock to center of second monitor
	Run("`"C:\Program Files\Rainmeter\Rainmeter.exe`" [!HideFade `"Elegant Clock`"][!Update]")
	Sleep(500)
	Run("`"C:\Program Files\Rainmeter\Rainmeter.exe`" [!SetWindowPosition `"50%@2`" `"20%@2`" `"63%`" `"58%`" `"Elegant Clock`"][!Update]")
	Sleep(500)
	Run("`"C:\Program Files\Rainmeter\Rainmeter.exe`" [!ShowFade `"Elegant Clock`"][!Update]")


	; await any input or other key
	ihkey := InputHook("L1 M", "{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}"), ihkey.Start(), ihkey.Wait(), pressedkey := ihkey.Input

	showdesktopundo(lastactivewindow)

}

showdesktopundo(lastactivewindow) {
	Run("`"C:\Program Files\Rainmeter\Rainmeter.exe`" [!HideFade `"Elegant Clock`"][!Update]")
	WinMinimizeAllUndo() ; undo minimize all
	lightoff()
	Sleep(100)
	try WinActivate("ahk_id " lastactivewindow) ; activate last active window
	WinSetAlwaysOnTop(0) ; what the fuck why does it make it alwaysontop??? are they stupid?

	; ensure spotify and discord are restored, as they are always open on second monitor
	If (WinGetMinMax("ahk_exe Spotify.exe") = -1) {
		try WinRestore("ahk_exe Spotify.exe")
	}
	If (WinGetMinMax("ahk_exe Discord.exe") = -1) {
		try WinRestore("ahk_exe Discord.exe")
	}
	Sleep(500)
	; MsgBox("hello world")
	Run("`"C:\Program Files\Rainmeter\Rainmeter.exe`" [!SetWindowPosition `"75%@2`" `"20%@2`" `"63%`" `"58%`" `"Elegant Clock`"][!Update]")
	Run("`"C:\Program Files\Rainmeter\Rainmeter.exe`" [!ShowFade `"Elegant Clock`"][!Update]")
}

~LButton:: ; ~ means dont block the original key.
; this replaces the show desktop button in the bottom right corner of the screen, so it should be disabled in the taskbar settings
{
	; get mouse position
	MouseGetPos(&xpos, &ypos)
	; ToolTip("x: " xpos "`ny: " ypos)
	; 2559, 1439 -> 2560, 1440
	if (xpos >= A_ScreenWidth - 2 && ypos >= A_ScreenHeight - 2 && xpos <= A_ScreenWidth && ypos <= A_ScreenHeight) {
		; if mouse is in the bottom right corner, show desktop
		; MsgBox("hello world")
		showdesktop()
	}
}

#d::
{
	showdesktop()
}
!#d::
{
	WinMinimizeAll()
}

; ====== per app hotkeys ======


#HotIf WinActive("Hammer - ")
F21::z

#HotIf WinActive("Counter-Strike: Global Offensive",)
F24:: MouseClick("left")

#HotIf WinActive("Grand Theft Auto V",)
F24::Tab
F23::Insert
F22::End
F21::#

#HotIf WinActive("PLAYERUNKNOWN",)
F24::Home
F23::Insert
F22::End
F21::#

#HotIf WinActive("Rainbow Six",)
F24::Home
F23::Insert
F22::End
F21::]

#HotIf WinActive("Lunar Client",)
F24::Tab
F23::Insert
F22::End
F21::#
XButton1::[
XButton2::]

#HotIf WinActive("VALORANT",)
CapsLock::#

#HotIf WinActive("paint.net",)
XButton2::]
XButton1::[
F22::
{
	Send("k")
	Click()
}
!WheelUp::]
!WheelDown::[

#HotIf WinActive("ahk_exe firefox.exe")
; stolen from u/also_charlie https://www.reddit.com/r/AutoHotkey/comments/1516eem/heres_a_very_useful_script_i_wrote_to_assign_5/
F23::
{
	moveval := 0

	pixeldist := 5
	largepixeldist := 1000

	If GetKeyState("F23", "p") {
		MouseGetPos(&x1, &y1)
		KeyWait("F23")
	}

	MouseGetPos(&x2, &y2)

	XDif := (x2 - x1)
	YDif := (y2 - y1)

	If (abs(XDif) >= abs(YDif)) {

		If (abs(XDif) >= largepixeldist) {


			If (XDif >= (largepixeldist * 2))
				moveval := 1
			If (XDif <= -largepixeldist)
				moveval := 2
		}
		else {

			If (XDif >= pixeldist)
				moveval := 5
			If (XDif <= -pixeldist)
				moveval := 6
		}
	}
	else {

		If (abs(YDif) >= largepixeldist) {

			If (YDif >= largepixeldist)
				moveval := 3
			If (YDif <= -largepixeldist)
				moveval := 4
		}
		else {

			If (YDif >= pixeldist)
				moveval := 7
			If (YDif <= -pixeldist)
				moveval := 8
		}
	}

	{
		if (moveval = 0) ; no movement
			Send("^{LButton}")
		if (moveval = 1) ; Big Right
			Send("!{right}")
		if (moveval = 2) ; Big Left
			Send("!{left}")
		if (moveval = 3) ; Big Down
			Send("^l")
		if (moveval = 4) ; Big Up
			Send("+^t")
		if (moveval = 5) ; Right
			Send("^{tab}")
		if (moveval = 6) ; Left
			Send("^+{tab}")
		if (moveval = 7) ; Down
			Send("^w")
		if (moveval = 8) ; Up
			Send("^t")
	}
}

; #HotIf WinActive("ahk_exe Code.exe")
; Alt & CapsLock::
; {
; 	; delete line (ctrl + shift + k)
; 	Send("^+k")
; 	; insert a new line above (ctrl + shift + enter)
; 	Send("^+{Enter}")
; }

; reload the script when its saved
#HotIf WinActive(A_ScriptName "ahk_exe Code.exe")
^s::
{
	Send("^s")
	Reload()
	MsgBox("reloading !")
	Return
}