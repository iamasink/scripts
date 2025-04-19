#Requires AutoHotkey v2.0

Run "https://lucida.to/?url=" . UrlEncode(A_Clipboard) . "&country=auto"


; thank you from https://www.autohotkey.com/boards/viewtopic.php?t=116056
UrlEncode(str, sExcepts := "-_.", enc := "UTF-8")
{
	hex := "00", func := "msvcrt\swprintf"
	buff := Buffer(StrPut(str, enc)), StrPut(str, buff, enc)   ;转码
	encoded := ""
	Loop {
		if (!b := NumGet(buff, A_Index - 1, "UChar"))
			break
		ch := Chr(b)
		; "is alnum" is not used because it is locale dependent.
		if (b >= 0x41 && b <= 0x5A ; A-Z
			|| b >= 0x61 && b <= 0x7A ; a-z
			|| b >= 0x30 && b <= 0x39 ; 0-9
			|| InStr(sExcepts, Chr(b), true))
			encoded .= Chr(b)
		else {
			DllCall(func, "Str", hex, "Str", "%%%02X", "UChar", b, "Cdecl")
			encoded .= hex
		}
	}
	return encoded
}