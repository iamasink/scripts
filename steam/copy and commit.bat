@REM this copies the configuration for Steam input desktop
@REM remove the local copy, /S remove files in directory, /Q quiet mode (dont ask for confirmation)
rmdir 413080 /S /Q
@REM copy from steam config
robocopy "C:\Program Files (x86)\Steam\steamapps\common\Steam Controller Configs\341416160\config\413080" "./413080"
git add .
git commit -m "Updated Steam controller config"
timeout /t 30