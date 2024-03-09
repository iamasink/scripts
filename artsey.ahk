; a very basic, wip, badly written and probably terribly implemented artsey.io layout for normal keyboards, using autohotkey


delayMs := 250

Persistent()

; MsgBox(A_ScriptDir)
f12:: {
    ExitApp()
}

press := 0


#HotIf GetKeyState("ScrollLock", "T")
q::
w::
e::
r::
a::
s::
d::
f::
{
    ; onKeypress()
    global press
    press := 1
}

q up::
w up::
e up::
r up::
a up::
s up::
d up::
f up::
{
    onKeyrelease()
}
#HotIf

qPressed := 0
wPressed := 0
ePressed := 0
rPressed := 0
aPressed := 0
sPressed := 0
dPressed := 0
fPressed := 0


loop
{
    global press
    if (!press || !GetKeyState("ScrollLock", "T")) {
        ; ToolTip("no press")
        Sleep(25)

    } else {
        ; ToolTip("press!")

        global qPressed
        global wPressed
        global ePressed
        global rPressed
        global aPressed
        global sPressed
        global dPressed
        global fPressed
        global delayMs
        if (GetKeyState("q", "P")) {
            qPressed := 1
            resetq() {
                global qPressed
                qPressed := 0
            }
            SetTimer(resetq, -250)
        }
        if (GetKeyState("w", "P")) {
            wPressed := 1
            resetw() {
                global wPressed
                wPressed := 0
            }
            SetTimer(resetw, -delayMs)
        }
        if (GetKeyState("e", "P")) {
            ePressed := 1
            resete() {
                global ePressed
                ePressed := 0
            }
            SetTimer(resete, -delayMs)
        }
        if (GetKeyState("r", "P")) {
            rPressed := 1
            resetr() {
                global rPressed
                rPressed := 0
            }
            SetTimer(resetr, -delayMs)
        }
        if (GetKeyState("a", "P")) {
            aPressed := 1
            reseta() {
                global aPressed
                aPressed := 0
            }
            SetTimer(reseta, -delayMs)
        }
        if (GetKeyState("s", "P")) {
            sPressed := 1
            resets() {
                global sPressed
                sPressed := 0
            }
            SetTimer(resets, -delayMs)
        }
        if (GetKeyState("d", "P")) {
            dPressed := 1
            resetd() {
                global dPressed
                dPressed := 0
            }
            SetTimer(resetd, -delayMs)
        }
        if (GetKeyState("f", "P")) {
            fPressed := 1
            resetf() {
                global fPressed
                fPressed := 0
            }
            SetTimer(resetf, -delayMs)
        }

        ; ToolTip(
        ;     "Held keys:"
        ;     "`nq: " qPressed
        ;     "`nw: " wPressed
        ;     "`ne: " ePressed
        ;     "`nr: " rPressed
        ;     "`na: " aPressed
        ;     "`ns: " sPressed
        ;     "`nd: " dPressed
        ;     "`nf: " fPressed
        ; )
    }
    Sleep(10)
}

onKeyrelease() {
    ; if no keys pressed
    keys := ""
    if (GetKeyState("q", "P")) {
        keys := keys "q"
    }
    if (GetKeyState("w", "P")) {
        keys := keys "w"
    }
    if (GetKeyState("e", "P")) {
        keys := keys "e"
    }
    if (GetKeyState("r", "P")) {
        keys := keys "r"
    }
    if (GetKeyState("a", "P")) {
        keys := keys "a"
    }
    if (GetKeyState("s", "P")) {
        keys := keys "s"
    }
    if (GetKeyState("d", "P")) {
        keys := keys "d"
    }
    if (GetKeyState("f", "P")) {
        keys := keys "f"
    }
    ; ToolTip("`"" keys "`"")
    if (keys = "") {
        global press
        press := 0
        ; ToolTip("keys empty")
        global qPressed
        global wPressed
        global ePressed
        global rPressed
        global aPressed
        global sPressed
        global dPressed
        global fPressed
        keys2 := ""

        if (qPressed) {
            keys2 := keys2 "1"
        } else {
            keys2 := keys2 "0"
        }
        if (wPressed) {
            keys2 := keys2 "1"
        } else {
            keys2 := keys2 "0"
        }
        if (ePressed) {
            keys2 := keys2 "1"
        } else {
            keys2 := keys2 "0"
        }
        if (rPressed) {
            keys2 := keys2 "1"
        } else {
            keys2 := keys2 "0"
        }
        if (aPressed) {
            keys2 := keys2 "1"
        } else {
            keys2 := keys2 "0"
        }
        if (sPressed) {
            keys2 := keys2 "1"
        } else {
            keys2 := keys2 "0"
        }
        if (dPressed) {
            keys2 := keys2 "1"
        } else {
            keys2 := keys2 "0"
        }
        if (fPressed) {
            keys2 := keys2 "1"
        } else {
            keys2 := keys2 "0"
        }
        ; ToolTip(keys2)
        qPressed := 0
        wPressed := 0
        ePressed := 0
        rPressed := 0
        aPressed := 0
        sPressed := 0
        dPressed := 0
        fPressed := 0

        switch keys2 {
            case "10000000":
                send("s")
            case "01000000":
                send("t")
            case "00100000":
                send("r")
            case "00010000":
                send("a")
            case "00001000":
                send("o")
            case "00000100":
                send("i")
            case "00000010":
                send("y")
            case "00000001":
                send("e")

            case "01110000":
                send ("d")
            case "11110000":
                send ("z")
            case "00010110":
                send ("'")
            case "00001001":
                send ("b")
            case "00011000":
                send ("/")
            case "10010000":
                send ("w")
            case "00010100":
                send (",")
            case "11000000":
                send ("j")
            case "00110000":
                send ("f")
            case "00000111":
                send ("l")
            case "11100000":
                send ("x")
            case "00000110":
                send ("u")
            case "00011110":
                send ("{Caps Lock}")
            case "00001101":
                send ("p")
            case "10100000":
                send ("v")
            case "00010010":
                send (".")
            case "01000100":
                send ("!")
            case "00000101":
                send ("h")
            case "01100000":
                send ("g")
            case "00001010":
                send ("k")
            case "00001100":
                send ("n")
            case "00001110":
                send ("m")
            case "00000011":
                send ("c")
            case "11010000":
                send ("q")

            case "00100010":
                send ("'")
            case "00010010":
                send (",")
            case "01000100":
                send ("!")
            case "00010100":
                send (".")
            case "10001000":
                send ("?")
            case "00011000":
                send ("/")


            case "00010001":
                send ("{Enter}")
            case "00001111":
                send ("{Space}")
            case "00111000":
                send ("{Escape}")
            case "00100001":
                send ("{Backspace}")
            case "01111000":
                send ("{Tab}")
            case "00100100":
                send ("{Delete}")


            default:
                ; ToolTip("Key not recognized")
        }

    }
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
