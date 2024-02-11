; restart ahk script on save
; put this in a script to reload it when you press ctrl+s, so its easier to test
; nothing has to be changed per script, but you have to manually reload if you change the filename or stuff like that
; ahk_exe can be changed to any other exe name
; the msgbox flashes briefly when it reloads, so you know it worked
; reload the script when its saved
#HotIf WinActive(A_ScriptName " ahk_exe Code.exe")
^s::
{
    Send("^s")
    Reload()
    MsgBox("reloading !")
    Return
}