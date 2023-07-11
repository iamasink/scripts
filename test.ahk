F7::
{
    homeassistantToken := FileRead("secrets\homeassistant.txt") ; load the token from file

    MsgBox Format("Authorization: Bearer {1}", homeassistantToken)

    ; Run(A_ComSpec " /C " '\', ,)s
    command := '"curl -X POST -H "Authorization: Bearer " -H "Content-Type: application/json" -d "{\`"entity_id\`":\`"light.wiz_rgbw_tunable_b0afb2\`", \`"rgbw_color\`":[255,0,0,255], \`"brightness_pct\`": 100}" http://homeassistant.local:8123/api/services/light/toggle & pause"'
    Run A_ComSpec ' /c '

}

; reload the script when its saved

#HotIf Winactive("Code.exe")
^s:: {
    Send "^s"
    MsgBox("reloading!")
    Reload()
    Return
}