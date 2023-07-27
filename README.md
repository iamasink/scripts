# [scripts](https://github.com/iamasink/scripts)

random scripts and AHK stuff i use because windows sucks  
Mostly for myself like if windows breaks and i have to reset it (again) but maybe my awful ahk stuff is useful for someone ¯\\\_(ツ)\_/¯

## auto start up stuffs

### shell:startup

Visit `shell:startup` or `%appdata%\Microsoft\Windows\Start Menu\Programs\Startup`  
Scripts that don't need Administrator or to run before login go here.
I advise you use shortcuts instead of copying the file, so all scripts are in the same place, if you want to edit them.  
The following scripts can go here

- spotify.ahk

### Task Scheduler
some things need to go in Task Scheduler because they run weirdly!
run startobs.bat on workstation unlock of any user
run main script at log on of any user, needs highest privileges 

## Change this stuff!!!

### secrets

In `secrets`, text files are needed for some stuff  
Currently it's just
- `homeassistant.txt` - homeassistant access token
  - Goto http://homeassistant.local:8123/profile
  - Scroll to "Long-Lived Access Tokens"
  - Create a token
  - Copy the token it gives you and put it, and only it, into `secrets\homeassistant.txt`

### csgodontblindme
 - Download latest [dev7355608/csgo_dont_blind_me](https://github.com/dev7355608/csgo_dont_blind_me/releases/)
 - Extract it somewhere you won't delete it
 - Change the path in `csgoscripts\startcsgodontblindme.ps1` 

### yt-dlp
you may have to change the folders for yt-dlp scripts, especially if you don't have a local account because onedrive might mess stuff up :)
