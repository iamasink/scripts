; modified code from https://www.autohotkey.com/boards/viewtopic.php?t=116104 (thank you Seven0528 ILY)
/*
Loop MonitorGetCount()
    Msgbox (A_Clipboard:=MonitorGetName(A_Index))
*/

#Requires AutoHotkey v2.0
#SingleInstance Force
/*
Loop MonitorGetCount()
    Msgbox (A_Clipboard:=MonitorGetName(A_Index))
*/


MonitorInfos := Map()

While EnumDisplayDevices(A_Index - 1, &DISPLAY_DEVICEA0) {
    if !DISPLAY_DEVICEA0["StateFlags"]
        continue
    tp := "    1. EnumDisplayDevices`n`n"
    For k, v in DISPLAY_DEVICEA0
        tp .= k " : " v "`n"
    tp .= "`n`n`n    2. EnumDisplayDevices with EDD_GET_DEVICE_INTERFACE_NAME`n`n"
    EnumDisplayDevices(A_Index - 1, &DISPLAY_DEVICEA1, 1)
    For k, v in DISPLAY_DEVICEA1
        tp .= k " : " v "`n"
    Msgbox (A_Clipboard := tp)


    if RegExMatch(DISPLAY_DEVICEA1["DeviceID"], "(?<=#).*?(?=#)", &M)
        MonitorInfos[DISPLAY_DEVICEA0["DeviceName"]] := Map("GUID", M.0, "Wmi", Map("CurrentBrightness", ""))
}
WmiMonitorInfos := GetWmiMonitorInfos()
Loop WmiMonitorInfos.Count {
    tp := "    3. WMI class`n`n"
    For k, v in WmiMonitorInfos[A_Index]
        tp .= k " : " v "`n"
    Msgbox (A_Clipboard := tp)


    if RegExMatch(DISPLAY_DEVICEA1["DeviceID"], "(?<=\\).*?(?=\\)", &M) {
        For DeviceName, v in MonitorInfos {
            if (v["GUID"] != M.0)
                continue
            MonitorInfos[DeviceName]["Wmi"]["CurrentBrightness"] := WmiMonitorInfos.CurrentBrightness
        }
    }
}

Msgbox (A_Clipboard := JoinArr(MonitorInfos, 3))
ExitApp


/*
EnumDisplayDevicesW function (winuser.h)
    https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-enumdisplaydevicesw
DISPLAY_DEVICEA structure (wingdi.h)
    https://learn.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-display_devicea
Get display name that matches that found in display settings
    https://stackoverflow.com/questions/7486485/get-display-name-that-matches-that-found-in-display-settings
Secondary Monitor
    https://www.autohotkey.com/board/topic/20084-secondary-monitor/
*/
EnumDisplayDevices(iDevNum, &DISPLAY_DEVICEA := "", dwFlags := 0) {
    Static EDD_GET_DEVICE_INTERFACE_NAME := 0x00000001
        , byteCount := 4 + 4 + ((32 + 128 + 128 + 128) * 2)
        , offset_cb := 0
        , offset_DeviceName := 4, length_DeviceName := 32
        , offset_DeviceString := 4 + (32 * 2), length_DeviceString := 128
        , offset_StateFlags := 4 + ((32 + 128) * 2)
        , offset_DeviceID := 4 + 4 + ((32 + 128) * 2), length_DeviceID := 128
        , offset_DeviceKey := 4 + 4 + ((32 + 128 + 128) * 2), length_DeviceKey := 128

    DISPLAY_DEVICEA := ""
    if (iDevNum ~= "\D" || (dwFlags != 0 && dwFlags != EDD_GET_DEVICE_INTERFACE_NAME))
        return false
    lpDisplayDevice := Buffer(byteCount, 0), Numput("UInt", byteCount, lpDisplayDevice, offset_cb)
    if !DllCall("EnumDisplayDevices", "Ptr", 0, "UInt", iDevNum, "Ptr", lpDisplayDevice.Ptr, "UInt", 0)
        return false
    if (dwFlags == EDD_GET_DEVICE_INTERFACE_NAME) {
        DeviceName := StrGet(lpDisplayDevice.Ptr + offset_DeviceName, length_DeviceName)
        lpDisplayDevice.__New(byteCount, 0), Numput("UInt", byteCount, lpDisplayDevice, offset_cb)
        lpDevice := Buffer(length_DeviceName * 2, 0), StrPut(DeviceName, lpDevice, length_DeviceName)
        DllCall("EnumDisplayDevices", "Ptr", lpDevice.Ptr, "UInt", 0, "Ptr", lpDisplayDevice.Ptr, "UInt", dwFlags)
    }
    For k in (DISPLAY_DEVICEA := Map("cb", 0, "DeviceName", "", "DeviceString", "", "StateFlags", 0, "DeviceID", "", "DeviceKey", "")) {
        Switch k
        {
            case "cb", "StateFlags": DISPLAY_DEVICEA[k] := NumGet(lpDisplayDevice, offset_%k%, "UInt")
            default: DISPLAY_DEVICEA[k] := StrGet(lpDisplayDevice.Ptr + offset_%k%, length_%k%)
        }
    }
    return true
}
/*
WmiMonitorID class
    https://learn.microsoft.com/en-us/windows/win32/wmicoreprov/wmimonitorid
WmiMonitorBrightness class
    https://learn.microsoft.com/en-us/windows/win32/wmicoreprov/wmimonitorbrightness
*/
GetWmiMonitorInfos() {
    WmiMonitorAll := Map(), i := 0
    Wmi := ComObjGet("winmgmts:\\.\root\WMI")
    For MonitorID in Wmi.ExecQuery("SELECT * FROM WmiMonitorID WHERE Active=TRUE") {
        UserFriendlyName := ""
        For N in MonitorID.UserFriendlyName.Clone()
            UserFriendlyName .= Chr(N)
        WmiMonitorAll[++i] := Map("InstanceName", MonitorID.InstanceName, "UserFriendlyName", UserFriendlyName, "CurrentBrightness", "")
    }
    for MonitorBrightness in Wmi.ExecQuery("SELECT * FROM WmiMonitorBrightness WHERE Active=TRUE") {
        for i, MonitorID in WmiMonitorAll {
            if (MonitorID["InstanceName"] == MonitorBrightness.InstanceName) {
                WmiMonitorAll[i]["CurrentBrightness"] := MonitorBrightness.CurrentBrightness
                break
            }
        }
    }
    return WmiMonitorAll
}


JoinArr(array, dpt_limit := 0, dpt := 1, delim := "", sep := " : ", l_obj := "[", r_obj := "]") {
    (delim == "" ? delim := ["`n", ", "] : "")
    if !IsObject(array) || (dpt_limit && dpt_limit < dpt)
        return
    Switch IsObject(delim)
    {
        case true:
            if (VerCompare(A_AhkVersion, "2.0-") >= 0)
                c_delim := (dpt <= delim.Length)
                    ? delim[dpt]
                    : delim[delim.Length]
            else
                c_delim := (dpt <= delim.Length())
                    ? delim[dpt]
                    : delim[delim.Length()]
        case false:
            c_delim := delim
    }
    For k, v in array
        str .= IsObject(v)
            ? c_delim (k != A_Index ? k sep : "") l_obj %A_ThisFunc%(v, dpt_limit, dpt + 1, delim, sep, l_obj, r_obj) r_obj
            : c_delim (k != A_Index ? k sep : "") v
    return RegExReplace(str, "sD`a)^\Q" c_delim "\E(.*)", "${1}")
}