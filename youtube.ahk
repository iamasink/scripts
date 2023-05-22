#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%
SetTitleMatchMode,2 ;A window's title can contain WinTitle anywhere inside it to be a match.
#InstallMouseHook

#Persistent

HideShowTaskbar(action) {
   static ABM_SETSTATE := 0xA, ABS_AUTOHIDE := 0x1, ABS_ALWAYSONTOP := 0x2
   VarSetCapacity(APPBARDATA, size := 2*A_PtrSize + 2*4 + 16 + A_PtrSize, 0)
   NumPut(size, APPBARDATA), NumPut(WinExist("ahk_class Shell_TrayWnd"), APPBARDATA, A_PtrSize)
   NumPut(action ? ABS_AUTOHIDE : ABS_ALWAYSONTOP, APPBARDATA, size - A_PtrSize)
   DllCall("Shell32\SHAppBarMessage", UInt, ABM_SETSTATE, Ptr, &APPBARDATA)
}

repeat:
{
	WinGetTitle, title, A
	If (InStr(title, "YouTube")) {
		If (New = 1) {
			HideShowTaskbar(true)
			; WinHide, ahk_class Shell_TrayWnd
		}
		New = 0

		If (A_TimeIdleMouse>=10000) {
			If (New2 = 0) {
				Send, f
			}
			New2 = 1
		} else {
			If (New2 = 1) {
				Send, f
			}
			New2 = 0
		}
	} else {
		If (New = 0) {
			HideShowTaskbar(false)
			; WinShow, ahk_class Shell_TrayWnd
		}
		New = 1
	}
}

SetTimer, repeat, 250

; reload the script when its saved
#IfWinActive ahk_exe Code.exe
	^s::
	Send ^s
	reload %A_ScriptFullPath%
	msgbox, reloading!
return

