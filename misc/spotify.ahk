#Requires AutoHotkey v2.0

; this doesnt work

done := 0
inactivetime := 0
timerperiod := 250
DetectHiddenWindows(False)
SetTimer(test, timerperiod)
return


;; Get the handle
getSpotifyHwnd() {
    spotifyHwnd := WinGetID("ahk_exe Spotify.exe")
    ; no idea but apparently its better to do this twice
    spotifyHwnd := DllCall("GetWindow", "uint", spotifyHwnd, "uint", 2)
    spotifyHwnd := DllCall("GetWindow", "uint", spotifyHwnd, "uint", 2)
    Return spotifyHwnd
}

; Send a key, generic
spotifyKey(key) {
    spotifyHwnd := getSpotifyHwnd()
    ; Chromium ignores keys when it isn't focused.
    ; Focus the document window without bringing the app to the foreground.
    ToolTip(spotifyHwnd)
    list := WinGetList("ahk_exe Spotify.exe")
    For Index, Value In list
    {
        ToolTip Value
        try ControlFocus("Chrome_RenderWidgetHostHWND0", "ahk_id " Value)
        ControlSend(key, , "ahk_id " Value)
    }
    ; try ControlFocus("Chrome_RenderWidgetHostHWND1", "ahk_id " spotifyHwnd)
    ; ControlSend(key, , "ahk_id " spotifyHwnd)
    Return
}

test()
{
    global done
    global inactivetime
    if WinActive("ahk_exe Spotify.exe")
    {
        inactivetime := 0
        done := 0
    }
    else {
        inactivetime += timerperiod
        ; ToolTip inactivetime "\n" done
        if (WinExist("ahk_exe Spotify.exe")) {
            ; ToolTip inactivetime " " done
            if (inactivetime > 6000) {
                if (done = 0) {
                    ; spotifyKey("{Escape}")
                    ; Sleep(100)
                    ; spotifyKey("t")
                    WinActivate("ahk_exe Spotify.exe")
                    Sleep(100)
                    Send("{Escape}")
                    Sleep(100)
                    Send("t")
                    Send "!{Esc}" ; activate last active window

                    inactivetime := 0
                    done := 1
                }
            }
        }
    }
    return
}

f7::
{
    ; list := WinGetList("ahk_exe Spotify.exe")
    ; Str := ""
    ; For Index, Value In list
    ;     Str .= "|" . Value
    ; Str := LTrim(Str, "|") ; Remove leading pipes (|)
    ; MsgBox Str


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