#SingleInstance Force

; run all scripts

; if not admin, start as admin
; taken from https://www.autohotkey.com/boards/viewtopic.php?p=523250#p523250
if (!A_IsAdmin) {
    try {
        ; MsgBox("Running as admin...")
        Run("*RunAs `"" A_ScriptFullPath "`"")
        ; wait, so that the script doesnt continue running and instead restarts as admin (hopefully) before this runs out, otherwise it will just close.
        Sleep(10000)
        MsgBox("Couldn't run " A_ScriptName " as admin! Exiting..")
        Sleep(5000)
        ExitApp()
    }
    catch {
        MsgBox("Couldn't run " A_ScriptName " as admin! Exiting..")
        Sleep(5000)
        ExitApp()
    }
}

; run other scripts (this could be #Include, but i dont want it to clog the log for this one!)
kids := ["apploop.ahk", "text-shortcuts.ahk", "../ahk-win-switcher/alttab.ahk", "mainscript2.ahk"]
for s in kids {
    Run("*RunAs .\" s "")
}


; run with an argument (1) to skip my "run as admin" warning in the bat script. (it is ran with admin if this script is.)
Run(A_ComSpec " /C " A_ScriptDir "\synctime.bat 1", A_ScriptDir, "Hide") ; run sync time script

; now exit :)
ExitApp()