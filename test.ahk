;
; MsgBox(A_ScriptDir)

f7::
{
    WinClose()
}


; reload the script when its saved
#HotIf WinActive(A_ScriptName "ahk_exe Code.exe")
^s::
{
    Send("^s")
    Reload()
    MsgBox("reloading !")
    Return
}