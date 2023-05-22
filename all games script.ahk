SetTitleMatchMode,2 ;A window's title can contain WinTitle anywhere inside it to be a match.
#Persistent
SetCapsLockState, alwaysoff
SetDefaultMouseSpeed, 0
CoordMode, Mouse, 
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; read secrets
FileRead, homeassistantToken, secrets\homeassistant.txt ; load the token from file



getSpotifyHwnd() {
	WinGet, spotifyHwnd, ID, ahk_exe spotify.exe
	Return spotifyHwnd
}
lighttoggle(r,g,b,w,brightness)
{
	global homeassistantToken
	Run, curl -X POST -H "Authorization: Bearer %homeassistantToken%" -H "Content-Type: application/json" -d "{\"entity_id\":\"light.wiz_rgbw_tunable_b0afb2\"`, \"rgbw_color\":[%r%`,%g%`,%b%`,%w%]`, \"brightness_pct\": %brightness%}" http://homeassistant.local:8123/api/services/light/toggle,,hide
}
lighton(r,g,b,w,brightness)
{
	global homeassistantToken
	Run, curl -X POST -H "Authorization: Bearer %homeassistantToken%" -H "Content-Type: application/json" -d "{\"entity_id\":\"light.wiz_rgbw_tunable_b0afb2\"`, \"rgbw_color\":[%r%`,%g%`,%b%`,%w%]`, \"brightness_pct\": %brightness%}" http://homeassistant.local:8123/api/services/light/turn_on,,hide
}
lightoff()
{
	global homeassistantToken
	lighttemp(6500,100) ; the light should always be reset to this value before turning off, so it turns on as expected when via other means
	Sleep, 50
	Run, curl -X POST -H "Authorization: Bearer %homeassistantToken%" -H "Content-Type: application/json" -d "{\"entity_id\":\"light.wiz_rgbw_tunable_b0afb2\"}" http://homeassistant.local:8123/api/services/light/turn_off,,hide
}
lighttemp(k,brightness)
{
	global homeassistantToken
	Run, curl -X POST -H "Authorization: Bearer %homeassistantToken%" -H "Content-Type: application/json" -d "{\"entity_id\":\"light.wiz_rgbw_tunable_b0afb2\"`, \"color_temp_kelvin\":%k%`, \"brightness_pct\": %brightness%}" http://homeassistant.local:8123/api/services/light/turn_on,,hide
}
^!l:: ;Control-Alt-L 
	time := 0
	While !GetKeyState("Numpad0") && !GetKeyState("Numpad1") && !GetKeyState("Numpad2") && !GetKeyState("Numpad3") && time < 5000
	{
    	Sleep 10
		time := time + 10
	}
	if GetKeyState("Numpad0") {
		lightoff()
	}
	if GetKeyState("Numpad1") {
		lighton(0,255,0,0,100)
	}
	if GetKeyState("Numpad2") {
		lighttemp(6500,100)
	}
	if GetKeyState("Numpad3") {
		lighton(254,0,76,13,100)
	}
return
 
