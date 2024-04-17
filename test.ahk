#Requires AutoHotkey v2.0
#SingleInstance Force

CoordMode("Mouse")
SetDefaultMouseSpeed(0)
TraySetIcon(A_ScriptDir "\icon\ahkblue16.ico")

if (!A_IsAdmin)
{
    try {
        Run("*RunAs `"" A_ScriptFullPath "`"")
    }
    catch {
        MsgBox("Couldn't run " A_ScriptName " as admin! Some things may not work")
    }
}


; F23:: ; DPI Down / G7
; {
;     try {
;         MouseGetPos(&x1, &y1)


;         moveval := 0
;         pixeldist := 5
;         pixeldisty := 15
;         largepixeldist := 500
;         ; stops waiting and skip = 1 if timeout expires, else waits for timeout and if its still held down skip is 0
;         skip := KeyWait("F23", "T0.3")
;         if (!skip) {
;             ToolTip("", x1, y1, 2)
;             ToolTip("←", x1 - largepixeldist, y1, 3)
;             ToolTip("→", x1 + largepixeldist, y1, 4)
;         }

;         loop {
;             If (GetKeyState("F23", "p") or skip) {
;                 MouseGetPos(&x2, &y2)
;                 XDif := (x2 - x1)
;                 YDif := (y2 - y1)
;                 If (abs(XDif) >= abs(YDif)) {
;                     If (abs(XDif) >= largepixeldist) {
;                         If (XDif >= largepixeldist)
;                         {
;                             if (moveval != 1)
;                                 ToolTip("big right", x1, y1, 2)
;                             moveval := 1
;                         }

;                         If (XDif <= -largepixeldist)
;                         {
;                             if (moveval != 2)
;                                 ToolTip("big left", x1, y1, 2)
;                             moveval := 2
;                         }

;                     }
;                     else {
;                         If (XDif >= pixeldist)
;                         {
;                             if (moveval != 5)
;                                 ToolTip("right", x1, y1, 2)
;                             moveval := 5
;                         }

;                         If (XDif <= -pixeldist)
;                         {
;                             if (moveval != 6)
;                                 ToolTip("left", x1, y1, 2)
;                             moveval := 6
;                         }

;                     }
;                 }
;                 else {
;                     If (abs(YDif) >= largepixeldist) {
;                         If (YDif >= largepixeldist)
;                         {
;                             if (moveval != 3)
;                                 ToolTip("", x1, y1, 2)
;                             moveval := 3
;                         }

;                         If (YDif <= -largepixeldist) {
;                             if (moveval != 4)
;                                 ToolTip("", x1, y1, 2)
;                             moveval := 4

;                         }

;                     }
;                     else {
;                         If (YDif >= pixeldisty)
;                         {
;                             if (moveval != 7)
;                                 ToolTip("", x1, y1, 2)

;                             moveval := 7
;                         }

;                         If (YDif <= -pixeldisty)
;                         {
;                             if (moveval != 8)
;                                 ToolTip("", x1, y1, 2)
;                             moveval := 8
;                         }

;                     }
;                 }
;                 if (skip) {
;                     break
;                 }
;             } else {
;                 break
;             }
;             Sleep 25
;         }

;         ; clear tooltips
;         ToolTip()
;         ToolTip(, , , 2)
;         ToolTip(, , , 3)
;         ToolTip(, , , 4)


;         if (moveval = 0) ; no movement
;             Send("^{LButton}")
;         ; close tabs shortcuts https://addons.mozilla.org/en-GB/firefox/addon/close-tabs-shortcuts/
;         if (moveval = 1) ; Big Right
;             Send("!+{F2}") ; close tabs to the right
;         if (moveval = 2) ; Big Left
;             Send("!+{F1}") ; close tabs to the left
;         ;
;         if (moveval = 3) ; Big Down
;             Send("^w")
;         if (moveval = 4) ; Big Up
;             Send("+^t")
;         if (moveval = 5) ; Right
;             Send("^{tab}")
;         if (moveval = 6) ; Left
;             Send("^+{tab}")
;         if (moveval = 7) ; Down
;             Send("^w")
;         if (moveval = 8) ; Up
;             Send("^l") ; select address bar

;     }
; }


; MsgBox(A_ScriptDir)
#:: {
    MsgBox("Killing Explorer.exe")
    Sleep(1000)
    RunWait("taskkill.exe /F /IM Explorer.exe", , "Hide")
    Sleep(3000)
    Run("Explorer.exe")
}
f12:: {
    MsgBox("Exiting " A_ScriptName)

    ExitApp()
}


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


; E 11.1607
; A 8.4966
; R 7.5809
; I 7.5448
; O 7.1635
; T 6.9509
; N 6.6544
; S 5.7351
; L 5.4893
; C 4.5388
; U 3.6308
; D 3.3844
; P 3.1671
; M 3.0129
; H 3.0034
; G 2.4705
; B 2.0720
; F 1.8121
; Y 1.7779
; W 1.2899
; K 1.1016
; V 1.0074
; X 0.2902
; Z 0.2722
; J 0.1965
; Q 0.1962
