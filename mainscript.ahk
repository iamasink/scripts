; main script.
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

; read secrets
homeassistantToken := Fileread("secrets\homeassistant.txt") ; load the token from file

getSpotifyHwnd() {
	spotifyHwnd := WinGetID("ahk_exe spotify.exe")
	Return spotifyHwnd
}
homeassistantRequest(requestJSON, url)
{
	global homeassistantToken
	Run(A_ComSpec " /C " "curl -X POST -H `"Authorization: Bearer " homeassistantToken "`" -H `"Content-Type: application/json`" -d `"" requestJSON "`" http://homeassistant.local:8123/api/" url " & pause", , "hide")

}

lighttoggle(r, g, b, w, brightness)
{
	global homeassistantToken
	; Run, curl -X POST -H "Authorization: Bearer %homeassistantToken%" -H "Content-Type: application/json" -d "{\"entity_id\":\"light.wiz_rgbw_tunable_b0afb2\"`, \"rgbw_color\":[%r%`,%g%`,%b%`,%w%]`, \"brightness_pct\": %brightness%}" http://homeassistant.local:8123/api/services/light/toggle,,hide
	; Run(A_ComSpec " /C " "curl -X POST -H `"Authorization: Bearer " homeassistantToken "`" -H `"Content-Type: application/json`" -d `"{\`"entity_id\`":\`"light.wiz_rgbw_tunable_b0afb2\`", \`"rgbw_color\`":[" r "," g "," b "," w "], \`"brightness_pct\`": " brightness "}`" http://homeassistant.local:8123/api/services/light/toggle & pause")
	homeassistantRequest("{\`"entity_id\`":\`"light.wiz_rgbw_tunable_b0afb2\`", \`"rgbw_color\`":[" r "," g "," b "," w "], \`"brightness_pct\`": " brightness "}", "services/light/toggle")
}
lighttoggletemp(k, brightness)
{
	global homeassistantToken
	; Run, curl -X POST -H "Authorization: Bearer %homeassistantToken%" -H "Content-Type: application/json" -d "{\"entity_id\":\"light.wiz_rgbw_tunable_b0afb2\"`, \"color_temp_kelvin\":%k%`, \"brightness_pct\": %brightness%}" http://homeassistant.local:8123/api/services/light/toggle,,hide
	homeassistantRequest("{\`"entity_id\`":\`"light.wiz_rgbw_tunable_b0afb2\`", \`"color_temp_kelvin\`":" k ", \`"brightness_pct\`": " brightness "}", "services/light/toggle")

}
lighton(r, g, b, w, brightness)
{
	global homeassistantToken
	; Run, curl -X POST -H "Authorization: Bearer %homeassistantToken%" -H "Content-Type: application/json" -d "{\"entity_id\":\"light.wiz_rgbw_tunable_b0afb2\"`, \"rgbw_color\":[%r%`,%g%`,%b%`,%w%]`, \"brightness_pct\": %brightness%}" http://homeassistant.local:8123/api/services/light/turn_on,,hide
	homeassistantRequest("{\`"entity_id\`":\`"light.wiz_rgbw_tunable_b0afb2\`", \`"rgbw_color\`":[" r "," g "," b "," w "], \`"brightness_pct\`": " brightness "}", "services/light/turn_on")


}
lightoff()
{
	global homeassistantToken
	lighttemp(6500, 100) ; the light should always be reset to this value before turning off, so it turns on as expected when via other means
	Sleep(50) ; sleep so it actually does it first because yes
	; Run, curl -X POST -H "Authorization: Bearer %homeassistantToken%" -H "Content-Type: application/json" -d "{\"entity_id\":\"light.wiz_rgbw_tunable_b0afb2\"}" http://homeassistant.local:8123/api/services/light/turn_off,,hide
	homeassistantRequest("{\`"entity_id\`":\`"light.wiz_rgbw_tunable_b0afb2\`"}", "services/light/turn_off")
}
lighttemp(k, brightness)
{
	global homeassistantToken
	; Run, curl -X POST -H "Authorization: Bearer %homeassistantToken%" -H "Content-Type: application/json" -d "{\"entity_id\":\"light.wiz_rgbw_tunable_b0afb2\"`, \"color_temp_kelvin\":%k%`, \"brightness_pct\": %brightness%}" http://homeassistant.local:8123/api/services/light/turn_on,,hide
	homeassistantRequest("{\`"entity_id\`":\`"light.wiz_rgbw_tunable_b0afb2\`", \`"color_temp_kelvin\`":" k ", \`"brightness_pct\`": " brightness "}", "services/light/turn_on")
}
^!l:: ;Control-Alt-L
{
	time := 0
	; while not anythings pressed, just wait
	While !GetKeyState("Numpad0") && !GetKeyState("Numpad1") && !GetKeyState("Numpad2") && !GetKeyState("Numpad3") && time < 5000
	{
		Sleep 10
		time := time + 10
	}
	; if a key is pressed do something
	if GetKeyState("Numpad0") {
		lightoff()
	}
	if GetKeyState("Numpad1") {
		lighton(0, 255, 0, 0, 100)
	}
	if GetKeyState("Numpad2") {
		lighttemp(6500, 100)
	}
	if GetKeyState("Numpad3") {
		lighton(254, 0, 76, 13, 100)
	}
}

; Always

; Pause::
; Send, {Pause}
; SoundBeep, 600, 150
; SoundBeep, 300, 100
; SoundBeep, 200, 100
; Return

; todo make a group of all games that stuff might mess up with

+`::~
Shift & CapsLock:: Send("{Delete}")
; Ctrl & CapsLock::
CapsLock & e:: PostMessage(0x319, , 0xB0000, , "ahk_exe Spotify.exe")	 ;Send  Media_Next to spotify
CapsLock & w:: PostMessage(0x319, 0, 0xE0000, , "ahk_exe Spotify.exe")	; Send Media_Play_Pause to spotify
CapsLock & q:: PostMessage(0x319, , 0xC0000, , "ahk_exe Spotify.exe")	 ;Send  Media_Prev to spotify
CapsLock:: Send("{Backspace}")
; CapsLock & Shift::Send {Delete}
!+e:: Send("{Media_Next}")
!+w:: Send("{Media_Play_Pause}")
!+q:: Send("{Media_Prev}")


; on lock
#L::
{
	Send("{Media_Stop}")
	Sleep(50)
	Send("{Media_Stop}")
	Sleep(500)
	Send("{Media_Stop}")
	Sleep(5000)
	Send("{Media_Stop}")
	Return
}


#InputLevel 1

; Ctrl & CapsLock::
; Send, ​ ; zwsp character #
; return
; F15::
; Send, ​ ; zwsp character
; return
; RShift::
; Send, ​ ; zwsp character
; return

F13:: ; A1
{
	lighttoggletemp(6500, 100)
	Return
}

; Alt & CapsLock::Send, ⠀ ; braille black character
; Alt & F15::Send, ⠀ ; braille black character

; ; force turn off capslock when win+space because sometimes its weird?
; LWin & Space::
; 	Send #{space}
; 	SetCapsLockState, off
; RETURN

; used for old controller with volume keys on it
; Browser_Home::Send, {vk07sc000} ; guide button
; Volume_Up::Send, {vk07sc001}
; Volume_Down::Send, {vk07sc002}

; download from url
^#Down::
{
	Run(A_ComSpec " /c `"C:\Users\Lily\Desktop\tools\ytdlp\Download Video.bat`"", "C:\Users\Lily\Desktop\tools\ytdlp\")
	Sleep(500)
	Send("^v")
	Sleep(100)
	Send("{Enter}")
	Sleep(50)
	Send("#{Down}")
	Return
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