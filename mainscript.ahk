; main script.
#Requires AutoHotkey v2.0
SetTitleMatchMode(2) ;A window's title can contain WinTitle anywhere inside it to be a match.
Persistent(true)
SetCapsLockState("alwaysoff")
SetDefaultMouseSpeed(0)
CoordMode("Mouse")
SetWorkingDir(A_ScriptDir) ; Ensures a consistent starting directory.


; ----- Current F13-24 Binds -----
; Mouse (G502 - set in G Hub):
; 	Side button // DPI shift- F21
; 	DPI Up / Top left / G8 - F22
; 	DPI Down / Top left but down a bit / G7- F23
; 	Top middle / G9 - F24
; Keyboard: Wooting 2 HE
;  A1	- F13
;  A2	- F14
;  A3	- F15
;  Mode - F16
; The original functions for these keys (switching keyboard profile) are available in the FN layer.

; read secrets, this runs on script start
homeassistantToken := Fileread("secrets\homeassistant.txt") ; load the token from file

; set display on start
if (MonitorGetCount() = 1) { ; only if only 1 monitor is on
	Run("C:\Windows\System32\DisplaySwitch.exe /extend")
	Sleep(2000)
	; tell littlebigmouse to open and start
	Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --start")
}


; functions


/**
 * Send a POST request thing to homeassistant
 * @param requestJSON a string containing json for the request body
 * @param url the url suffix, past /api/
 */
homeassistantRequest(requestJSON, url)
{
	; get token from variable earlier
	global homeassistantToken
	Run(A_ComSpec " /C " "curl -X POST -H `"Authorization: Bearer " homeassistantToken "`" -H `"Content-Type: application/json`" -d `"" requestJSON "`" http://homeassistant.local:8123/api/" url, , "hide")
}

lighttoggle(r, g, b, w, brightness)
{
	; remember that `" is the escape for " within autohotkey, a \ escapes that " for the CMD that runs
	; so CMD sees (eg) {\"entity_id\":\"light.wiz_rgbw_tunable_b0afb2\"}
	; which then curls {"entity_id":"light.wiz_rgbw_tunable_b0afb2"}
	; autohotkey inherently concatenates strings, so within the rgbw_color array, the main "" ends so it can concatenate the variable.
	; yes its complicated and i'll probably have to relearn everything next time i want to touch this 😭😭
	; it's possible some of the " are avoidable, but i really do not want to do this any longer

	; this toggle function includes a rgbw and brightness, because it still sets the light to these if turning on
	homeassistantRequest("{\`"entity_id\`":\`"light.wiz_rgbw_tunable_b0afb2\`", \`"rgbw_color\`":[" r "," g "," b "," w "], \`"brightness_pct\`": " brightness "}", "services/light/toggle")
}

lighttoggletemp(k, brightness)
{
	homeassistantRequest("{\`"entity_id\`":\`"light.wiz_rgbw_tunable_b0afb2\`", \`"color_temp_kelvin\`":" k ", \`"brightness_pct\`": " brightness "}", "services/light/toggle")
}

lighton(r, g, b, w, brightness)
{
	homeassistantRequest("{\`"entity_id\`":\`"light.wiz_rgbw_tunable_b0afb2\`", \`"rgbw_color\`":[" r "," g "," b "," w "], \`"brightness_pct\`": " brightness "}", "services/light/turn_on")
}

lightoff()
{
	lighttemp(6500, 100) ; the light should always be reset to this value before turning off, so it turns on as expected when via other means
	Sleep(50) ; sleep so it actually does it first because yes
	homeassistantRequest("{\`"entity_id\`":\`"light.wiz_rgbw_tunable_b0afb2\`"}", "services/light/turn_off")
}

lighttemp(k, brightness)
{
	homeassistantRequest("{\`"entity_id\`":\`"light.wiz_rgbw_tunable_b0afb2\`", \`"color_temp_kelvin\`":" k ", \`"brightness_pct\`": " brightness "}", "services/light/turn_on")
}


^!l:: ;Control-Alt-L
{
	; Timeout duration (in milliseconds)
	timeoutDuration := 2500

	; Start the input with a timeout
	SetTimer(CheckTimeout, timeoutDuration)
	ToolTip("Light switch mode")

	; Wait for a key and run a function based on the key
	; this doesn't work for numpad keys because its literally taking the text so like whatever
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
Shift & CapsLock:: Send("{Delete}")
Ctrl & CapsLock:: Send("^{BackSpace}")
CapsLock & e:: {
	if (!WinExist("ahk_exe Spotify.exe")) { ; if spotify isn't open, open it!
		Run("C:\Users\Lily\AppData\Roaming\Spotify\Spotify.exe")
		WinWait("ahk_exe Spotify.exe")
		Sleep(1000)
	}
	PostMessage(0x319, , 0xB0000, , "ahk_exe Spotify.exe")	 ;Send  Media_Next to spotify
}
CapsLock & w:: {
	if (!WinExist("ahk_exe Spotify.exe")) { ; if spotify isn't open, open it!
		Run("C:\Users\Lily\AppData\Roaming\Spotify\Spotify.exe")
		WinWait("ahk_exe Spotify.exe")
		Sleep(1000)
	}
	PostMessage(0x319, , 0xE0000, , "ahk_exe Spotify.exe")	; Send Media_Play_Pause to spotify
}
CapsLock & q:: {
	if (!WinExist("ahk_exe Spotify.exe")) { ; if spotify isn't open, open it!
		Run("C:\Users\Lily\AppData\Roaming\Spotify\Spotify.exe")
		WinWait("ahk_exe Spotify.exe")
		Sleep(1000)
	}
	PostMessage(0x319, , 0xC0000, , "ahk_exe Spotify.exe")	 ;Send  Media_Prev to spotify
}
CapsLock:: Send("{Backspace}") ; when backspace released,, maybe theres a better way to do it but idk.
!+e:: Send("{Media_Next}")
!+w:: Send("{Media_Play_Pause}")
!+q:: Send("{Media_Prev}")

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
		ToolTip("Switching to only main display")
		Sleep(250)
		Run("C:\Windows\System32\DisplaySwitch.exe /internal")
		Sleep(1000)
		; tell littlebigmouse to exit
		Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --exit")
		Sleep(3000) ; this delay prevents spamming the button
		ToolTip("")
	} else {
		ToolTip("Switching to all displays")
		Sleep(250)
		Run("C:\Windows\System32\DisplaySwitch.exe /extend")
		Sleep(500)
		; tell littlebigmouse to open and start
		Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --start")
		Sleep(3000) ; this delay prevents spamming the button
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
	Run("C:\Users\Lily\Desktop\tools\scrcpy\scrcpy.bat", "C:\Users\Lily\Desktop\tools\scrcpy\")
}

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

; reload the script when its saved
#HotIf WinActive("ahk_exe Code.exe",)
^s::
{
	Send("^s")
	Reload()
	MsgBox("reloading !")
	Return
}