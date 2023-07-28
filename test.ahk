;
MsgBox(A_ScriptDir)

; reload the script when its saved
#HotIf WinActive(A_ScriptName "ahk_exe Code.exe")
^s::
{
    Send("^s")
    Reload()
    MsgBox("reloading !")
    Return
}