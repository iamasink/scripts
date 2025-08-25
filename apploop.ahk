#Requires AutoHotkey v2.0
#SingleInstance force
TraySetIcon(A_ScriptDir "\icon\ahkocean16.ico")
SetTitleMatchMode("RegEx")
CoordMode("ToolTip")
homeassistantToken := Fileread("secrets\homeassistant.txt") ; load the token from file


#Include includes\Peep.v2.ahk


; if not admin, start as admin
; taken from https://www.autohotkey.com/boards/viewtopic.php?p=523250#p523250
if (!A_IsAdmin) {
    try {
        Run("*RunAs `"" A_ScriptFullPath "`"")
    }
    catch {
        MsgBox("Couldn't run " A_ScriptName " as admin! Some things may not work")
    }
}


apps := [{
    app: "ahk_exe Blitz\.exe$",
    affinity: binary("10001000"),
    priority: -1,
    flags: []
}, {
    app: "ahk_exe LeagueClientUx\.exe$",
    flags: [runblitz]
}, {
    app: "ahk_exe League of Legends\.exe$",
    flags: [closelbm]
}, {
    app: "ahk_exe .*-Win64-Shipping\.exe$",
    flags: [closelbm],
},]


cpumask(cpuList*) {
    mask := 0
    for cpu in cpuList {
        mask |= (1 << cpu)
    }
    return mask
}
binary(binStr) {
    dec := 0
    len := StrLen(binStr)
    for i, c in StrSplit(binStr) {
        dec := (dec << 1) | (c = "1" ? 1 : 0)
    }
    return dec
}
; collect unique flags from all apps with fast lookup
states := []
seen := Map()
for app in apps {
    for flag in app.flags {
        if !seen.Has(flag) {
            seen[flag] := true
            states.Push(flag)
        }

    }
}
seen := Map()
closeobs(state := true) {
    ; MsgBox(state)
}
closelbm(state := true) {
    closeapp(state,
        "LBM",
        ["LittleBigMouse.Hook.exe", "LittleBigMouse.Ui.Avalonia.exe"],
        ["`"C:\Program Files\LittleBigMouse\LittleBigMouse.Ui.Avalonia.exe`" --start"]
    )
}
runblitz(state := true) {
    closeapp(!state, "blitz", ["Blitz.exe"], [A_AppData "\..\Local\Programs\Blitz\Blitz.exe"], false, true)
}
closeapp(state := true, name := "", closelist := [], runlist := [], hideLaunch := false, forceClose := false) {
    closelist := closelist
    runlist := runlist


    if (name == "" && runlist.Length)
        name := runlist[1]

    if (state) {
        CenteredTooltip("Closing " name)
        for app in closelist {
            cmd := "taskkill"
            if forceClose
                cmd .= " /f"
            cmd .= " /im " app
            Run(cmd, , "Hide")
        }
    } else {
        ; app closing → launch targets
        CenteredTooltip("Launching " name)
        for app in runlist {
            Run(app, , hideLaunch ? "Hide" : "")
        }
    }
}
enabledstates := Map()
for state in states {
    enabledstates[state] := false
}
SetTimer(checkapps, 5000)
checkapps()
checkapps() {
    tempStates := Map()

    for flag in enabledstates {
        tempStates[flag] := false
    }

    ; mark a flag active if any app using it is running
    for app in apps {
        if (WinExist(app.app)) {
            ; set flags
            for flag in app.flags {
                tempStates[flag] := true
            }
        }
        ; set priority and affinity
        if (app.HasOwnProp("priority") && app.priority != 0) {
            SetPriority(app.app, app.priority)
        }
        if (app.HasOwnProp("affinity") && app.affinity != 0) {
            SetAffinity(app.app, app.affinity)
        }
    }

    ; compare with previous states and trigger on change
    for flag in enabledstates {
        prev := enabledstates[flag]
        curr := tempStates[flag]
        if (curr != prev) {
            ; run function
            flag.Call(curr)
            enabledstates[flag] := curr
        }
    }
}
SetPriority(appname, Level := "Normal") {
    static pidcache := Map()

    prio := "Normal"

    if !IsNumber(Level)
        norm := StrLower(StrReplace(StrReplace(Level, " ", ""), "_", ""))
    else
        norm := String(Level)

    switch norm {
        case "-2", "l", "low":
            prio := "Low"
        case "-1", "b", "belownormal":
            prio := "BelowNormal"
        case "0", "n", "normal":
            prio := "Normal"
        case "1", "a", "abovenormal":
            prio := "AboveNormal"
        case "2", "h", "high":
            prio := "High"
        case "3", "r", "realtime":
            prio := "Realtime"
        Default:
            prio := "Normal"
    }

    DetectHiddenWindows(true)
    hwnds := WinGetList(appname)

    pids := Map()
    for hwnd in hwnds {
        pid := WinGetPID("ahk_id " hwnd)
        if (pid && !pids.Has(pid)) {
            pids[pid] := true
        }
    }


    exeName := ""
    if RegExMatch(appname, ".*ahk_exe\s+([^\s\\]+).*", &m) {
        exeName := m[1]
    }

    if (!exeName) {
        MsgBox("Cannot extract exe name from: " appname)
        return
    }
    exepids := GetPIDsByExeName(exeName)

    for pid in exepids {
        pids[pid] := true
    }


    for pid in pids {
        if pidcache.Has(pid) {
            lastPrio := pidcache[pid]
        } else {
            lastPrio := ""
        }
        if (lastPrio != prio) {
            CenteredTooltip("changing priority of " appname " to " prio "`n" pid)
            ProcessSetPriority(prio, pid)
            pidcache[pid] := prio
        }

    }
    DetectHiddenWindows(false)
}
GetPIDsByExeName(exeName) {
    pids := []
    wmi := ComObjGet("winmgmts:")
    query := "Select ProcessId from Win32_Process Where Name='" exeName ".exe'"
    processes := wmi.ExecQuery(query)
    for proc in processes {
        pids.Push(proc.ProcessId)
    }
    return pids
}
SetAffinity(appname, affinityMask) {
    static pidcache := Map()

    exeName := ""
    if RegExMatch(appname, ".*ahk_exe\s+([^\s\\]+).*", &m)
        exeName := m[1]

    if !exeName {
        MsgBox("Cannot extract exe name from: " appname)
        return
    }

    DetectHiddenWindows(true)
    hwnds := WinGetList(appname)

    pids := Map()
    for hwnd in hwnds {
        pid := WinGetPID("ahk_id " hwnd)
        if (pid && !pids.Has(pid)) {
            pids[pid] := true
        }
    }


    exepids := GetPIDsByExeName(exeName)

    for pid in exepids {
        pids[pid] := true
    }
    for pid in pids {
        if pidcache.Has(pid) {
            lastAffinity := pidcache[pid]
        } else {
            lastAffinity := ""
        }
        if (lastAffinity != affinityMask) {
            CenteredTooltip("changing affinity of " exeName " to " affinityMask "`nPID: " pid)
            ; set affinity using DllCall
            hProcess := DllCall("OpenProcess", "UInt", 0x0200 | 0x0400, "Int", false, "UInt", pid, "Ptr")
            if hProcess {
                DllCall("SetProcessAffinityMask", "Ptr", hProcess, "Ptr", affinityMask)
                DllCall("CloseHandle", "Ptr", hProcess)
                pidcache[pid] := affinityMask
            }
        }
    }
    DetectHiddenWindows(false)
}
CenteredTooltip(text, time := 2500, radius := 500) {
    static tooltipID := 0
    static activeIDs := Map()

    id := 0
    loop 20 {
        idx := (tooltipID + A_Index) > 20 ? (tooltipID + A_Index) - 20 : (tooltipID + A_Index)
        if (!activeIDs.Has(idx)) {
            id := idx
            break
        }
    }
    if (!id)
        id := 1

    tooltipID := id
    activeIDs[id] := true

    angle := (id - 1) * (2 * 3.14159265 / 20) ; equally spaced
    x := (A_ScreenWidth / 2) + radius * Cos(angle)
    y := (A_ScreenHeight / 2) + radius * Sin(angle)
    ToolTip(text, x, y, id)

    SetTimer(() => cleartooltip(), -time)

    cleartooltip() {
        ToolTip(, , , id)
        activeIDs.Delete(id)
    }
}

#HotIf WinActive(A_ScriptName " ahk_exe Code.exe")
~^s:: {
    ; Send("^s")
    ToolTip("Reloading " A_ScriptName ".", A_ScreenWidth / 2, A_ScreenHeight / 2)
    Sleep(1000)
    Reload()
    ; MsgBox("reloading !")
    return
}
homeassistantRequest(requestJSON, url, wait := false) {
    ; get token from variable earlier
    global homeassistantToken
    if (wait) {
        RunWait(A_ComSpec " /C " "curl -X POST -H `"Authorization: Bearer " homeassistantToken "`" -H `"Content-Type: application/json`" -d `"" requestJSON "`" http://homeassistant.local:8123/api/" url, ,
            "hide")
    } else {
        Run(A_ComSpec " /C " "curl -X POST -H `"Authorization: Bearer " homeassistantToken "`" -H `"Content-Type: application/json`" -d `"" requestJSON "`" http://homeassistant.local:8123/api/" url, ,
            "hide")
    }
}
