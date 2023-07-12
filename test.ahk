; reload the script when its saved

#HotIf Winactive("Code.exe")
^s:: {
    Send "^s"
    MsgBox("reloading!")
    Reload()
    Return
}