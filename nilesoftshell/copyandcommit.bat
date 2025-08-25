@REM remove the local copy, /S remove files in directory, /Q quiet mode (dont ask for confirmation)
rmdir "Nilesoft Shell" /S /Q
@REM copy from config
robocopy "C:\Program Files\Nilesoft Shell" "./Nilesoft Shell" *.nss /s
git add *.nss
git commit -m "Updated nilesoft shell config"
timeout /t 30