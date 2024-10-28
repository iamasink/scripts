#Requires AutoHotkey v2.0
#SingleInstance Force

#Include "includes\XInput.ahk"
XInput_Init()

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

Joy1::
{
    MsgBox("Hi")
}


Loop {
    controllerstate := XInput_GetState(0)
    buttons := controllerstate.wButtons

    GuidePressed := (buttons & XINPUT_GAMEPAD_GUIDE)
    APressed := (buttons & XINPUT_GAMEPAD_A)

    ; ToolTip(GuidePressed APressed)

    If (GuidePressed > 0 &
        
        & APressed > 0)
    {
        Soundbeep 300, 50
        Send("{Alt Down}{Tab Down}{Tab Up}{Alt Up}")
    }

    sleep 1000
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
