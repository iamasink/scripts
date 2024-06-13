#Requires AutoHotkey v2.0
; a couple of hotkeys for Windows 11 File Explorer


; Get the WebBrowser object of the active Explorer tab for the given window,
; or the window itself if it doesn't have tabs.  Supports IE and File Explorer.
GetActiveExplorerTab(hwnd := WinExist("A")) { ; from https://www.autohotkey.com/boards/viewtopic.php?f=83&t=109907
    activeTab := 0
    try activeTab := ControlGetHwnd("ShellTabWindowClass1", hwnd) ; File Explorer (Windows 11)
    catch
        try activeTab := ControlGetHwnd("TabWindowClass1", hwnd) ; IE
    for w in ComObject("Shell.Application").Windows {
        if w.hwnd != hwnd
            continue
        if activeTab { ; The window has tabs, so make sure this is the right one.
            static IID_IShellBrowser := "{000214E2-0000-0000-C000-000000000046}"
            shellBrowser := ComObjQuery(w, IID_IShellBrowser, IID_IShellBrowser)
            ComCall(3, shellBrowser, "uint*", &thisTab := 0)
            if thisTab != activeTab
                continue
        }
        return w
    }
}
;
GetParentFolder(path) {
    splitpath := StrSplit(path, "\")
    splitpath.Pop() ; remove the last element (filename)
    Str := ""
    For Index, Value In splitpath
        Str .= Value . "\"
    ; Str := RTrim(Str, "\") ; remove the last slash
    return Str
}
GetFileName(pathOrFile) { ; get name without extension
    filename := GetFileNameAndExtension(pathOrFile)
    splitname := StrSplit(filename, ".")
    ; combine all elements except the last one
    Str := ""
    For Index, Value In splitname
        if (Index != splitname.Length)
            Str .= Value . "."
    Str := RTrim(Str, ".") ; remove the last dot
    return Str
}
GetFileExtension(pathOrFile) {
    filename := GetFileNameAndExtension(pathOrFile)
    splitname := StrSplit(filename, ".")
    extension := splitname[splitname.Length]
    return extension
}
GetFileNameAndExtension(pathOrFile) {
    splitpath := StrSplit(pathOrFile, "\")
    filename := splitpath[splitpath.Length]
    return filename
}

#HotIf WinActive("ahk_class CabinetWClass ahk_exe explorer.exe") ; Only run if Explorer is active
CapsLock & .:: { ; unzip selected archive(s)
    tab := GetActiveExplorerTab() ; get the active windows 11 explorer tab
    switch type(tab.Document) {
        case "ShellFolderView":
            {
                SelectedItems := tab.Document.SelectedItems ; get selected items
                ; MsgBox ; debug info
                ; (
                ;     "Variant type:`t" ComObjType(d) "
                ;     Interface name:`t" ComObjType(d, "Name") "
                ;     Interface ID:`t" ComObjType(d, "IID") "
                ;     Class name:`t" ComObjType(d, "Class") "
                ;     Class ID (CLSID):`t" ComObjType(d, "CLSID")
                ; )
                numberofselecteditems := 0
                for folderItem, b in SelectedItems {
                    numberofselecteditems++
                }

                for folderItem, b in SelectedItems { ; https://learn.microsoft.com/en-us/windows/win32/shell/folderitem
                    ; MsgBox folderItem.Path ;
                    path := folderItem.Path
                    parentfolder := GetParentFolder(path)
                    filename := GetFileName(path)
                    newfoldername := filename
                    fileextension := GetFileExtension(path)

                    ; test if file can be extracted
                    testOutput := ComObject("WScript.Shell").Exec("7z t `"" path "`"").StdOut.ReadAll()
                    ; if testoutput contains "Everything is Ok"
                    if (InStr(testOutput, "Everything is Ok")) {
                        ; MsgBox("File can be extracted: " path)
                    } else {
                        MsgBox("File cannot be extracted: " path "`nIt may be corrupt or this archive format is not supported.", , "0x30")
                        continue
                    }

                    newpath := parentfolder "" newfoldername "\"

                    if (FileExist(newpath)) {
                        ; MsgBox("Folder already exists: " newpath)
                        ; rename the folder to something else, make sure it doesn't already exist
                        i := 1
                        loop {
                            newpath := parentfolder "" filename " (" i ")\"
                            if (!FileExist(newpath)) {
                                break
                            }
                            i++
                        }
                        newfoldername := filename " (" i ")"
                        newpath := parentfolder "" newfoldername "\"
                    }
                    DirCreate(newpath)

                    if (numberofselecteditems > 1) {
                        ToolTip("Extracting " numberofselecteditems " archives to " parentfolder)
                    } else {
                        ToolTip("Extracting " filename " to " newpath)
                        tab.Navigate(newpath) ; navigate to the extracted folder in the current tab
                    }
                    command := A_ComSpec " /C " " 7z x `"" path "`" -aou -o`"" newpath "`""
                    ; MsgBox(command)
                    RunWait(command, , "Hide")
                    ; ClipWait
                    ; MsgBox(A_Clipboard)


                    ; -aou renames extracting file if it already exists https://7-zip.opensource.jp/chm/cmdline/switches/overwrite.htm
                    ; https://superuser.com/questions/95902/7-zip-and-unzipping-from-command-line

                    ; Run(A_ComSpec " /c `"" "7z x " path " -aou -o" parentfolder "\" filename)

                }

                SoundPlay(A_WinDir "\Media\ding.wav")
                Sleep(1000)
                ToolTip()
                ; success sound

            }
        default:
            {
                ToolTip("Not a folder view")
                Sleep(1000)
                ToolTip()
            }
    }
}
CapsLock & ,:: ; open full path for folder, ie C:\Users\user\Documents instead of Documents
{
    tab := GetActiveExplorerTab() ; get the active windows 11 explorer tab
    switch type(tab.Document) {
        case "ShellFolderView":
            {
                tab.Navigate(tab.Document.Folder.Self.Path) ; navigate, in current tab, to the current folder
            }
        default:
            {
                ToolTip("Not a folder view")
                Sleep(1000)
                ToolTip()
            }
    }
}


#HotIf WinActive(A_ScriptName "ahk_exe Code.exe")
^s::
{
    Send("^s")
    Reload()
    MsgBox("reloading !")
    Return
}