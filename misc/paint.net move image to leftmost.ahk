; this script moves a 256x256 image in paint.net to the leftmost of the canvas,
; to use it, mouseover an empty space and press f7

#Requires AutoHotkey v2.0
; input speed
SetKeyDelay(0)

f7::
{
    ; MouseClick("Left", A_ScreenWidth / 2, A_ScreenHeight / 2)
    ; click
    Send("{Click}")

    ; ctrl + i (invert selection)
    Send("{Ctrl down}i{Ctrl up}")

    ; ctrl + shift + x (crop to selection)
    Send("{Ctrl down}{Shift down}x{Shift up}{Ctrl up}")

    ; ctrl + shift + r (canvas size)
    Send("{Ctrl down}{Shift down}r{Shift up}{Ctrl up}")

    ; 256, tab, 256 (set canvas size to 256x256)
    Send("256{Tab}256")

    ; enter
    Send("{Enter}")

    ; ctrl + tab (go to next tab)
    Send("{Ctrl down}{Tab}{Ctrl up}")

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