#Requires AutoHotkey v2.0

speed := 20
clickBtn := "Left"
configured := false

mygui := Gui("+AlwaysOnTop", "Auto Clicker Setup")

mygui.AddText("x10 y10", "Click interval (ms):")
speedEdit := mygui.AddEdit("x10 y30 w120", speed)

mygui.AddText("x10 y65", "Mouse button:")

rbLeft := mygui.AddRadio("x10 y85 Checked", "Left")
rbRight := mygui.AddRadio("x10 y105", "Right")
rbMiddle := mygui.AddRadio("x10 y125", "Middle")

okBtn := mygui.AddButton("x10 y200 w180 Default", "OK")

okBtn.OnEvent("Click", SetupDone)

mygui.Show("w200 h240")

SetupDone(*) {
    global speed, clickBtn, configured, mygui

    speed := Integer(speedEdit.Value)
    if (speed <= 0)
        speed := 20

    if rbRight.Value
        clickBtn := "Right"
    else if rbMiddle.Value
        clickBtn := "Middle"
    else
        clickBtn := "Left"

    configured := true
    mygui.Destroy()
}

while true {
    if configured && GetKeyState("ScrollLock", "T") {
        Click(clickBtn)
        Sleep(speed)
    } else {
        Sleep(1000)
        }
        }

^F12:: {
    ToolTip("bye")
    Sleep(2000)
    ExitApp
}



#HotIf WinActive(A_ScriptName " ahk_exe Code.exe")
~^s:: {
    ; Send("^s")
    ToolTip("Reloading " A_ScriptName ".", A_ScreenWidth / 2, A_ScreenHeight / 2)
    Sleep(250)
    Reload()
    ; MsgBox("reloading !")
    return
}