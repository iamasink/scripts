;
; MsgBox(A_ScriptDir)
f12:: {
    ExitApp()
}

q::
w::
e::
r::
a::
s::
d::
f::
{
    onKeypress()
}

onKeypress()
{
    qPressed := GetKeyState("q", "P")
    wPressed := GetKeyState("w", "P")
    ePressed := GetKeyState("e", "P")
    rPressed := GetKeyState("r", "P")
    aPressed := GetKeyState("a", "P")
    sPressed := GetKeyState("s", "P")
    dPressed := GetKeyState("d", "P")
    fPressed := GetKeyState("f", "P")
    ToolTip(
        "Held keys:"
        "`nq: " qPressed
        "`nw: " wPressed
        "`ne: " ePressed
        "`nr: " rPressed
        "`na: " aPressed
        "`ns: " sPressed
        "`nd: " dPressed
        "`nf: " fPressed
    )
}

; reload the script when its saved
#HotIf WinActive(A_ScriptName " ahk_exe Code.exe")
^s::
{
    Send("^s")
    Reload()
    MsgBox("reloading !")
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
