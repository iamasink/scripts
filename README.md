# scripts

random scripts and AHK stuff i use because windows sucks  

## shell:startup

Visit `shell:startup` or `%appdata%\Microsoft\Windows\Start Menu\Programs\Startup`  
Here, go scripts that don't need Administrator or to run before login.  
I advise you use shortcuts instead of copying the file, so all scripts are in the same place, if you want to edit them.  
Just right click, **Create Shortcut**.

- csgoscripts\startcsgodontblindme.bat

## secrets

In `secrets`, text files are needed for some stuff  
Currently it's just
- `homeassistant.txt` - homeassistant access token
  - Goto http://homeassistant.local:8123/profile
  - Scroll to "Long-Lived Access Tokens"
  - Create a token
  - Copy the token it gives you and put it, and only it into `secrets\homeassistant.txt`