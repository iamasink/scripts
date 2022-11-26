# This is taken from [dev7355608/csgo_dont_blind_me](https://github.com/dev7355608/csgo_dont_blind_me). You should reinstall it

# Original Readme

## Install

1. First launch the app and let it generate all necessary files.
2. Copy `gamestate_integration_dont_blind_me.cfg` into either
   - `.../Steam/userdata/________/730/local/cfg` or
   - `.../Steam/steamapps/common/Counter-Strike Global Offensive/csgo/cfg`.
3. Add the launch option -nogammaramp to CS:GO.
   1. Go to the Steam library.
   2. Right click on CS:GO and go to properties.
   3. Click _Set launch options..._ and add `-nogammaramp`.
4. Run `unlock_gamma_range.reg` and restart PC. (Windows only)
5. If you have multiple monitors configured with `Extend these displays`,
   you might need to turn off all but the primary monitor. (Windows only)
6. Set your preferred `mat_monitorgamma` and `mat_monitorgamma_tv_enabled`
   in `settings.ini`.
7. f.lux and Redshift are not compatible: you have to disable both! It runs
   perfectly with Windows Night Light though.

## Uninstall

1. Delete `gamestate_integration_dont_blind_me.cfg` from the cfg folder.
2. Remove the launch option `-nogammaramp`.
3. Run `lock_gamma_range.reg` and restart PC. (Windows only)