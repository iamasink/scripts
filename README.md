# [scripts](https://github.com/iamasink/scripts)

random scripts and AHK stuff i use because windows sucks  
Mostly for myself like if windows breaks and i have to reset it (again) but maybe my awful ahk stuff is useful for someone ¯\\\_(ツ)\_/¯

## my setup
### Mouse: G502
  - Side    / DPI shift - F21  
  - DPI Up  /  G8       - F22  
  - DPI Down  /  G7     - F23  
  - Top middle  / G9    - F24  
### Keyboard: Wooting 2 HE  
  - A1	 - F13  
  - A2	 - F14  
  - A3	 - F15  
  - Mode - F16  
The original functions for these keys (switching keyboard profile) are available in the FN layer.



## auto start up stuff

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
there are exported xml schedules you can import, but they may need changing if usernames and stuff are different

## Change this stuff!!!

### secrets

In `secrets`, text files are needed for some stuff  
- `homeassistant.txt` - homeassistant access token
  - Goto http://homeassistant.local:8123/profile
  - Scroll to "Long-Lived Access Tokens"
  - Create a token
  - Copy the token it gives you and put it, and only it, into `secrets\homeassistant.txt`
- `adbpin-[SN].txt` - the pin code for scrcpy to log in, `[SN]` should be the serial number of your device
  - run `adb devices` or `adb get-serialno` to get the serial number (you may have to cd to the scrcpy/scrcpy folder)
  - put your pin code into `secrets\adbpin-[SN].txt`
  - multiple devices can be used, just make a new file for each one
  - make sure device is authorised and "always allow" is ticked

### other scripts

#### csgodontblindme 
(i no longer use this because it doesn't work with multiple monitors)  
 - Download latest [dev7355608/csgo_dont_blind_me](https://github.com/dev7355608/csgo_dont_blind_me/releases/)
 - Extract it somewhere you won't delete it
 - Change the path in `csgoscripts\startcsgodontblindme.ps1`
#### Uninstall-Spotify.bat
[amd64fox/Uninstall-Spotify](https://github.com/amd64fox/Uninstall-Spotify) goes in `.\spotify\`
#### scrcpy
 - Download latest [Genymobile/scrcpy](https://github.com/Genymobile/scrcpy/releases)
 - Unzip `scrcpy-win64-vx.x.x.zip` to `scrcpy\scrcpy\`, so scrcpy.exe is at `.\scrcpy\scrcpy\scrcpy.exe`

### yt-dlp
you may have to change the download locatio for yt-dlp .bat scripts, especially if you don't have a local account because onedrive might mess stuff up :)

### key
https://www.youtube.com/watch?v=kB2kIAEhjpE
