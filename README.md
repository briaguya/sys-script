# sys-script

sysmodule that runs janet scripts

# Building
if you get to the point of vscode in https://switch.homebrew.guide/ it should work
todo: explain more

## Installing
* After building, copy `sys-script.nsp` to `sdmc:/atmosphere/contents/4200736372697074/exefs.nsp`
* To load the sysmodule at boot, the following file should exist: `sdmc:/atmosphere/contents/4200736372697074/flags/boot2.flag`.
* Copy `playback-tas.janet` to `sdmc:/janet-scripts/playback-tas.janet`
* Copy `tasfile.txt` to `sdmc:/scripts/tasfile.txt`

## Running
* Attach a usb keyboard to your switch
* Pressing `F1` will run `playback-tas.janet` which will read `tasfile.txt` and playback inputs
