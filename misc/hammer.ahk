#Requires AutoHotkey v2.0
SetDefaultMouseSpeed(0)
CoordMode("Mouse")

F21:: {
    MouseGetPos(&x, &y)
    MouseClick("Left", 2280, 1011)
    Sleep(25)
    MouseClick("Left", 2280, 1011)
    Sleep(25)
    Send("^c")
    Sleep(25)
    num := Number(A_Clipboard) - 90
    Send(num)
    MouseMove(x, y)
    Send("{Enter}")
}


; reload the script when its saved
#HotIf WinActive(A_ScriptName " ahk_exe Code.exe")
~^s::
{
    ToolTip("Reloading " A_ScriptName ".", A_ScreenWidth / 2, A_ScreenHeight / 2)
    Sleep(250)
    Reload()
    Return
}