; main script.
; what an awfully long and complex script but weird things happen if i split it into littler ones and idk how to fix that so there we go
#Requires AutoHotkey v2.0.4

; something because of weird dpi scaling issues
; see https://www.autohotkey.com/boards/viewtopic.php?t=73780
; https://www.autohotkey.com/boards/viewtopic.php?f=14&t=13810
; DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
; nvm
; Directly moving the mouse across monitors can be an issue with littlebigmouse,
; either move the mouse across monitor then exact position (move twice or to 0,0 then the correct position)
; or disable littlebigmouse temporarily (but its probably better and easier to do the first option)

TraySetIcon(A_ScriptDir "\icon\ahkpurple16.ico")

; ----- Current F13-24 Binds ----- (also in readme.md)
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


; include librarys
; Include jsongo to use it
#Include includes\jsongo.v2.ahk

; Peep() is a function that allows you to view the contents of any object
; https://github.com/GroggyOtter/PeepAHK
#Include includes\Peep.v2.ahk

; run other script (this could be #Include, but i dont want it to clog the log for this one!)
Run(".\apploop.ahk")


; ===== this all runs when script is started:

SetTitleMatchMode(2) ;A window's title can contain WinTitle anywhere inside it to be a match.
Persistent(true) ; dont close the script even if no threads are running
;keeps num and caps off permanently
SetCapsLockState("AlwaysOff")
SetNumlockState("AlwaysOff")
SetDefaultMouseSpeed(0)
CoordMode("Mouse")
CoordMode("ToolTip")
SetWorkingDir(A_ScriptDir) ; Ensures a consistent starting directory.
#SingleInstance Force


; if not admin, start as admin
; taken from https://www.autohotkey.com/boards/viewtopic.php?p=523250#p523250
if (!A_IsAdmin)
{
	try {
		; MsgBox("Running as admin...")
		Run("*RunAs `"" A_ScriptFullPath "`"")
	}
	catch {
		MsgBox("Couldn't run " A_ScriptName " as admin! Some things may not work")
	}
}


; #WinActivateForce
; https://www.autohotkey.com/docs/v2/lib/_WinActivateForce.htm
; "it might prevent task bar buttons from flashing when different windows are activated quickly one after the other.""


; read secrets, this runs on script start so the script must be restarted to update the token
homeassistantToken := Fileread("secrets\homeassistant.txt") ; load the token from file

; set display on start
if (MonitorGetCount() = 1 or MonitorGetCount() = 3) { ; if 1 or 3 monitors are on
	; Run("C:\Windows\System32\DisplaySwitch.exe /extend") ; set windows display to "extend"
	; load default profile with MonitorSwitcher.exe
	RunWait(A_ScriptDir "/monitor/MonitorProfileSwitcher/MonitorSwitcher.exe -load:myprofile.xml", A_ScriptDir "/monitor/MonitorProfileSwitcher/")
	Sleep(10000)
	; tell littlebigmouse to open and start
	Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --start")
}


; MsgBox(A_AhkVersion)

ProcessSetPriority("H") ; set priority to high.
; Low (or L)
; BelowNormal (or B)
; Normal (or N)
; AboveNormal (or A)
; High (or H)
; Realtime (or R)
; this chooses the script itself- https://www.autohotkey.com/docs/v2/lib/ProcessSetPriority.htm "If unset or omitted, the script's own process is used"

; run with an argument (1) to skip my "run as admin" warning in the bat script. (it is ran with admin if this script is.)
Run(A_ComSpec " /C " A_ScriptDir "\synctime.bat 1", A_ScriptDir, "Hide") ; run sync time script


; =========== functions ===========

; runs a command and returns the stdout
JEE_RunGetStdOut(vTarget, vSize := "")
{
	DetectHiddenWindows(true)
	vComSpec := A_ComSpec ? A_ComSpec : A_ComSpec
	Run(vComSpec, , "Hide", &vPID)
	WinWait("ahk_pid " vPID)
	DllCall("kernel32\AttachConsole", "UInt", vPID)
	oShell := ComObject("WScript.Shell")
	oExec := oShell.Exec(vTarget)
	vStdOut := ""
	if !(vSize = "")
		VarSetStrCapacity(&vStdOut, vSize) ; V1toV2: if 'vStdOut' is NOT a UTF-16 string, use 'vStdOut := Buffer(vSize)'
	while !oExec.StdOut.AtEndOfStream
		vStdOut := oExec.StdOut.ReadAll()
	DllCall("kernel32\FreeConsole")
	ProcessClose(vPID)
	DetectHiddenWindows(false)
	return vStdOut
}

switchFancyZonesLayout(monitor := 0, layout := 1)
{
	; MsgBox(layout)
	CoordMode("Mouse")
	MouseGetPos &xpos, &ypos
	Sleep 10
	MouseMove(monitor * A_ScreenWidth + 100, 100)
	Sleep 100
	; two := 2
	Send("{Ctrl Down}{LWin Down}{LAlt Down}" layout "{Ctrl Up}{LWin Up}{LAlt Up}")
	Sleep 100
	; MouseMove(0, 0)
	MouseMove(xpos, ypos)
	MouseMove(xpos, ypos)
}

restartExplorer() {
	RunWait("taskkill.exe /F /IM Explorer.exe", , "Hide")
	Sleep(3000)
	Run("Explorer.exe")
}

; ===== home assistant functions
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
homeassistantGet(url) {
	global homeassistantToken
	try {
		output := jsongo.Parse(JEE_RunGetStdOut(A_ComSpec " /c curl -H `"Authorization: Bearer " homeassistantToken "`" -H `"Content-Type: application/json`" http://homeassistant.local:8123/api/" url))
	} catch as e {
		ToolTip("could not connect to home assistant!")
		SetTimer () => ToolTip(), -5000
		output := -1
	}
	return output
	; return ComObject("WScript.Shell").Exec("curl -H `"Authorization: Bearer " homeassistantToken "`" -H `"Content-Type: application/json`" http://homeassistant.local:8123/api/" url).StdOut.ReadAll()
}

homeassistantGetLightState(light, request := homeassistantGet("states/light." light))
{
	if (request = -1) {
		return 0
	}

	; Peep(object)
	state := request['state']
	; MsgBox(state)
	if (state = "on") {
		return 1
	} else if (state = "off") {
		return 0
	}
	else {
		return -1
	}

}

; returns a temp in kelvin, or -1 if the light is off or doesn't have a colour temp
homeassistantGetLightTemp(light, request := homeassistantGet("states/light." light))
{
	if (homeassistantGetLightState(light, request)) {
		if (homeassistantGetLightColorMode(light, request) = "color_temp") {
			state := request['attributes']['color_temp_kelvin']
			; Peep(state)
			return Number(state)
		} else {
			; theres no colour temps in rgbw or other modes
			return -1
		}
	} else {
		; the light is off and doesn't have a colour temp
		ToolTip("-1")
		return -1
	}
	return 0
}

homeassistantGetLightColorMode(light, request := homeassistantGet("states/light." light))
{
	if (homeassistantGetLightState(light, request))
	{
		; if on
		return request['attributes']['color_mode']
	} else {
		return "off"
	}

}

; sometimes setting the light temp isn't exact, and getting it returns a slightly different value, so use this.
homeassistantGetLightTempApprox(light, temp, request := homeassistantGet("states/light." light)) {
	state := homeassistantGetLightTemp(light, request)
	if (state = -1) {
		return false
	} else {
		if (state > temp - 50 && state < temp + 50) {
			return true
		} else {
			return false
		}
	}
}

lighttoggle(r, g, b, w, brightness, wait := false)
{
	; remember that `" is the escape for " within autohotkey, a \ escapes that " for the CMD that runs
	; so CMD sees (eg) {\"entity_id\":\"light.lilys_light\"}
	; which then curls {"entity_id":"light.lilys_light"}
	; autohotkey inherently concatenates strings, so within the rgbw_color array, the main "" ends so it can concatenate the variable.
	; yes its complicated and i'll probably have to relearn everything next time i want to touch this 😭😭
	; it's possible some of the " are avoidable, but i really do not want to do this any longer

	; this toggle function includes a rgbw and brightness, because it still sets the light to these if turning on
	homeassistantRequest("{\`"entity_id\`":\`"light.lilys_light\`", \`"rgbw_color\`":[" r "," g "," b "," w "], \`"brightness_pct\`": " brightness "}", "services/light/toggle", wait)
}

lighttoggletemp(k, brightness, wait := false)
{
	homeassistantRequest("{\`"entity_id\`":\`"light.lilys_light\`", \`"color_temp_kelvin\`":" k ", \`"brightness_pct\`": " brightness "}", "services/light/toggle", wait)
}

lightontemp(k, brightness, wait := false)
{
	homeassistantRequest("{\`"entity_id\`":\`"light.lilys_light\`", \`"color_temp_kelvin\`":" k ", \`"brightness_pct\`": " brightness "}", "services/light/turn_on", wait)
}

lighton(r, g, b, w, brightness, wait := false)
{
	homeassistantRequest("{\`"entity_id\`":\`"light.lilys_light\`", \`"rgbw_color\`":[" r "," g "," b "," w "], \`"brightness_pct\`": " brightness "}", "services/light/turn_on", wait)
}

lightoff(wait := false)
{
	if (homeassistantGetLightState("lilys_light") = 0) {
		; already off
		; ToolTip("Already off")
	} else {
		lighttemp(6500, 100, false) ; the light should always be reset to this value before turning off, so it turns on as expected when via other means
		Sleep(100) ; sleep so it actually does it first because yes
		homeassistantRequest("{\`"entity_id\`":\`"light.lilys_light\`"}", "services/light/turn_off", wait)
	}
}

lightoff2() {
	homeassistantRequest("{\`"entity_id\`":\`"light.lilys_light\`"}", "services/light/turn_off", false)
}

lighttemp(k, brightness, wait := false)
{
	homeassistantRequest("{\`"entity_id\`":\`"light.lilys_light\`", \`"color_temp_kelvin\`":" k ", \`"brightness_pct\`": " brightness "}", "services/light/turn_on", wait)
}


; ===== explorer stuff

; Get the WebBrowser object of the active Explorer tab for the given window,
; or the window itself if it doesn't have tabs.  Supports IE and File Explorer.
GetActiveExplorerTab(hwnd := WinExist("A")) { ; from https://www.autohotkey.com/boards/viewtopic.php?f=83&t=109907
	activeTab := 0
	try activeTab := ControlGetHwnd("ShellTabWindowClass1", hwnd) ; File Explorer (Windows 11)
	catch
		try activeTab := ControlGetHwnd("TabWindowClass1", hwnd) ; IE
	for w in ComObject("Shell.Application").Windows {
		if w.hwnd != hwnd
			continue
		if activeTab { ; The window has tabs, so make sure this is the right one.
			static IID_IShellBrowser := "{000214E2-0000-0000-C000-000000000046}"
			shellBrowser := ComObjQuery(w, IID_IShellBrowser, IID_IShellBrowser)
			ComCall(3, shellBrowser, "uint*", &thisTab := 0)
			if thisTab != activeTab
				continue
		}
		return w
	}
}
;
GetParentFolder(path) {
	splitpath := StrSplit(path, "\")
	splitpath.Pop() ; remove the last element (filename)
	Str := ""
	For Index, Value In splitpath
		Str .= Value . "\"
	; Str := RTrim(Str, "\") ; remove the last slash
	return Str
}
GetFileName(pathOrFile) { ; get name without extension
	filename := GetFileNameAndExtension(pathOrFile)
	splitname := StrSplit(filename, ".")
	; combine all elements except the last one
	Str := ""
	For Index, Value In splitname
		if (Index != splitname.Length)
			Str .= Value . "."
	Str := RTrim(Str, ".") ; remove the last dot
	return Str
}
GetFileExtension(pathOrFile) {
	filename := GetFileNameAndExtension(pathOrFile)
	splitname := StrSplit(filename, ".")
	extension := splitname[splitname.Length]
	return extension
}
GetFileNameAndExtension(pathOrFile) {
	splitpath := StrSplit(pathOrFile, "\")
	filename := splitpath[splitpath.Length]
	return filename
}


; =========== hotkeys ===========

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
	; Send("{Shift Up}")
	Send("{Delete}")
	Send("{Shift Up}") ; sometimes, shift gets stuck? my hope is that this fixes that.
	; Send("{Shift Up}{Delete}")
}

; ^+CapsLock:: Send("!{Delete}")


; Alt & CapsLock:: ; this could cause some issues on other applications, like explorer where it deletes everything in the folder
; {
; 	; if the window is explorer (note only file explorer, but also alt tab menu i think?, and desktop), don't do anything
; 	if (WinActive("ahk_exe explorer.exe")) {
; 		ToolTip("explorer")
; 		Sleep(1000)
; 		ToolTip()
; 		return
; 	}
; 	; backspace entire line
; 	Send("{Home}{Home}{Shift Down}{End}{Shift Up}{Delete}")
; }
CapsLock & e:: {

	if (!WinExist("ahk_exe Spotify.exe")) { ; if spotify isn't open, open it!
		Run(A_AppData "\Spotify\Spotify.exe")
		WinWait("ahk_exe Spotify.exe")
		Sleep(1000)
	}
	PostMessage(0x319, , 0xB0000, , "ahk_exe Spotify.exe")	 ;Send  Media_Next to spotifye
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
	; if (!WinExist("ahk_exe Everything.exe")) {
	; 	Run("C:\Program Files\Everything\Everything.exe")
	; } else if (WinActive("ahk_exe Everything.exe")) {
	; 	WinKill("ahk_exe Everything.exe")
	; }
	; else {
	; 	WinActivate("ahk_exe Everything.exe")
	; }
	Send("{Alt Down}{P Down}{Alt Up}{P Up}")
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
CapsLock & Tab::Enter

; keyboard switching
; in "Text Services and Input Languages", English is LAlt + Shift + 1
; Japanese is LAlt + Shift + 2
; ~ means dont block from system
CapsLock & z:: { ; english layou
	SetCapsLockState("Off")
	KeyWait("CapsLock")
	Send("!+1")
	SetCapsLockState("AlwaysOff")
}

CapsLock & x:: { ; japanese hiragana layout
	SetCapsLockState("Off")
	KeyWait("CapsLock")
	Send("!+2")
	Send("^{CapsLock}")
	SetCapsLockState("AlwaysOff")

}
CapsLock & c:: { ; japanese katakana layout
	SetCapsLockState("Off")
	KeyWait("CapsLock")
	Send("!+2")
	Send("!{CapsLock}")
	SetCapsLockState("AlwaysOff")

}
;


#HotIf (GetKeyState("CapsLock", "P") AND !GetKeyState("Alt", "P"))
d:: {
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
w:: {
	if (!WinExist("ahk_exe Spotify.exe")) { ; if spotify isn't open, open it!
		Run(A_AppData "\Spotify\Spotify.exe")
		WinWait("ahk_exe Spotify.exe")
		Sleep(1000)
	}
	PostMessage(0x319, , 0xE0000, , "ahk_exe Spotify.exe")	; Send Media_Play_Pause to spotify
}
#HotIf

; *CapsLock:: { ; why do this over CapsLock::Backspace? am i dumb??? ok i think it was for koroebi which i dont use anymore so idk

; 	KeyWait("CapsLock")
; 	if (A_ThisHotkey = "*CapsLock")
; 		Send("{BackSpace}")
; 	SetCapsLockState("Off")
; 	SetCapsLockState("AlwaysOff")
; 	Return
; }

; omg this used to be :: send backspace
; but this seems to work much better, ctrl + capslock works and doesnt have to be specifically defined
; that got stuck a lot, so hopefully this is better
CapsLock::BackSpace


!+e:: Send("{Media_Next}")
!+w:: Send("{Media_Play_Pause}")
!+q:: Send("{Media_Prev}")

;set num pad with num lock off (so the numlock light is disabled)
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
NumLock & SC049:: {
	send("hi")
}
NumLock & NumpadEnter:: {
	; msgbox("Hi")
	run(A_ScriptDir "\startobs.ahk")
}
NumLock::BackSpace ; i replaced the numlock key with the small backspace keycap :3


; Win+Numpad1 is run on SteamVR dashboard open (thanks to OVR advanced settings)
#Numpad1:: lighttemp(6500, 25)
; Win+Numpad2 is on dashboard close
#Numpad2:: lightoff2()

; on lock
#l::
{
	Run("taskkill /im obs64.exe", , "Hide")

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
#!L::
{

	; there might be multiple media trying to play, sometimes theyre being weird so do it 4 times :)
	Send("{Media_Stop}")
	Sleep(50)
	Send("{Media_Stop}")
	Sleep(250)
	Send("{Media_Stop}")
	Sleep(250)
	Send("{Media_Stop}")
	KeyWait "LWin"
	KeyWait "L"
	KeyWait "LShift"
	DllCall("LockWorkStation")
	Return
}

F1::
{
}


#InputLevel 1
F13:: ; A1
{
	static presses := 0
	if presses > 0 ; SetTimer already started, so we log the keypress instead.
	{
		presses += 1
		ToolTip(presses)
		SetTimer aftertime ; reset the timer after each press
		return
	}
	; Otherwise, this is the first press of a new series. Set count to 1 and start
	; the timer:
	presses := 1
	SetTimer aftertime, -400 ; Wait for more presses within a 400 millisecond window.
	aftertime()
	{
		request := homeassistantGet("states/light.lilys_light")
		; MsgBox(request)
		switch presses {
			case 1: ; The key was pressed once. this turns the light to 6500, 100% if the light is not at that already, otherwise it turns it off
				{
					; if light on already, just turn it off
					if (homeassistantGetLightState("lilys_light", request)) {
						lightoff2()
					} else {
						; MsgBox("light is not at 6500")
						lightontemp(6500, 100)
					}
				}
			case 2: ; The key was pressed twice.
				{
					if (homeassistantGetLightTempApprox("lilys_light", 2700, request)) {
						lightoff()
					} else {
						lightontemp(2700, 25)
					}
				}
			case 3:
			{
				; if (homeassistantGetLightState("hue_color_lamp_1", request)) {
				; 	lightoff2()
				; } else {
				; 	; MsgBox("light is not at 6500")
				; 	lightontemp(6500, 100)
				; }
			}
			case 5:
			{
				lighton(255, 0, 0, 0, 100)
			}
			case 6:
			{
				lighton(50, 25, 255, 0, 100)
			}
			default:
			{
				lightoff()
			}
		}
		; Regardless of which action above was triggered, reset the count to
		; prepare for the next series of presses:
		presses := 0
		ToolTip
	}
}
F14:: ; A2
{
	; static Toggle := false
	; Toggle := !Toggle
	; If Toggle {
	; 	ToolTip("Main display")
	; 	Sleep(250)
	; 	Run("C:\Windows\System32\DisplaySwitch.exe /internal")
	; 	Sleep(1000)
	; 	; tell littlebigmouse to exit
	; 	Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --exit")
	; 	Sleep(1000) ; this delay prevents spamming the button
	; 	ToolTip("")
	; } else {
	; 	ToolTip("All displays")
	; 	Sleep(250)
	; 	Run("C:\Windows\System32\DisplaySwitch.exe /extend")
	; 	Sleep(500)
	; 	; tell littlebigmouse to open and start
	; 	Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --start")
	; 	Sleep(1000) ; this delay prevents spamming the button
	; 	ToolTip("")
	; }
	; maybe use ? http://www.nirsoft.net/utils/multi_monitor_tool.html
	; this is to toggle between two monitorswitcher profiles. the xml might have to created with `MonitorSwitcher.exe -save:myprofileX.xml` while in the correct layout in windows.
	static Toggle := false
	KeyWait("F14") ; wait for key to be released
	ToolTip("Are you sure you want to switch display mode? Press button again to confirm.`nCurrently: " (Toggle ? "TV" : "Main"), A_ScreenWidth / 2, A_ScreenHeight / 2)
	if (KeyWait("F14", "D T5") = 0) {
		ToolTip("Cancelled", A_ScreenWidth / 2, A_ScreenHeight / 2)
		Sleep(2000)
		ToolTip()
		return
	}
	ToolTip()

	Toggle := !Toggle
	If Toggle {
		ToolTip("TV display")
		Sleep(250)
		; Run("C:\Windows\System32\DisplaySwitch.exe /internal")
		RunWait(A_ScriptDir "/monitor/MonitorProfileSwitcher/MonitorSwitcher.exe -load:myprofile2.xml", A_ScriptDir "/monitor/MonitorProfileSwitcher/")
		Sleep(2000)
		; doing this often causes a lot of issues, so restart explorer for good measure (i mean displayport takes so long to wake up that this'll probably be ran before the monitors even turn on)
		; restartExplorer()
		; kill spotify because it sometimes just starts playing idk
		RunWait("taskkill.exe /F /IM Spotify.exe", , "Hide")
		Sleep(10000)
		; restart littlebigmouse, it can wait to ensure everything is settled
		Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --exit")
		Sleep(1000)
		homeassistantRequest("{\`"entity_id\`":\`"switch.lily_monitor\`"}", "services/switch/turn_off", true)
		ToolTip("")
	} else {
		ToolTip("Main displays")
		homeassistantRequest("{\`"entity_id\`":\`"switch.lily_monitor\`"}", "services/switch/turn_on", true)
		Sleep(15000)
		RunWait(A_ScriptDir "/monitor/MonitorProfileSwitcher/MonitorSwitcher.exe -load:myprofile.xml", A_ScriptDir "/monitor/MonitorProfileSwitcher/")
		Sleep(5000)
		; doing this often causes a lot of issues, so restart explorer for good measure
		; restartExplorer()
		Sleep(1000)
		Sleep(5000)
		; restart littlebigmouse
		Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --start")
		Sleep(1000)
		ToolTip("")
	}


}
F15:: ; A3
{
	MouseGetPos &xpos, &ypos
	MsgBox("current window: " WinGetProcessName(WinActive("A")) "`nMouse Position (Screen) " xpos ", " ypos "at dpi " A_ScreenDPI " ")
	; MsgBox(homeassistantGetLightTemp("lilys_light"))
}
F16:: ;"Mode" key
{ ; adjust FancyZones zones on second monitor
	static presses := 0
	if presses > 0 ; SetTimer already started, so we log the keypress instead.
	{
		presses += 1
		ToolTip(presses)
		SetTimer aftertime ; reset the timer after each press
		return
	}
	; Otherwise, this is the first press of a new series. Set count to 1 and start
	; the timer:
	presses := 1
	SetTimer aftertime, -400 ; Wait for more presses within a 400 millisecond window.
	aftertime()
	{
		Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --exit")
		; request := homeassistantGet("states/light.lilys_light")
		; MsgBox(request)
		; MsgBox(presses)
		switchFancyZonesLayout(1, presses)
		; Regardless of which action above was triggered, reset the count to
		; prepare for the next series of presses:
		presses := 0
		ToolTip
		Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --start")
	}
}


; yt-dlp download from url
^#Down::
{
	; KeyWait("Down") ; wait for the key to be released so it doesnt mess stuff up
	; ; theres probably a better way to do this than pasting like this but whatever
	; nvm just launch it cause yea :3
	Run(A_ComSpec " /c `"" A_ScriptDir "\ytdlp\Download Video.bat`"", A_ScriptDir "\ytdlp\")
	; Sleep(1000)
	; Send("^v")
	; Sleep(100)
	; Send("{Enter}")
	; Sleep(100)
	; Send("#{Down}")
	Return
}
; run scrcpy
^#Right::
{
	Run(A_ScriptDir "\scrcpy\scrcpy.bat", A_ScriptDir "\scrcpy\")
}
showdesktop(undo := true) {
	lastactivewindow := WinExist("A") ; get last active window
	; KeyWait("LWin") ; wait for windows key to be released, so it doesnt get picked up by the inputhook
	WinMinimizeAll() ; minimize all windows (like pressing win+d)
	; move rainmeter clock to center of second monitor
	; but first fade it out, move it, then fade it back in so its pretty
	moveclockmiddle()
	if (undo) {
		; await any input or other key
		ihkey := InputHook("L1 M", "{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}"), ihkey.Start(), ihkey.Wait(), pressedkey := ihkey.Input
		; ihkey := InputHook("L1 M", "{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}"), ihkey.Start(), ihkey.Wait(), pressedkey := ihkey.Input
		showdesktopundo(lastactivewindow)
	} else {
		return lastactivewindow
	}
}
moveclockmiddle() {
	Run("`"C:\Program Files\Rainmeter\Rainmeter.exe`" [!HideFade `"Elegant Clock`"][!Update]")
	Sleep(250)
	Run("`"C:\Program Files\Rainmeter\Rainmeter.exe`" [!SetWindowPosition `"50%@2`" `"20%@2`" `"63%`" `"58%`" `"Elegant Clock`"][!Update]")
	Sleep(250)
	Run("`"C:\Program Files\Rainmeter\Rainmeter.exe`" [!ShowFade `"Elegant Clock`"][!Update]")
}
showdesktopundo(lastactivewindow) {
	Run("`"C:\Program Files\Rainmeter\Rainmeter.exe`" [!HideFade `"Elegant Clock`"][!Update]")
	WinMinimizeAllUndo() ; undo minimize all
	Sleep(100)
	try WinActivate("ahk_id " lastactivewindow) ; activate last active window
	; MsgBox("hello world")
	Run("`"C:\Program Files\Rainmeter\Rainmeter.exe`" [!SetWindowPosition `"75%@2`" `"20%@2`" `"63%`" `"58%`" `"Elegant Clock`"][!Update]")
	Run("`"C:\Program Files\Rainmeter\Rainmeter.exe`" [!ShowFade `"Elegant Clock`"][!Update]")
	lightoff()
}
~LButton:: ; ~ means dont block the original key.
; this replaces the show desktop button in the bottom right corner of the screen, so it should be disabled in the taskbar settings
{
	; get mouse position
	MouseGetPos(&xpos, &ypos)
	; ToolTip("x: " xpos "`ny: " ypos)
	; 2559, 1439 -> 2560, 1440
	if (xpos >= A_ScreenWidth - 2 && ypos >= A_ScreenHeight - 2 && xpos <= A_ScreenWidth && ypos <= A_ScreenHeight && !WinExist("ahk_exe FortniteClient-Win64-Shipping.exe") && !WinExist("ahk_exe Palworld-Win64-Shipping.exe")) {
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
	Send("#d")
}
#f::
{
	; if either spotify or discord are visible, ensure both are minimized
	if ((WinExist("ahk_exe Spotify.exe") && WinGetMinMax() != -1) || (WinExist("ahk_exe Discord.exe") && WinGetMinMax() != -1)) {
		try WinMinimize("ahk_exe Spotify.exe")
		try WinMinimize("ahk_exe Discord.exe")
		moveclockmiddle()
	} else {
		; otherwise, ensure both are restored
		Run("`"C:\Program Files\Rainmeter\Rainmeter.exe`" [!HideFade `"Elegant Clock`"][!Update]")
		try WinRestore("ahk_exe Spotify.exe")
		try WinRestore("ahk_exe Discord.exe")
		Run("`"C:\Program Files\Rainmeter\Rainmeter.exe`" [!SetWindowPosition `"75%@2`" `"20%@2`" `"63%`" `"58%`" `"Elegant Clock`"][!Update]")
		Run("`"C:\Program Files\Rainmeter\Rainmeter.exe`" [!ShowFade `"Elegant Clock`"][!Update]")
	}
}
#s::
{
	Send("#d")
}

; these are alt-gr + hotkeys
<^>!3::
{
	Send("¥")
}
<!>!5::
{
	Send("§")
}
<^>!8:: ; alt-gr + 8
{
	Send("°")
}
<^>!Space:: {
	Send("　")
}
<^>!Right:: {
	Send("→")
}
<^>!Left:: {
	Send("←")
}
<^>!Up:: {
	Send("↑")
}
<^>!Down:: {
	Send("↓")
}
<^>!y:: {
	Send("✓")
}
<^>!x:: {
	Send("✗")
}
<^>!\:: {
	Send("＼")
}
<^>!/:: {
	Send("／")
}
;

; If (WinExist("ahk_exe Spotify.exe") && WinGetMinMax() != -1) {
; 	try WinMinimize("ahk_exe Spotify.exe")
; } else {
; 	try WinRestore("ahk_exe Spotify.exe")
; }
; If (WinExist("ahk_exe Discord.exe") && WinGetMinMax() != -1) {f
; 	try WinMinimize("ahk_exe Discord.exe")
; } else {
; 	try WinRestore("ahk_exe Discord.exe")
; }
; }
; ====== per app hotkeys ======
#HotIf WinActive("Hammer - ahk_exe cs2.exe")
F22::]
F23::[
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
#HotIf WinActive("Risk of Rain 2",)
F21::Ctrl
#HotIf WinActive("ahk_exe firefox.exe")
^+8::
{
	Send("@lillliieieiee.anonaddy.me")
}

f1::
{
	switchFancyZonesLayout(1, 2)
	Send("!{F1}") ; detach tab using tabdetach https://addons.mozilla.org/en-GB/firefox/addon/tabdetach/

}

; stolen from u/also_charlie https://www.reddit.com/r/AutoHotkey/comments/1516eem/heres_a_very_useful_script_i_wrote_to_assign_5/
F23:: ; DPI Down / G7
{
	try {
		moveval := 0
		pixeldist := 5
		largepixeldist := 500
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
			; close tabs shortcuts https://addons.mozilla.org/en-GB/firefox/addon/close-tabs-shortcuts/
			if (moveval = 1) ; Big Right
				Send("!+{F2}") ; close tabs to the right
			if (moveval = 2) ; Big Left
				Send("!+{F1}") ; close tabs to the left
			;
			if (moveval = 3) ; Big Down
				Send("^w")
			if (moveval = 4) ; Big Up
				Send("+^t")
			if (moveval = 5) ; Right
				Send("^{tab}")
			if (moveval = 6) ; Left
				Send("^+{tab}")
			if (moveval = 7) ; Down
				Send("^w")
			if (moveval = 8) ; Up
				Send("^l") ; select address bar
		}
	}
}
#HotIf WinActive("ahk_exe Code.exe")
F23:: ; DPI Down / G7
{
	moveval := 0
	pixeldist := 5
	largepixeldist := 500
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
		; close tabs shortcuts set in settings
		if (moveval = 1) ; Big Right
			Send("!+{F2}") ; close tabs to the right
		if (moveval = 2) ; Big Left
			Send("!+{F1}") ; close tabs to the left
		;
		if (moveval = 3) ; Big Down
			Send("^w")
		if (moveval = 4) ; Big Up
			Send("+^t")
		if (moveval = 5) ; Right
			Send("^{PgDn}")
		if (moveval = 6) ; Left
			Send("^{PgUp}")
		if (moveval = 7) ; Down
			Send("^w")
		if (moveval = 8) ; Up
			Send("^+p") ; select address bar
	}
}
#HotIf WinActive("ahk_class CabinetWClass ahk_exe explorer.exe") ; Only run if Explorer is active
; CapsLock & .:: { ; unzip selected archive(s) (buggy and laggy so commented out :)
; 	tab := GetActiveExplorerTab() ; get the active windows 11 explorer tab
; 	switch type(tab.Document) {
; 		case "ShellFolderView":
; 			{
; 				SelectedItems := tab.Document.SelectedItems ; get selected items
; 				; MsgBox ; debug info
; 				; (
; 				;     "Variant type:`t" ComObjType(d) "
; 				;     Interface name:`t" ComObjType(d, "Name") "
; 				;     Interface ID:`t" ComObjType(d, "IID") "
; 				;     Class name:`t" ComObjType(d, "Class") "
; 				;     Class ID (CLSID):`t" ComObjType(d, "CLSID")
; 				; )
; 				numberofselecteditems := 0
; 				for folderItem, b in SelectedItems {
; 					numberofselecteditems++
; 				}
; 				for folderItem, b in SelectedItems { ; https://learn.microsoft.com/en-us/windows/win32/shell/folderitem
; 					; MsgBox folderItem.Path ;
; 					path := folderItem.Path
; 					parentfolder := GetParentFolder(path)
; 					filename := GetFileName(path)
; 					newfoldername := filename
; 					fileextension := GetFileExtension(path)
; 					; test if file can be extracted
; 					; testOutput := ComObject("WScript.Shell").Exec("7z t `"" path "`"").StdOut.ReadAll()
; 					testOutput := JEE_RunGetStdOut(A_ComSpec " /c 7z t `"" path "`"")
; 					Peep(testOutput)
; 					; if testoutput contains "Everything is Ok"
; 					if (InStr(testOutput, "Everything is Ok")) {
; 						; MsgBox("File can be extracted: " path)
; 					} else {
; 						MsgBox("File cannot be extracted: " path "`nIt may be corrupt or this archive format is not supported.", , "0x30")
; 						continue
; 					}
; 					newpath := parentfolder "" newfoldername "\"
; 					if (FileExist(newpath)) {
; 						; MsgBox("Folder already exists: " newpath)
; 						; rename the folder to something else, make sure it doesn't already exist
; 						i := 1
; 						loop {
; 							newpath := parentfolder "" filename " (" i ")\"
; 							if (!FileExist(newpath)) {
; 								break
; 							}
; 							i++
; 						}
; 						newfoldername := filename " (" i ")"
; 						newpath := parentfolder "" newfoldername "\"
; 					}
; 					DirCreate(newpath)
; 					if (numberofselecteditems > 1) {
; 						ToolTip("Extracting " numberofselecteditems " archives to " parentfolder)
; 					} else {
; 						ToolTip("Extracting " filename " to " newpath)
; 						tab.Navigate(newpath) ; navigate to the extracted folder in the current tab
; 					}
; 					command := A_ComSpec " /C " " 7z x `"" path "`" -aou -o`"" newpath "`""
; 					; MsgBox(command)
; 					RunWait(command, , "Hide")
; 					; ClipWait
; 					; MsgBox(A_Clipboard)
; 					; -aou renames extracting file if it already exists https://7-zip.opensource.jp/chm/cmdline/switches/overwrite.htm
; 					; https://superuser.com/questions/95902/7-zip-and-unzipping-from-command-line
; 					; Run(A_ComSpec " /c `"" "7z x " path " -aou -o" parentfolder "\" filename)
; 				}
; 				SoundPlay(A_WinDir "\Media\ding.wav")
; 				Sleep(1000)
; 				ToolTip()
; 				; success sound
; 			}
; 		default:
; 			{
; 				ToolTip("Not a folder view")
; 				Sleep(1000)
; 				ToolTip()
; 			}
; 	}
; }
CapsLock & ,:: ; open full path for folder, ie C:\Users\user\Documents instead of Documents
{
	tab := GetActiveExplorerTab() ; get the active windows 11 explorer tab
	switch type(tab.Document) {
		case "ShellFolderView":
			{
				tab.Navigate(tab.Document.Folder.Self.Path) ; navigate, in current tab, to the current folder
			}
		default:
			{
				ToolTip("Not a folder view")
				Sleep(1000)
				ToolTip()
			}
	}
}


#HotIf WinActive("ahk_exe anki.exe")
SC053:: ; numpad period
{
	Send("1")
}
SC052:: Send("^z") ; numpad zero

RShift:: Send("{Shift Up}1")
RCtrl:: Send("^z")
#HotIf

#HotIf WinActive('Enigmatica 6 Expert - Minecraft 1.16.5')
~F23:: {
	Sleep(200)
	Send("{Tab}")
	Sleep(15)
	Send("^a")
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