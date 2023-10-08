@REM this converts all flacs in the folder to .mp3 in a very high quality
for %%f in (*.flac) do (  ffmpeg -i "%%f" -ab 320k -map_metadata 0 -id3v2_version 3 "%%f.mp3" ) 