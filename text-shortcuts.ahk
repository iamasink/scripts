#Requires AutoHotkey v2.0
#SingleInstance Force

addyioToken := FileRead("secrets\addyio.txt")
email1 := FileRead("secrets\email-1.txt") ; load the token from file

; ^f1:: {
;     MsgBox(JEE_RunGetStdOut(A_ComSpec " /C curl -X GET -H `"Authorization: Bearer " addyioToken "`" -H `"Content-Type: application/json`" `"https://app.addy.io/api/v1/api-token-details`""))
; }

; curl --request GET\
; --get "https://app.addy.io/api/v1/api-token-details"\
; --header "Authorization: Bearer {token}"\
; --header "Content-Type: application/json"\
; --header "X-Requested-With: XMLHttpRequest"

#Hotstring EndChars -()[]{}:;'"/\,.?!`n`t ; no space


#InputLevel 2
:*?:[switchmonitor]:: {
    Sleep(10)
    Send("{Ctrl Down}{Shift Down}{F14}{Ctrl Up}{Shift Up}")
}

#InputLevel 0 ; default, must be lower than the one below


:*?:[addy]:: {
    Send(email1)
}
; :*?:?@   :: {
;     Send(email1)
; }
:*?:[fixcaps]:: {
    SetCapsLockState("Off")
    Sleep(10)
    SetCapsLockState("AlwaysOff")
}


; Subscripts
:?*:[sub1]::{U+2081} ; 1
:?*:[sub2]::{U+2082} ; 2
:?*:[sub3]::{U+2083} ; 3
:?*:[sub4]::{U+2084} ; 4
:?*:[sub5]::{U+2085} ; 5
:?*:[sub6]::{U+2086} ; 6
:?*:[sub7]::{U+2087} ; 7
:?*:[sub8]::{U+2088} ; 8
:?*:[sub9]::{U+2089} ; 9
:?*:[sub0]::{U+2080} ; 0
:?*:[sub+]::{U+208A} ; +
:?*:[sub-]::{U+208B} ; -
:?*:[sub=]::{U+208C} ; =
:?*:[sub(]::{U+208D} ; (
:?*:[sub)]::{U+208E} ; )
:?*:[suba]::{U+2090} ; a
:?*:[sube]::{U+2091} ; e
:?*:[subo]::{U+2092} ; o
:?*:[subx]::{U+2093} ; x
:?*:[suba]::{U+2090} ; a
:?*:[subh]::{U+2095} ; h
:?*:[subk]::{U+2096} ; k
:?*:[subl]::{U+2097} ; l
:?*:[subm]::{U+2098} ; m
:?*:[subn]::{U+2099} ; n
:?*:[subp]::{U+209A} ; p
:?*:[subs]::{U+209B} ; s
:?*:[subt]::{U+209C} ; t
:?*:[sub?]::{U+2094} ; schwa

; Superscripts
:?*:[sup1]::{U+00B9} ; 1
:?*:^1   ::{U+00B9}

:?*:[sup2]::{U+00B2} ; 2
:?*:^2   ::{U+00B2}

:?*:[sup3]::{U+00B3} ; 3
:?*:^3   ::{U+00B3}

:?*:[sup4]::{U+2074} ; 4
:?*:^4   ::{U+2074}

:?*:[sup5]::{U+2075} ; 5
:?*:^5   ::{U+2075}

:?*:[sup6]::{U+2076} ; 6
:?*:^6   ::{U+2076}

:?*:[sup7]::{U+2077} ; 7
:?*:^7   ::{U+2077}

:?*:[sup8]::{U+2078} ; 8
:?*:^8   ::{U+2078}

:?*:[sup9]::{U+2079} ; 9
:?*:^9   ::{U+2079}

:?*:[sup0]::{U+2070} ; 0
:?*:^0   ::{U+2070}

:?*:[supi]::{U+2071} ; i
:?*:^i   ::{U+2071}

:?*:[supn]::{U+207F} ; n
:?*:^n   ::{U+207F}

:?*:[supx]::{U+02E3} ; x
:?*:^x   ::{U+02E3}

:?*:[sup+]::{U+207A} ; +
:?*:^+   ::{U+207A}

:?*:[sup-]::{U+207B} ; -
:?*:^-   ::{U+207B}

:?*:[sup=]::{U+207C} ; =
:?*:^=   ::{U+207C}

:?*:[sup(]::{U+207D} ; (
:?*:^(   ::{U+207D}

:?*:[sup)]::{U+207E} ; )
:?*:^)   ::{U+207E}

; other

:?*:[maru]::〇
:?*:[mrmr]::〇〇

:?*:[~=]::≈
:?*:[=~]::≈
:?*:[!=]::≠

:?*:[tm]::™
:?*:[r]::®

; these are alt-gr + hotkeys
<^>!1:: Send("¡")
<^>!2:: Send("¥")
<^>!3:: Send("¥")
; €
<^>!5:: Send("§")
<^>!8:: Send("°") ; degrees
<^>!Space:: Send("　") ; japanese full width space
<^>!Right:: Send("→")
<^>!Left:: Send("←")
<^>!Up:: Send("↑")
<^>!Down:: Send("↓")
<^>!y:: Send("✓") ; check
<^>!x:: Send("✗") ; cross
<^>!\:: Send("＼")
<^>!/:: Send("／")
<^>!+/:: Send("¿") ; + shift​   upside down question mark​​​​​​​​​​​​
<^>![:: Send("「") ; left corner bracket / opening japanese quotation
<^>!]:: Send("」") ; right ''
<^>!u:: Send("µ") ; mu / micro
<^>!-:: Send("—") ; emdash
<^>!+-:: Send("·") ; latin interpunct
<^>!.:: Send("・") ; japanese interpunct
<^>!c:: Send("¢")

; <^>!RShift:: Send("​")

#InputLevel 1 ; this allows the zwsp to trigger the hotstring
; RShift:: Send("​") ; zwsp character​​​​​​​​​​​​​​​​​​​​​​​​

#HotIf WinActive(A_ScriptName " ahk_exe Code.exe")
~^s::
{
    ; Send("^s")
    ToolTip("Reloading " A_ScriptName ".", A_ScreenWidth / 2, A_ScreenHeight / 2)
    Sleep(250)
    Reload()
    ; MsgBox("reloading !")
    return
}

JEE_RunGetStdOut(vTarget, vSize := "") {
    DetectHiddenWindows(true)
    vComSpec := A_ComSpec ? A_ComSpec : A_ComSpec
    Run(vComSpec, , "Hide", &vPID)
    WinWait("ahk_pid " vPID)
    DllCall("kernel32\AttachConsole", "UInt", vPID)
    oShell := ComObject("WScript.Shell")
    oExec := oShell.Exec(vTarget)
    vStdOut := ""
    if !(vSize = "")
        VarSetStrCapacity(&vStdOut, vSize) ; V1toV2: if 'vStdOut' is NOT a UTF-16 string, use 'vStdOut := Buffer(vSize)'
    while !oExec.StdOut.AtEndOfStream
        vStdOut := oExec.StdOut.ReadAll()
    DllCall("kernel32\FreeConsole")
    ProcessClose(vPID)
    DetectHiddenWindows(false)
    return vStdOut
}
