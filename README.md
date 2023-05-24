# [scripts](https://github.com/iamasink/scripts)

random scripts and AHK stuff i use because windows sucks  
Mostly for myself like if windows breaks and i have to reset it (again) but maybe my awful ahk stuff is useful for someone ¯\_(ツ)_/¯

## auto start up stuffs

### shell:startup

Visit `shell:startup` or `%appdata%\Microsoft\Windows\Start Menu\Programs\Startup`  
Here, go scripts that don't need Administrator or to run before login.  
I advise you use shortcuts instead of copying the file, so all scripts are in the same place, if you want to edit them.  
Just right click, **Create Shortcut**.

- csgoscripts\startcsgodontblindme.bat  

### Task Scheduler
some things need to go in Task Scheduler because they run weirdly!
run startobs.bat on workstation unlock of any user
run stopobs.bat on workstation lock, maybe needs highest privaleges
run main script at log on of any user, needs highest privielger

## Change this stuff!!!

### secrets

In `secrets`, text files are needed for some stuff  
Currently it's just
- `homeassistant.txt` - homeassistant access token
  - Goto http://homeassistant.local:8123/profile
  - Scroll to "Long-Lived Access Tokens"
  - Create a token
  - Copy the token it gives you and put it, and only it into `secrets\homeassistant.txt`

### csgodontblindme
 - Download latest [dev7355608/csgo_dont_blind_me](https://github.com/dev7355608/csgo_dont_blind_me/releases/)
 - Extract it somewhere you won't delete it
 - Change the path in `csgoscripts\startcsgodontblindme.ps1` 
