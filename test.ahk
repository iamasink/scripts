;
MsgBox(A_ScriptDir)
F7::
{
    Run("`"C:\Program Files\LittleBigMouse\LittleBigMouse_Daemon.exe`" --start")
}


; reload the script when its saved

#HotIf Winactive("Code.exe")
^s:: {
    Send "^s"
    MsgBox("reloading!")
    Reload()
    Return
}