; Always
#IfWinNotActive PLAYERUNKNOWN
	+`::~
	Shift & CapsLock::Send {Delete} 
	CapsLock::Backspace
	!+e::Send {Media_Next}
	!+w::Send {Media_Play_Pause}
	!+q::Send {Media_Prev}
	; on lock
	#L::
		Send {Media_Stop}
		Sleep,50
		Send {Media_Stop}
		Sleep,500
		Send {Media_Stop}
		Sleep,5000
		Send {Media_Stop}
	Return

	#InputLevel 1

	Ctrl & CapsLock::
	Send, ​ ; zwsp character #
	return
	F15::
	Send, ​ ; zwsp character
	return
	RShift::
	Send, ​ ; zwsp character
	return

return


F14::
	PostMessage, 0x319, 0, 0xE0000, , ahk_exe Spotify.exe 	; Send  Media_Play_Pause  to spotify
	Send, {Volume_Up 1} ; show flyout 
Return
F13::
	Send {Media_Stop}
	Sleep,10
	Send {Media_Stop}
	Send {Media_Stop}
	PostMessage, 0x319,, 0xB0000,, ahk_exe Spotify.exe	 ;Send  Media_Next to spotify
Return
+F13::
	PostMessage, 0x319,, 0xC0000,, ahk_exe Spotify.exe	 ;Send  Media_Prev to spotify
	Send, {Volume_Up 1}
Return
F17::
	Send {Media_Stop}
	Sleep,10
	Send {Media_Stop}
	Send {Media_Stop}
	If (!WinActive(Progman)) {
		WinMinimizeAll
	}
	lighttemp(6500,25) ; turn light on at temp 6500k and brightness 25
	Sleep, 5000
	lighttemp(6500,75)
	Input, SingleKey, L1, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}
	WinMinimizeAllUndo

	lightoff()
Return



Alt & CapsLock::Send, ⠀ ; braille black character
Alt & F15::Send, ⠀ ; braille black character

LWin & Space::
	Send #{space}
	SetCapsLockState, off
RETURN

; used for old controller with volume keys on it
; Browser_Home::Send, {vk07sc000} ; guide button
; Volume_Up::Send, {vk07sc001}
; Volume_Down::Send, {vk07sc002}

ScrollLock::Send, 🎷🐈


#IfWinActive ChroMapper
;Insert::
;	Send, {Escape}
;	Send {Click 550 100} ; options
;	Sleep, 200
;	Send {Click 350 550} ; audio
;	Sleep, 100
;	Send {Click 1850 1050} ; red note hit sound
;	Sleep, 5
;	Send, {Escape}
;return
;Home::
;	Send, {Escape}
;	Send {Click 550 100} ; options
;	Sleep, 200
;	Send {Click 350 550} ; audio
;	Sleep, 100
;	Send {Click 1850 1150} ; blue note hit sound
;	Sleep, 5
;	Send, {Escape}
;return
;End:: ;both
;	Send, {Escape}
;	Send {Click 550 100} ; options
;	Sleep, 200
;	Send {Click 350 550} ; audio
;	Sleep, 100
;	Send {Click 1850 1150} ; blue note hit sound
;	Sleep, 10
;	Send {Click 1850 1050} ; red note hit sound
;	Sleep, 5
;	Send, {Escape}
;return
NumpadMult:: ;customData
	Send ,,{Enter}  "_customData":{{}{Enter}    "" : ,{Enter}  {}}
return
WheelLeft::Send, {Up}
WheelRight::Send, {Down}



NumLock::Click, WD, 1
Numpad7::Click, WU, 1

F22::Delete
NumpadDiv::

	MouseGetPos, xposs, yposs
	Sleep, 10
	Click, 2300 66
	Send, ^v
	Send, {Enter} 
	Sleep, 10
	MouseMove, xposs, yposs, 1
return
















#IfWinActive Hammer - 
F21::z

Return


#IfWinActive Mediocre Map Assistant 2
#::
	Paused = 1
	Speed := 1
Return

`::LButton
Space::
	if (Paused = 1) {
	Paused = 0
	}
	else {
	Paused = 1
	}
	Send {Space}
Return
c::
	MouseGetPos , OutputVarX, OutputVarY
	Send, {Escape}
	Sleep, 15
	Send {Click 432 403}
	Sleep, 25
	Send {Click 432 453}
	Sleep, 15
	Send, {Escape}
	MouseMove, OutputVarX, OutputVarY
Return
v::
	MouseGetPos , OutputVarX, OutputVarY
	Send, {Escape}
	Sleep, 20
	Send {Click 432 403}
	Sleep, 25
	Send {Click 432 421}
	Sleep, 15
	Send, {Escape}
	MouseMove, OutputVarX, OutputVarY
Return
p::
	Speed := 1
	ToolTip, Reset to 1,,, 1
	Goto, SetSpeed
	SetTimer, RemoveToolTip, -500
	return
Return

e::
	Speed := Round(Speed - 0.1,2)
	ToolTip, %Speed%,,,2
	SetTimer, RemoveToolTip2, -500
	return
Return

r::
	Speed := Round(Speed + 0.1,2)
	ToolTip, %Speed%,,,2
	SetTimer, RemoveToolTip2, -500
	return
Return

t::
	Goto, SetSpeed
Return

SetSpeed:
	MouseGetPos , OutputVarX, OutputVarY
	Speed2 := Round(Speed, 2)
	ToolTip

	Send, {Escape}
	Sleep, 25
	Send {Click 498 307}
	Sleep, 20
	Send %Speed2%
	Sleep, 15
	Send {Click 700 307}
	Sleep, 5
	Send, {Escape}
	MouseMove, OutputVarX, OutputVarY
Return

XButton1::
	if !(Paused = 1) {
		Send {Space}
	}
	Loop 8 { 
	Click, WD, 1
	Sleep, 1
	}
	if !(Paused = 1) {
		Send {Space}
	}
