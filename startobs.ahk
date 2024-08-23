#Requires AutoHotkey v2.0
; runs on pc unllock

; homeassistantToken := Fileread("secrets\homeassistant.txt") ; load the token from file
; Run(A_ComSpec " /C " "curl -X POST -H `"Authorization: Bearer " homeassistantToken "`" -H `"Content-Type: application/json`" -d `"" "{\`"entity_id\`":\`"switch.lily_monitor\`"}" "`" http://homeassistant.local:8123/api/services/switch/turn_off", , "hide")
; Sleep(2000)
; Run(A_ComSpec " /C " "curl -X POST -H `"Authorization: Bearer " homeassistantToken "`" -H `"Content-Type: application/json`" -d `"" "{\`"entity_id\`":\`"switch.lily_monitor\`"}" "`" http://homeassistant.local:8123/api/services/switch/turn_on", , "hide")

SoundSetMute(0, , "Microphone (4- HyperX QuadCast S)")
Sleep(150)
SoundSetMute(1, , "Microphone (4- HyperX QuadCast S)")

if (!ProcessExist("firefox.exe")) {
    Run(A_ComSpec " /C " "`"C:\Program Files\Mozilla Firefox\firefox.exe`" -new-tab https://google.com", , "hide")
}

; close obs and give it time to close
Run(A_ComSpec " /C " "taskkill /im obs64.exe", , "hide")
Sleep(15000)
; if it didn 't, force close it.
if (ProcessExist("obs64.exe")) {
    Sleep(10000)
    RunWait(A_ComSpec " /C " "taskkill /f /im obs64.exe", , "hide")
}


Run(A_ComSpec " /C " "`"C:\Program Files\obs-studio\bin\64bit\obs64.exe`" --startreplaybuffer --scene default --disable-shutdown-check", "C:\Program Files\obs-studio\bin\64bit\", "hide")