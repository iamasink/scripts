#Requires AutoHotkey v2.0

; remaps F1-F12 to F13-F24 while ScrollLock is on

MsgBox("Script started! F1-F12 will be remapped to F13-F24 while ScrollLock is on. Press Shift+ScrollLock to kill the script.")

+ScrollLock:: ExitApp()

#HotIf GetKeyState("ScrollLock", "T")
{
    F1::F13
    F2::F14
    F3::F15
    F4::F16
    F5::F17
    F6::F18
    F7::F19
    F8::F20
    F9::F21
    F10::F22
    F11::F23
    F12::F24
}

; reload script with Ctrl+S for testing
#HotIf WinActive(A_ScriptName "ahk_exe Code.exe")
^s::
{
    Send("^s")
    Reload()
    MsgBox("reloading !")
    Return
}