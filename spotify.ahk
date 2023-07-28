#Requires AutoHotkey v2.0

; this script pressed the "t" key in spotify when the spotify window becomes inactive, and the "escape" key when it becomes active
; this fullscreens spotify with spicetifys fullscreen plugin, and unfullscreens when you switch to spotify

Persistent
last := 1
DetectHiddenWindows(True)
SetTimer(test, 250)
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
    global last
    if WinActive("ahk_exe Spotify.exe")
    {
        if (last = 1) {
            ; Send("{Escape}")
            ToolTip "unfullscreening"
        }
        last := 0
    }
    else {
        if (last = 0) {
            spotifyKey("{Escape}")
            Sleep(100)
            spotifyKey("t")
            ToolTip "fullscreening"
        }
        last := 1
    }
    return
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