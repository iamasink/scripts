#Requires AutoHotkey v2.0

CoordMode("Mouse", "Screen")

loop {
    MouseGetPos(&x, &y)
    ToolTip("" x "," y "")
}