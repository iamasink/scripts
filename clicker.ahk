#Requires AutoHotkey v2.0

while true {
    if (GetKeyState("ScrollLock", "T")) {
        Click()
    } else {
        Sleep(10000)
    }

    Sleep(7000)
}

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