Return

XButton2::
	if !(Paused = 1) {
		Send {Space}
	}
	Loop 8 { 
	Click, WU, 1
	Sleep, 1
	}
	if !(Paused = 1) {
		Send {Space}
	}
Return

RemoveToolTip:
ToolTip,,,,1
return
RemoveToolTip2:
ToolTip,,,,2
return
Return









#IfWinActive Counter-Strike: Global Offensive
F24::
MouseClick, left
return




#IfWinActive Grand Theft Auto V
F24::Tab
F23::Insert
F22::End 
F21::#
return




#IfWinActive PLAYERUNKNOWN
F24::Home
F23::Insert
F22::End 
F21::#
return





#IfWinActive Rainbow Six
F24::Home
F23::Insert
F22::End 
F21::]
return

#IfWinActive Phasmophobia
!+LButton:: ;On/Off with alt ctrl leftmouse
SendEactive2 := !SendEactive2
If SendEactive2
	SetTimer SendE2, 10 ;spams every x ms
Else
	SetTimer SendE2, Off
Return
SendE2: ;spams 
	Send, {LButton}
Return
!+RButton:: ;On/Off with alt ctrl leftmouse
SendRactive2 := !SendRactive2
If SendRactive2
	SetTimer SendR2, 50 ;spams every x ms
Else
	SetTimer SendR2, Off
Return
SendR2: ;spams 
	Send, {RButton}
Return
F22::Click

!+F::
SendFactive := !SendFactive
If SendFactive
	SetTimer SendF, 50 ;spams every x ms
Else
	SetTimer SendF, Off
Return
SendF: ;spams 
	Sleep, 10
	Send, e
	Sleep, 10
	Send, g
	Sleep, 10
Return





#IfWinActive Minecraft
!+LButton:: ;On/Off with alt ctrl leftmouse
SendEactive := !SendEactive
If SendEactive
	SetTimer SendE, 10 ;spams every 200ms
Else
	SetTimer SendE, Off
Return
SendE: ;spams 
	Send, {LButton}
Return
!+RButton:: ;On/Off with alt ctrl leftmouse
SendRactive := !SendRactive
If SendRactive
	SetTimer SendR, 5 ;spams every 200ms
Else
	SetTimer SendR, Off
Return
SendR: ;spams 
	Send, {RButton}
Return
F22::Click




chatopen := 0

t::
Send, t
chatopen := 1
Return
/::
Send, /
chatopen := 1
Return

Enter::
Send, {Enter}
chatopen := 0
return

Escape::
Send, {Escape}
chatopen := 0
return

7::
If (chatopen == 0) 
	{
		Send, x
	}
If (chatopen == 1) 
	{
		Send, 7
	}
return 

8::
If (chatopen == 0) 
	{
		Send, r
	}
If (chatopen == 1) 
	{
		Send, 8
	}
return

9::
If (chatopen == 0) 
	{
		Send, v
	}
If (chatopen == 1) 
	{
		Send, 9
	}
return



Return


#IfWinActive Badlion
F24::Tab
F23::Insert
F22::End 
F21::#
XButton1::[
XButton2::]
return

#IfWinActive Lunar Client
F24::Tab
F23::Insert
F22::End 
F21::#
XButton1::[
XButton2::]
return

#IfWinActive 1.12.2
F24::Tab
F23::Insert
F22::[ 
F21::]
XButton1::Up
XButton2::Down
return

#IfWinActive osu!

return


;#IfWinActive TETR.IO
;a::
;{
;	Send a
;	keywait,a
;}
;if (getkeystate("Shift", "P")) {
;	Send, a
;}
;return
;d::
;{
;	Send d
;	keywait,d
;}
;if (getkeystate("Shift", "P")) {
;	Send, d
;}
;return
;space::
;{
;	send {space}
;	return
;}
;w::space

#IfWinActive VALORANT
CapsLock::#
return


#IfWinActive paint.net
XButton2::]
XButton1::[
F22::
Send k
Click
Return

; #IfWinActive Roblox
; WheelDown::
; SendInput, {Space Down}
; Sleep, 10
; SendInput, {Space Up}

; Return
; WheelUp::
; SendInput, {Space Down}
; Sleep, 10
; SendInput, {Space Up}

; Return


; reload the script when its saved
#IfWinActive ahk_exe Code.exe
	^s::
	Send ^s
	reload %A_ScriptFullPath%
	msgbox, reloading!
return