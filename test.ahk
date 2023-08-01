;
; MsgBox(A_ScriptDir)

f7::
{
    Run("`"C:\Program Files\Rainmeter\Rainmeter.exe`" [!SetWindowPosition `"75%@2`" `"20%@2`" `"63%`" `"58%`" `"Elegant Clock`"][!Update]")
}
f8::
{
    Run("`"C:\Program Files\Rainmeter\Rainmeter.exe`" [!SetWindowPosition `"50%@2`" `"20%@2`" `"63%`" `"58%`" `"Elegant Clock`"][!Update]")
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