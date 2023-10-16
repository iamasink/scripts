@REM this converts the file dragged onto the .bat
@REM fps = fps
@REM scale = horiz scale
@REM flags = scale stuff - lanczos scaling algorithm is used here
@REM palettegen and paletteuse filters will generate and use a custom palette generated from your input. 
@REM split filter will allow everything to be done in one command and avoids having to create a temporary PNG file of the palette.
@REM Control looping with -loop output option but the values are confusing. A value of 0 is infinite looping, -1 is no looping, and 1 will loop once meaning it will play twice. So a value of 10 will cause the GIF to play 11 times.
@REM from https://superuser.com/questions/556029/how-do-i-convert-a-video-to-gif-using-ffmpeg-with-reasonable-quality
ffmpeg -i %1
pause
