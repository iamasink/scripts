SetTitleMatchMode,2
#Persistent
SetCapsLockState, alwaysoff
SetDefaultMouseSpeed, 0
CoordMode, Mouse, Screen

; Always
+`::~
Shift & CapsLock::Send {Delete} 
CapsLock::Backspace

; on lock
#L::
Send {Media_Stop}
Sleep,500
Send {Media_Stop}

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

F14::Send {Media_Play_Pause}
F13::Send {Media_Next}
+F13::Send {Media_Prev}







Alt & CapsLock::Send, ⠀ ; braille black character
Alt & F15::Send, ⠀ ; braille black character

LWin & Space::
	Send #{space}
	SetCapsLockState, off
RETURN

Browser_Home::Send, {vk07sc000}
Volume_Up::Send, {vk07sc001}
Volume_Down::Send, {vk07sc002}

ScrollLock::Send, 🎷🐈


#InputLevel 0
SendLevel 0


#Hotstring EndChars #-()[]{}:;'"/\,.?!`n `t

; zwsp
:*:whe​::where{Space}
:*:w​::what{Space}
:*:th​::there{Space}
:*:t​::the{Space}
:*:ti​::this{Space}
:*:h​::how{Space}
:*:a​::about{Space}
:*:ba​::back{Space}
:*:how​::how are you doing{Space}
:*:he​::hello{Space}
:*:ty​::thanks{Space}
:*:tyy​::thank you{Space}
:*:tyyy​::thank youuu{Space}
:*:u​::you{Space}
:*:wh​::which{Space}
:*:cud​::could{Space}
:*:wud​::would
:*:shud​::should{Space}
:*:c​::see{Space}
:*:v​::very{Space}
:*:n​::and{Space}
:*:lil​::little{Space}
:*:ppl​::people{Space}
:*:pls​::please{Space}
:*:plz​::please{Space}
:*:b​::but{Space}
:*:cuz​::because{Space}
:*:bcuz​::because{Space}
:*:thru​::through{Space}
:*:o​::oh{Space}
:*:s1​::someone{Space}
:*:1​::one{Space}
:*:2​::two{Space}
:*:3​::three{Space}
:*:4​::four{Space}
:*:5​::five{Space}
:*:6​::six{Space}
:*:7​::seven{Space}
:*:8​::eight{Space}
:*:9​::nine{Space}
:*:0​::zero{Space}
:*:wtf​::what the fuck{Space}
:*:wth​::what the hell{Space}
:*:wut​::what{Space}
:*:no​::know{Space}
:*:b4​::before{Space}
:*:cs​::🎷🐈{Space}
:*:idk​::i dont know{Space}
:*:Idk​::I don't know{Space}

:*:q⠀::i
:*:--⠀::--userphone

; if character sent alone, return
:*:​:: 
Send, ^{Backspace}
return ;zwsp
:*:⠀::
return ;braille






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








#IfWinActive Minecraft
!+LButton:: ;On/Off with alt ctrl leftmouse
SendEactive := !SendEactive
If SendEactive
	SetTimer SendE, 10 ;spams every 200ms
Else
	SetTimer SendE, Off
Return
SendE: ;spams key e
	Send, {LButton}
Return
!+RButton:: ;On/Off with alt ctrl leftmouse
SendRactive := !SendRactive
If SendRactive
	SetTimer SendR, 5 ;spams every 200ms
Else
	SetTimer SendR, Off
Return
SendR: ;spams key e
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

#IfWinActive osu!  - 
XButton1::Esc
F1::x
F2::c
w::x
e::c
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



; reload the script when its saved
#ifwinactive, all games script.ahk - 
^s::
Send ^s
reload "D:\scripts\all games script.ahk"
return

#If WinActive("Visual Studio Code") || WinActive("Firefox") || WinActive("Opera")
F16::
	if (WASDArrow = 1) {
	WASDArrow = 0
	tooltip, WASDArrow off
		SoundBeep, 523, 50
	tooltip
	}
	else {
	WASDArrow = 1
	tooltip, WASDArrow on
	SoundBeep, 200, 200
	tooltip
	}
Return
*w:: ; 
	if (WASDArrow = 1) {
		Send {Blind}{Up}
		} else {
			Send {Blind}w
		}
return

*a::
	if (WASDArrow = 1) {
		Send {Blind}{Left}
		} else {
			Send {Blind}a
		}
return

*s::
	if (WASDArrow = 1) {
		Send {Blind}{Down}
		} else {
			Send {Blind}s
		}
return
*d::
	if (WASDArrow = 1) {
		Send {Blind}{Right}
		} else {
			Send {Blind}d
		}
return
return