#Requires AutoHotkey v2.0


; copy contents of https://cf.trackerslist.com/best.txt to keyboard

A_Clipboard := JEE_RunGetStdOut("curl -s https://cf.trackerslist.com/best.txt")
ToolTip("Copied trackers to clipboard")
Sleep(2000)
ToolTip("")



; runs a command and returns the stdout
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