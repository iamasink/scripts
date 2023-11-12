# [scripts](https://github.com/iamasink/scripts)

random scripts and AHK stuff i use because windows sucks  

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



## Auto startup

### shell:startup

Visit `shell:startup` or `%appdata%\Microsoft\Windows\Start Menu\Programs\Startup`  
Scripts that don't need Administrator or to run before login go here.  
I advise you use shortcuts instead of copying the file, so all scripts are in the same place, if you want to edit them.    
The following scripts can go here  

- spotify.ahk

### Task Scheduler
Some things need to go in Task Scheduler because they run weirdly!  
There are exported xml schedules you can import, but they may need modifying for your user.
 - Run startobs.bat on workstation unlock of any user  
 - Run main script at log on of any user, needs highest privileges   

## Secrets

In `\secrets`, text files are needed for some stuff  
- `homeassistant.txt` - homeassistant access token
  - Goto http://homeassistant.local:8123/profile
  - Scroll to "Long-Lived Access Tokens"
  - Create a token
  - Copy the token it gives you and put it, and only it, into `secrets\homeassistant.txt`
- `adbpin-[SN].txt` - the pin code for scrcpy to automatically log in with, `[SN]` should be the serial number of your device. (supports multiple devices)
  - Run `adb devices` or `adb get-serialno` to get the serial number (you may have to cd to the scrcpy/scrcpy folder)
  - Put your pin code into `secrets\adbpin-[SN].txt`
  - Multiple devices can be used, just make a new file for each one
  - Make sure device is authorised and "always allow" is ticked

### other scripts

#### Uninstall-Spotify.bat
[amd64fox/Uninstall-Spotify](https://github.com/amd64fox/Uninstall-Spotify) can go in `.\spotify\`
#### scrcpy
 - Download latest [Genymobile/scrcpy](https://github.com/Genymobile/scrcpy/releases)
 - Unzip `scrcpy-win64-vx.x.x.zip` to `scrcpy\scrcpy\`, so scrcpy.exe is at `.\scrcpy\scrcpy\scrcpy.exe`

### yt-dlp
 - Download latest `yt-dlp.exe` from https://github.com/yt-dlp/yt-dlp/releases.  
 - Belongs at `ytdlp\yt-dlp.exe`

You may have to change the download location in the yt-dlp .bat scripts. It uses `%userprofile%\Downloads` by default.

---

# keyboard keys
https://www.youtube.com/watch?v=kB2kIAEhjpE
