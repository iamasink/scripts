# scripts
random scripts and AHK stuff i use because windows sucks

this is mostly for me if windows breaks i can setup everything again but like its public because someone could find it useful i guess

## Task Scheduler
Import the .xml files by clicking **Import Task...* on the right.
You might have to change the user: click **Change User or Group...**, enter your username and press **Check Names**.
Everything else should be setup from the import.
For some it might ask for your password, this is because it is running as Administrator, before you log in.

## shell:startup
Visit `shell:startup` or `%appdata%\Microsoft\Windows\Start Menu\Programs\Startup`
Here, go scripts that don't need Administrator or to run before login.
I advise you use shortcuts instead of copying the file, so you can find it again if you need to edit it
- onshutdown.ahk
- remove spacedesk popup.ahk
- startcsgodontblindme.bat
