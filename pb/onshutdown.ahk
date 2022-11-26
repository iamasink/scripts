#Persistent
OnExit, RunScript
return

RunScript:
  if (A_ExitReason = "Shutdown")
    Run, "C:\Users\sink\Desktop\Stuff\pb\onshutdown.bat"
  ExitApp
return