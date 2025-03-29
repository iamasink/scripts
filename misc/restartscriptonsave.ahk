; also in readme
#HotIf WinActive(A_ScriptName " ahk_exe Code.exe")
~^s::
{
	ToolTip("Reloading " A_ScriptName ".", A_ScreenWidth / 2, A_ScreenHeight / 2)
	Sleep(250)
	Reload()
	Return
}