@REM this converts the file dragged onto the .bat into a gif, it doesnt touch the size or framerate and is intended for those stupid gifs you try download and then they're actually an .mp4.
@REM this is not very space efficient, if you need that, it's probably easier to use https://ezgif.com/
@REM fps = fps
@REM scale = horiz scale
@REM flags = scale stuff - lanczos scaling algorithm is used here
@REM palettegen and paletteuse filters will generate and use a custom palette generated from your input. 
@REM split filter will allow everything to be done in one command and avoids having to create a temporary PNG file of the palette.
@REM Control looping with -loop output option but the values are confusing. A value of 0 is infinite looping, -1 is no looping, and 1 will loop once meaning it will play twice. So a value of 10 will cause the GIF to play 11 times.
@REM from https://superuser.com/questions/556029/how-do-i-convert-a-video-to-gif-using-ffmpeg-with-reasonable-quality

@REM ffmpeg -i %1 -vf "fps=10,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 %1-converted.gif
ffmpeg -i %1 -vf "split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 %1-converted.gif
timeout 5