#Requires AutoHotkey v2.0

; this script presses the "t" key in spotify when the spotify window becomes inactive
; this fullscreens spotify with spicetifys fullscreen plugin

Persistent
done := 0
inactivetime := 0
timerperiod := 250
DetectHiddenWindows(True)
SetTimer(test, timerperiod)
return


;; Get the handle
getSpotifyHwnd() {
    spotifyHwnd := WinGetID("ahk_exe Spotify.exe")
    Return spotifyHwnd
}

; Send a key, generic
spotifyKey(key) {
    spotifyHwnd := getSpotifyHwnd()
    ; Chromium ignores keys when it isn't focused.
    ; Focus the document window without bringing the app to the foreground.
    ControlFocus("Chrome_RenderWidgetHostHWND1", "ahk_id " spotifyHwnd)
    ControlSend(key, , "ahk_id " spotifyHwnd)
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
            if (inactivetime > 1000) {
                if (done = 0) {
                    spotifyKey("{Escape}")
                    Sleep(100)
                    spotifyKey("t")
                    inactivetime := 0
                    done := 1
                }
            }
        }
    }
    return
}

; f7::
; {
;     MsgBox(getSpotifyHwnd())
; }

; reload the script when its saved
#HotIf WinActive(A_ScriptName "ahk_exe Code.exe")
^s::
{
    Send("^s")
    Reload()
    MsgBox("reloading !")
    Return
}