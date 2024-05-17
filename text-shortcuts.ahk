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


#InputLevel 0 ; default, must be lower than the one below

#Hotstring EndChars -()[]{}:;'"/\,.?!`n`t ; no space

; press space 3 times to trigger
:*?:@   :: {
    Send(email1)
}
:*?:?@   :: {
    Send(email1)
}
:*?:caps   :: {
    SetCapsLockState("Off")
    Sleep(10)
    SetCapsLockState("AlwaysOff")
}


; these are alt-gr + hotkeys
<^>!1:: Send("¡")
<^>!2:: Send("¥")
<^>!3:: Send("¥")
<^>!5:: Send("§")
<^>!8:: Send("°")
<^>!Space:: Send("　")
<^>!Right:: Send("→")
<^>!Left:: Send("←")
<^>!Up:: Send("↑")
<^>!Down:: Send("↓")
<^>!y:: Send("✓")
<^>!x:: Send("✗")
<^>!\:: Send("＼")
<^>!/:: Send("／")
<^>!+/:: Send("¿") ; + shift
<^>![:: Send("「")
<^>!]:: Send("」")
<^>!u:: Send("µ")
<^>!-:: Send("·")
<^>!c:: Send("¢")
<^>!RShift:: Send("​")

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
    Return
}

JEE_RunGetStdOut(vTarget, vSize := "")
{
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