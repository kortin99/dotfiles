# yabai 最新官方文档
## 最新官方 wiki 文档


### What is System Integrity Protection and why does it need to be disabled?

System Integrity Protection ("rootless") is a security feature of macOS first introduced in 10.13, then further locked down in 10.14.

System Integrity Protection protects some files and directories from being modified&thinsp;—&thinsp;even from the root user. yabai needs System Integrity Protection to be (partially) disabled so that it can inject a scripting addition into Dock.app, which owns the sole connection to the macOS window server. Many features of yabai require this scripting addition to be running such that yabai can modify windows, spaces and displays in a way that otherwise only Dock.app could.

The following features of yabai require System Integrity Protection to be (partially) disabled:

* focus/move/swap/create/destroy space
* remove window shadows
* enable window transparency
* enable window animations
* scratchpad windows
* control window layers (make windows appear topmost or on the desktop)
* sticky windows (make windows appear on all spaces on the display that contains the window)
* toggle picture-in-picture for any given window

See [this comment](https://github.com/koekeishiya/yabai/issues/1863) for a more in-depth explanation.

### How do I disable System Integrity Protection?

1. Turn off your device
2. **Intel [(apple docs)](https://support.apple.com/en-gb/guide/mac-help/mchl338cf9a8/12.0/mac/12.0):**  
Hold down <kbd>command ⌘</kbd><kbd>R</kbd> while booting your device.  
 
   **Apple Silicon [(apple docs)](https://support.apple.com/en-gb/guide/mac-help/mchl82829c17/12.0/mac/12.0):**  
Press and hold the power button on your Mac until “Loading startup options” appears.  
Click Options, then click Continue.
3. In the menu bar, choose `Utilities`, then `Terminal`
4.
```bash
#
# APPLE SILICON
#

# If you're on Apple Silicon macOS 13.x.x
# Requires Filesystem Protections, Debugging Restrictions and NVRAM Protection to be disabled
# (printed warning can be safely ignored)
csrutil enable --without fs --without debug --without nvram

# If you're on Apple Silicon macOS 12.x.x
# Requires Filesystem Protections, Debugging Restrictions and NVRAM Protection to be disabled
# (printed warning can be safely ignored)
csrutil disable --with kext --with dtrace --with basesystem

#
# INTEL
#

# If you're on Intel macOS 13.x.x, 12.x.x, or 11.x.x
# Requires Filesystem Protections and Debugging Restrictions to be disabled (workaround because --without debug does not work)
# (printed warning can be safely ignored)
csrutil disable --with kext --with dtrace --with nvram --with basesystem
```

5. Reboot
6. For Apple Silicon; enable non-Apple-signed arm64e binaries
```
# Open a terminal and run the below command, then reboot
sudo nvram boot-args=-arm64e_preview_abi
```
7. You can verify that System Integrity Protection is turned off by running `csrutil status`, which returns `System Integrity Protection status: disabled.` if it is turned off (it may show `unknown` for newer versions of macOS when disabling SIP partially).

If you ever want to re–enable System Integrity Protection after uninstalling yabai; repeat the steps above, but run `csrutil enable` instead at step 4.

Please note that System Integrity Protection will be re–enabled during device repairs or analysis at any Apple Retail Store or Apple Authorized Service Provider. You will have to repeat this step after getting your device back.

# Installing yabai (latest release)

A codesigned binary release can be installed using the yabai [installer script](https://github.com/koekeishiya/yabai/blob/master/scripts/install.sh); it will always point at the latest release version.

```sh
# install yabai binary into /usr/local/bin and man page yabai.1 into /usr/local/man/man1
curl -L https://raw.githubusercontent.com/koekeishiya/yabai/master/scripts/install.sh | sh /dev/stdin

# install yabai binary into ~/.local/bin and man page yabai.1 into ~/.local/man
curl -L https://raw.githubusercontent.com/koekeishiya/yabai/master/scripts/install.sh | sh /dev/stdin ~/.local/bin ~/.local/man
```

Alternatively, Homebrew can also be used from the tap `koekeishiya/formulae`.

```sh
brew install koekeishiya/formulae/yabai
```

**macOS Big Sur:**

Open `System Preferences.app` and navigate to `Security & Privacy`, then `Privacy`, then `Accessibility`.
Click the lock icon at the bottom and enter your password to allow changes to the list.

**macOS Ventura and above:**

Open `System Settings.app` and navigate to `Privacy & Security`, then `Accessibility`.
Click the + button at the bottom left of the list view and enter your password to allow changes to the list.

Starting with `yabai --start-service` will prompt the user to allow `yabai` accessibility permissions.
Check the box next to `yabai` to allow accessibility permissions.

If you disabled System Integrity Protection; [configure the scripting addition](https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)#configure-scripting-addition). Afterwards simply start yabai. 

```sh
# start yabai
yabai --start-service
```

### Updating to the latest release

To update yabai to the latest version, simply upgrade it with the yabai installer script or Homebrew (depending on the original installation method) and [reconfigure the scripting addition](https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)#configure-scripting-addition) again:

```sh
# stop yabai
yabai --stop-service

# upgrade yabai with installer script -- (with or without directory override)
curl -L https://raw.githubusercontent.com/koekeishiya/yabai/master/scripts/install.sh | sh /dev/stdin

# or

# upgrade yabai with homebrew (remove old service file because homebrew changes binary path)
yabai --uninstall-service
brew upgrade yabai

# start yabai
yabai --start-service
```

### Configure scripting addition

**yabai** uses the macOS Mach APIs to inject code into Dock.app; this requires elevated (root) privileges.
You can configure your user to execute *yabai --load-sa* as the root user without having to enter a password. 
To do this, we add a new configuration entry that is loaded by */etc/sudoers*.

```
# create a new file for writing - visudo uses the vim editor by default.
# go read about this if you have no idea what is going on.

sudo visudo -f /private/etc/sudoers.d/yabai

# input the line below into the file you are editing.
#  replace <yabai> with the path to the yabai binary (output of: which yabai).
#  replace <user> with your username (output of: whoami). 
#  replace <hash> with the sha256 hash of the yabai binary (output of: shasum -a 256 $(which yabai)).
#   this hash must be updated manually after upgrading yabai.

<user> ALL=(root) NOPASSWD: sha256:<hash> <yabai> --load-sa
```

If you know what you are doing, the following one-liner can be used to update the sudoers file correctly:
```
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
```

After the above edit has been made, add the command to load the scripting addition at the top of your yabairc config file

```
# for this to work you must configure sudo such that
# it will be able to run the command without password

yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
sudo yabai --load-sa

# .. more yabai startup stuff
```



# Installing yabai (from HEAD)

If you want to run the latest and greatest version of yabai, you can install off of `HEAD`. Note that this will require codesigning with a self-signed certificate, so you'll have to create one first (and only once).

First, open `Keychain Access.app`. In its menu, navigate to `Keychain Access`, then `Certificate Assistance`, then click `Create a Certificate...`. This will open the `Certificate Assistant`. Choose these options:

- Name: `yabai-cert`,
- Identity Type: `Self-Signed Root`
- Certificate Type: `Code Signing`

Click `Create`, then `Continue` to create the certificate.

If you already have a release version installed, you need to uninstall that first due to how brew works:

```sh
brew uninstall koekeishiya/formulae/yabai
```

Now onto installing yabai:

```sh
brew install koekeishiya/formulae/yabai --HEAD
codesign -fs 'yabai-cert' $(brew --prefix yabai)/bin/yabai
```

**macOS Big Sur:**

Open `System Preferences.app` and navigate to `Security & Privacy`, then `Privacy`, then `Accessibility`.
Click the lock icon at the bottom and enter your password to allow changes to the list.

**macOS Ventura and above:**

Open `System Settings.app` and navigate to `Privacy & Security`, then `Accessibility`.
Click the + button at the bottom left of the list view and enter your password to allow changes to the list.

Starting with `yabai --start-service` will prompt the user to allow `yabai` accessibility permissions.
Check the box next to `yabai` to allow accessibility permissions.

If you disabled System Integrity Protection; [configure the scripting addition](https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(from-HEAD)#configure-scripting-addition). Afterwards simply start yabai. 

```sh
# start yabai
yabai --start-service
```

### Updating to latest HEAD

To upgrade yabai to the latest version from HEAD, simply reinstall it with Homebrew, codesign it, and [reconfigure the scripting addition](https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(from-HEAD)#configure-scripting-addition) again:

```sh
# set codesigning certificate name here (default: yabai-cert)
export YABAI_CERT=

# stop yabai
yabai --stop-service

# reinstall yabai (remove old service file because homebrew changes binary path)
yabai --uninstall-service
brew reinstall koekeishiya/formulae/yabai
codesign -fs "${YABAI_CERT:-yabai-cert}" "$(brew --prefix yabai)/bin/yabai"

# finally, start yabai
yabai --start-service
```

### Configure scripting addition

**yabai** uses the macOS Mach APIs to inject code into Dock.app; this requires elevated (root) privileges.
You can configure your user to execute *yabai --load-sa* as the root user without having to enter a password. 
To do this, we add a new configuration entry that is loaded by */etc/sudoers*.

```
# create a new file for writing - visudo uses the vim editor by default.
# go read about this if you have no idea what is going on.

sudo visudo -f /private/etc/sudoers.d/yabai

# input the line below into the file you are editing.
#  replace <yabai> with the path to the yabai binary (output of: which yabai).
#  replace <user> with your username (output of: whoami). 
#  replace <hash> with the sha256 hash of the yabai binary (output of: shasum -a 256 $(which yabai)).
#   this hash must be updated manually after upgrading yabai.

<user> ALL=(root) NOPASSWD: sha256:<hash> <yabai> --load-sa
```

If you know what you are doing, the following one-liner can be used to update the sudoers file correctly:
```
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
```

After the above edit has been made, add the command to load the scripting addition at the top of your yabairc config file

```
# for this to work you must configure sudo such that
# it will be able to run the command without password

yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
sudo yabai --load-sa

# .. more yabai startup stuff
```

# Uninstalling yabai

The following steps will help you remove all traces of yabai from your system.

```shell
# stop yabai
yabai --stop-service

# remove service file
yabai --uninstall-service

# uninstall the scripting addition
sudo yabai --uninstall-sa

# uninstall yabai
brew uninstall yabai

# these are logfiles that may be created when running yabai as a service.
rm -rf /tmp/yabai_$USER.out.log
rm -rf /tmp/yabai_$USER.err.log

# remove config and various temporary files
rm ~/.yabairc
rm /tmp/yabai_$USER.lock
rm /tmp/yabai_$USER.socket
rm /tmp/yabai-sa_$USER.socket

# unload the scripting addition by forcing a restart of Dock.app
killall Dock
```
# configuration

A short and concise overview of options available with your current installation is available using `man yabai` or for the current development version as a [&rightarrow;&nbsp;rendered document][docs-config].

### Configuration file

The per-user yabai configuration file is just a shell script that's ran before yabai launches. It is executed using `/usr/bin/env sh -c <config_file>` if the exec-bit is set, or interpreted using `/usr/bin/env sh <config_file>` if not. It must be placed at one of the following places (in order):

 - `$XDG_CONFIG_HOME/yabai/yabairc`
 - `$HOME/.config/yabai/yabairc`
 - `$HOME/.yabairc`

```sh
# create empty configuration file and make it executable
touch ~/.yabairc
chmod +x ~/.yabairc
```

All of the configuration options can be changed at runtime as well.

### Debug output and error reporting

In the case that something is not working as you're expecting, please make sure to take a look in the output and error log. To enable debug output make sure that your configuration file contains `yabai -m config debug_output on` or that yabai is launched with the `--verbose` flag. If you are running yabai as a service, the output and error log can be viewed as follows: 

```sh
# view the last lines of the error log 
tail -f /tmp/yabai_$USER.err.log

# view the last lines of the debug log
tail -f /tmp/yabai_$USER.out.log
```

### Tiling options

#### Layout

Layout defines whether windows are tiled ("managed", "bsp") by yabai or left alone ("float"). This setting can be defined on a per–space basis.

```sh
# bsp or float (default: float)
yabai -m config layout bsp

# Override default layout for space 2 only
yabai -m config --space 2 layout float
```

By default, new windows become the right or bottom split when tiled, which can be changed to left or top.

```
# New window spawns to the left if vertical split, or top if horizontal split
yabai -m config window_placement first_child

# New window spawns to the right if vertical split, or bottom if horizontal split
yabai -m config window_placement second_child
```

#### Padding and gaps

When tiling windows, yabai can maintain gaps between windows and padding towards menu bar, dock and screen edges. This setting can be defined on a per–space basis.

```sh
# Set all padding and gaps to 20pt (default: 0)
yabai -m config top_padding    20
yabai -m config bottom_padding 20
yabai -m config left_padding   20
yabai -m config right_padding  20
yabai -m config window_gap     20

# Override gaps for space 2 only
yabai -m config --space 2 window_gap 0
```

#### Split ratios

Auto balance makes it so all windows always occupy the same space, independent of how deeply nested they are in the window tree. When a new window is inserted or a window is removed, the split ratios will be automatically adjusted.

```sh
# on or off (default: off)
yabai -m config auto_balance off
```

If auto balance is disabled, the split ratio defines how much space each window occupies after a new split is created. A value of 0.5 means that both old and new window occupy the same space; a value of 0.2 means that the old window occupies 20% of the available space and the new window occupies 80% of the available space. New windows are inserted at the right or bottom side. The ratio needs to be between 0 and 1.

```sh
# Floating point value between 0 and 1 (default: 0.5)
yabai -m config split_ratio 0.5
```

### Mouse support

If you resize a tiled window, yabai will attempt to adjust splits to fit automatically.

When you drag a tiled window onto another, yabai will either swap their positions in the window tree, or modify the window tree by splitting the region occupied by the window. The action is determined by drop-zones; 25% of the region towards a particular edge will result in a warp operation towards that direction, and the center (50%) of the window will trigger either a swap or stack operation (based on the value of `yabai -m config mouse_drop_action`). See [this picture](https://user-images.githubusercontent.com/4488655/61372700-23c32e00-a898-11e9-8052-aeb5db9f4e13.png) for a visual illustration.

Additionally, yabai can enable you to move and resize windows by clicking anywhere on them while holding a modifier key.

```sh
# set mouse interaction modifier key (default: fn)
yabai -m config mouse_modifier fn

# set modifier + left-click drag to move window (default: move)
yabai -m config mouse_action1 move

# set modifier + right-click drag to resize window (default: resize)
yabai -m config mouse_action2 resize
```

With focus follows mouse, you can also focus windows without having to click on them. This can be set to either autofocus (window gets focused, but not raised) or autoraise (window gets raised as if it was clicked on). Focus follows mouse is disabled while holding the mouse modifier key so that you can access the menu bar easily.

```sh
# set focus follows mouse mode (default: off, options: off, autoraise, autofocus)
yabai -m config focus_follows_mouse autoraise
```

Mouse follows focus makes it so that when yabai focuses another window (e.g. through a focus command), the mouse cursor gets moved to the center of the focused window.

```sh
# set mouse follows focus mode (default: off)
yabai -m config mouse_follows_focus on
```

### Window modifications

yabai allows modifying the way macOS presents windows. 

```sh
# modify window shadows (default: on, options: on, off, float)
# example: show shadows only for floating windows
yabai -m config window_shadow float

# window opacity (default: off)
# example: render all unfocused windows with 90% opacity
yabai -m config window_opacity on
yabai -m config active_window_opacity 1.0
yabai -m config normal_window_opacity 0.9
```

### Status bar

Third-party tools like [&rightarrow;&nbsp;Übersicht][gh-uebersicht] and [&rightarrow;&nbsp;Sketchybar][gh-sketchybar] can be used to create custom status bars.

There is also an option to integrate your custom bar with the padding functionality (specifically: `space --toggle padding`)  that yabai provides. Note that you do not need to include this padding in the regular space settings.

```sh
# add 20 padding to the top and 0 padding to the bottom of every space located on the main display
yabai -m config external_bar main:20:0
# add 20 padding to the top and bottom of all spaces regardless of the display it belongs to
yabai -m config external_bar all:20:20
``` 

You can turn on autohiding of the macOS menubar so that it only shows up when you move your cursor to access it: 

```shell
macOS Big Sur:
System Preferences -> General -> Automatically hide and show the menu bar.

macOS Monterey:
System Preferences -> Dock & Menu bar -> Select Dock & Menu bar in left sidebar

macOS Ventura:
System Settings -> Desktop & Dock -> Scroll down to the Menu Bar heading

macOS Sonoma:
System Settings -> Control Centre -> Scroll down to "Automatically Hide and Show the menu bar"
```

In yabai v6.0.12+ you can also completely disable the menubar using `yabai -m config menubar_opacity 0.0`regardless this setting.

[docs-config]: https://github.com/koekeishiya/yabai/blob/master/doc/yabai.asciidoc#config
[gh-uebersicht]: https://github.com/felixhageloh/uebersicht
[gh-sketchybar]: https://github.com/felixkratz/sketchybar

# commands


This wiki page aims to explain some of the available commands in detail. 

A short and concise overview of all commands available with your current installation is available using `man yabai` or for the current development version as a [&rightarrow;&nbsp;rendered document][docs-display].

### Message passing interface

Messages can be passed to a running yabai instance using `yabai --message` (or `yabai -m` in short). These messages aim to have a very intuitive format that should be easy to remember. 

The format for commands is `yabai -m <category> <command>`. 

You might remember this format from the previous chapter about [&rightarrow;&nbsp;configuration options][wiki-config], which used the same message passing interface. 

The [&rightarrow;&nbsp;example&nbsp;skhdrc][example-skhdrc] shows how you can integrate these commands with [&rightarrow;&nbsp;skhd][gh-skhd], a hotkey utility for macOS. This file is an example showing how to control yabai using keyboard shortcuts. Note that it is not a good example for all keyboard layouts and is highly opinionated. It is recommended to build your own skhdrc file from scratch to suit your needs.

Most commands will return a non-zero exit code upon failure, which is useful for scripting purposes.

### Display commands

The arrangement indices for displays can be seen in the Displays > Arrangement preference pane in the System Preferences.

#### Focus display

```sh
# Focus display focused before the current one (so you can alternate)
yabai -m display --focus recent

# Focus previous display by arrangement index
yabai -m display --focus prev

# Focus next display by arrangement index
yabai -m display --focus next

# Focus display with arrangement index 2
yabai -m display --focus 2
```

### Space commands

The mission-control indices for spaces can be seen when mission control is active.

#### Focus space

```sh
# Focus space focused before the current one (so you can alternate)
yabai -m space --focus recent

# Focus previous space by mission-control index
yabai -m space --focus prev

# Focus next space by mission-control index
yabai -m space --focus next

# Focus space with mission-control index 2
yabai -m space --focus 2

# Focus next space by mission-control index if one exists, otherwise focus the first space
yabai -m space --focus next || yabai -m space --focus first

# Focus previous space by mission-control index if one exists, otherwise focus the last space
yabai -m space --focus prev || yabai -m space --focus last
```

#### Create and destroy spaces

```sh
# Create space on the active display
yabai -m space --create

# Delete focused space and focus first space on display
yabai -m space --destroy
```

#### Move spaces

```sh
# Move space left
yabai -m space --move prev

# Move space right
yabai -m space --move next

# Send space to display 2 (by display arrangement index)
yabai -m space --display 2
```

#### Label Spaces

Spaces can be given labels, which allow referring to a space by the given label in subsequent commands. 

To label a space use the `--label` command:

```
yabai -m space 1 --label main
yabai -m space 2 --label sm

yabai -m space --focus main
```

#### Modify window tree

In bsp spaces commands can be used to modify the window tree, affecting all windows on the space.

```sh
# Balance out all windows both horizontally and vertically 
#   to occupy the same space
yabai -m space --balance

# Flip the tree horizontally
yabai -m space --mirror x-axis

# Flip the tree vertically
yabai -m space --mirror y-axis

# Rotate the window tree clock-wise (options: 90, 180, 270 degree)
yabai -m space --rotate 90
```

#### Modify space layout

```sh
# Set layout of the space (options: bsp, float)
yabai -m space --layout bsp
```

#### Modify padding and gaps

```sh
# toggle padding on the current space
yabai -m space --toggle padding

# add 10 to the top padding, subtract 5 from the left and right padding
# format: top:bottom:left:right (rel = relative)
yabai -m space --padding rel:10:0:-5:-5

# set all padding to 20 (abs = absolute)
yabai -m space --padding abs:20:20:20:20

# toggle gap between windows on the current space
yabai -m space --toggle gap

# add 10 to gap between windows (rel = relative)
yabai -m space --gap rel:10

# set gap between windows to 0 (abs = absolute)
yabai -m space --gap abs:0
```

### Window commands

Window commands are special in that they can either be operated on the focused window or on any visible window if a) the window id is supplied and b) the command makes sense. 

If you want to operate on an unfocused, visible window, replace `yabai -m window` with `yabai -m window window-id` below. This is mostly for automation. Window identifiers can be obtained through signals and the query system. 

#### Focus window

```sh
# focus window in direction of focused window (options: north, east, south, west)
yabai -m window --focus east

# focus window that was previously focused
yabai -m window --focus recent

# focus previous or next window in window tree (options: prev, next)
yabai -m window --focus prev

# focus first or last window in window tree (options: first, last)
yabai -m window --focus first

# focus window under cursor
yabai -m window --focus mouse
```

#### Move window

Tiled window can be swapped with other windows.

```sh
# swap window position and size with window in direction of focused window
#   (options: north, east, south, west)
yabai -m window --swap north

# swap with previously focused window
yabai -m window --swap recent

# swap with previous or next window in window tree (options: prev, next)
yabai -m window --swap prev

# swap with first or last window in window tree (options: first, last)
yabai -m window --swap first

# swap with window under cursor
yabai -m window --swap mouse
```

The following illustrates how you can use the swap operation to implement window cycling.

cycle_clockwise.sh:
```sh
#!/bin/bash

win=$(yabai -m query --windows --window last | jq '.id')

while : ; do
    yabai -m window $win --swap prev &> /dev/null
    if [[ $? -eq 1 ]]; then
        break
    fi
done
```

cycle_counterclockwise.sh
```sh
#!/bin/bash

win=$(yabai -m query --windows --window first | jq '.id')

while : ; do
    yabai -m window $win --swap next &> /dev/null
    if [[ $? -eq 1 ]]; then
        break
    fi
done
```

Tiled windows can also be re-inserted ("warped") at other windows. 

```sh
# warp at window in direction of focused window
#   (options: north, east, south, west)
yabai -m window --warp north

# warp at previously focused window
yabai -m window --warp recent

# warp at previous or next window in window tree (options: prev, next)
yabai -m window --warp prev

# warp at first or last window in window tree (options: first, last)
yabai -m window --warp first

# warp at window under cursor
yabai -m window --warp mouse
```

Floating windows can be moved and resized to absolute coordinates and sizes.

```sh
# move focused window to (100, 200)
yabai -m window --move abs:100:200

# change window size to (500, 800)
yabai -m window --resize abs:500:800
```

Floating windows can also be moved and resized using relative coordinates and sizes.

```sh
# move focused window 100 to the right, 200 up
yabai -m window --move rel:100:-200

# grow window by 100 to the right, shrink by 200 at the bottom
#   (options: top, left, bottom, right, top_left, top_right, bottom_right, bottom_left)
yabai -m window --resize bottom_right:100:-200

# change window size to (500, 800)
yabai -m window --resize abs:500:800
```

Floating windows can also be moved and resized at the same time by placing them on a grid. The grid format is `<rows>:<cols>:<start-x>:<start-y>:<width>:<height>`, where rows and cols are how many rows and columns there are in total, start-x and start-y are the start indices for the row and column and width and height are how many rows and columns the window spans. 

The grid respects the padding enabled for the space.

```
# move focused window to occupy the left two thirds of the screen. 
yabai -m window --grid 1:3:0:0:2:1
```

Move window to another space or display. As with other commands this works using prev, next, last and mission-control index or arrangement index respectively.

```sh
# move window to previous space
yabai -m window --space prev

# move window to display focused before the current one
yabai -m window --display recent

# move window to space 2
yabai -m window --space 2

# move window to space 2 and switch to space 2 (works with both SIP enabled and disabled)
yabai -m window --space 2 --focus
```

Tiled windows may also be zoomed to either occupy the parent nodes space or the full screen, and windows may also be moved into their own space ("native fullscreen").

```sh
# options: zoom-parent, zoom-fullscreen, native-fullscreen
yabai -m window --toggle zoom-parent
```

Whether a window is split vertically or horizontally with its parent node can be toggled as well.

```sh
yabai -m window --toggle split
```

#### Toggle window properties

You can also toggle some other window properties.

```sh
# toggle whether the focused window should be tiled (only on bsp spaces)
yabai -m window --toggle float

# toggle whether the focused window should be shown on all spaces
yabai -m window --toggle sticky
```

### Automation with rules and signals

Rules and signals can be used to automate window management. Rules define how windows that match app name and optionally title with the rule should be managed, and signals are asynchronous external actions that can be triggered on window management events, e.g. when a window is destroyed or the space is changed.

The [&rightarrow;&nbsp;rules docs][docs-rule] and [&rightarrow;&nbsp;signals docs][docs-signal] have detailed information on these. If you need help creating such an automation, feel free to search the issue board and, if no result was found, create an issue asking for help. 

Here are some example rules and signals.

```sh
# float system preferences
yabai -m rule --add app="^System Preferences$" manage=off

# show digital colour meter topmost and on all spaces
yabai -m rule --add app="^Digital Colou?r Meter$" sticky=on

# refresh my Übersicht bar when the space changes
yabai -m signal --add event=space_changed \
    action="osascript -e 'tell application \"Übersicht\" to refresh widget id \"spaces-widget\"'"
```

### Querying information

yabai can also query information about displays, spaces and windows. There are a total of 12 queries available, which can be enhanced easily using [&rightarrow;&nbsp;jq][gh-jq] to filter the JSON formatted output.

||`yabai -m query --displays`|`yabai -m query --spaces`|`yabai -m query --windows`|
|-:|-|-|-|
||Query all displays|Query all spaces|Query all windows|
|`--display [arrangement index]`|Query focused/selected display|Query all spaces on focused/selected display|Query all windows on focused/selected display|
|`--space [mission-control index]`|Query display with focused/selected space|Query focused/selected space|Query all windows on focused/selected space|
|`--window [window id]`|Query display with focused/selected window|Query space with focused/selected window|Query focused/selected window|

For example, to get the window identifiers of all windows on space 2, you could run the following command:

```sh
yabai -m query --windows --space 2 | jq '.[].id'
```

[docs-display]: https://github.com/koekeishiya/yabai/blob/master/doc/yabai.asciidoc#display
[wiki-config]: https://github.com/koekeishiya/yabai/wiki/Configuration
[example-skhdrc]: https://github.com/koekeishiya/yabai/blob/master/examples/skhdrc
[docs-rule]: https://github.com/koekeishiya/yabai/blob/master/doc/yabai.asciidoc#rule
[docs-signal]: https://github.com/koekeishiya/yabai/blob/master/doc/yabai.asciidoc#signal
[gh-skhd]: https://github.com/koekeishiya/skhd
[gh-jq]: https://github.com/stedolan/jq


# Tips and tricks

### Quickly restart the yabai launch agent

When running as a service, the following command can be used:

```sh
yabai --restart-service

# e.g. bind to key in skhd:
# ctrl + alt + cmd - r : yabai --restart-service"
```

### Split yabai configuration across multiple files

The below script loads all executable files (`chmod +x`) in `~/.config/yabai/` and executes them. Why? Because then parts of your config can be reloaded individually from signals or external triggers.

```sh
# find all executable files in ~/.config/yabai and execute them
find "${HOME}/.config/yabai" -type f -perm +111 -exec {} \;
```

### Fix folders opened from desktop not tiling

When opening a folder on the desktop there's an animation that conflicts with yabai trying to tile the window. This animation can be disabled:

```sh
defaults write com.apple.finder DisableAllAnimations -bool true
killall Finder # or logout and login

# to reset system defaults, delete the key instead
# defaults delete com.apple.finder DisableAllAnimations
```

### Fix spaces reordering automatically

In System Preferences, navigate to Mission Control and uncheck the option "Automatically rearrange Spaces based on most recent use". 


### Auto updating from HEAD via brew

The below snippet makes yabai check for updates whenever it starts and automatically installs them for you, only requiring you to enter your password (or use Touch ID) if you want to update the scripting addition as well. Just put it at the end of your yabai configuration file and forget about it.

Note that this is only works for installations from HEAD (`brew install yabai --HEAD`).

<details>
<summary>Click to expand snippet</summary>

#### Method 1

This downloads an up-to-date version of the yabai autoupdate script hosted by [@dominiklohmann](https://github.com/dominiklohmann) and executes it whenever yabai starts.

```sh
YABAI_CERT=yabai-cert sh -c "$(curl -fsSL "https://git.io/update-yabai")" &
```

#### Method 2

This does the same as above, except the update snippet doesn't update itself. Check back for changes. Last update: 2019-07-12.

```sh
# set codesigning certificate name here (default: yabai-cert)
YABAI_CERT=

function main() {
    if check_for_updates; then
        install_updates ${YABAI_CERT}
    fi
}

# WARNING
# -------
# Please do not touch the code below unless you absolutely know what you are
# doing. It's the result of multiple long evenings trying to get this to work
# and relies on terrible hacks to work around limitations of launchd.
# For questions please reach out to @dominiklohmann via GitHub.

LOCKFILE="${TMPDIR}/yabai_update.lock"
if [ -e "${LOCKFILE}" ] && kill -0 $(cat "${LOCKFILE}"); then
	echo "Update already in progress"
	exit
fi

trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
echo "$$" > ${LOCKFILE}

function check_for_updates() {
	set -o pipefail

	# avoid GitHub rate limitations when jq is installed by using the GitHub 
	# API instead of ls-remote
	if command -v jq > /dev/null 2>&1; then
		installed="$(brew info --json /yabai \
			| jq -r '.[0].installed[0].version')"
		remote="$(curl -fsSL "https://api.github.com/repos/koekeishiya/yabai/commits" \
			| jq -r '"HEAD-" + (.[0].sha | explode | .[0:7] | implode)')"
	else
		installed="$(brew info /yabai | grep 'HEAD-' \
			| awk '{print substr($1,length($1)-6)}')"
		remote="$(git ls-remote 'https://github.com/koekeishiya/yabai.git' HEAD \
			| awk '{print substr($1,1,7)}')"
	fi

	[ ${?} -eq 0 ] && [[ "${installed}" != "${remote}" ]]
}

function install_updates() {

	echo "[yabai-update] reinstalling yabai"
	brew reinstall yabai > /dev/null 2>&1
	
	echo "[yabai-update] codesigning yabai"
	codesign -fs "${1:-yabai-sign}" "$(brew --prefix yabai)/bin/yabai" > /dev/null

	echo "[yabai-update] checking installed scripting addition"
	if yabai --check-sa; then
		osascript > /dev/null <<- EOM
			display dialog "A new version of yabai was just installed and yabai will restart shortly." with title "$(yabai --version)" buttons {"Okay"} default button 1
		EOM
	else
		echo "[yabai-update] prompting to reinstall scripting addition"
		script="$(mktemp)"
		cat > ${script} <<- EOF
			#! /usr/bin/env sh
			sudo yabai --uninstall-sa
			sudo yabai --install-sa
			pkill -x Dock
		EOF
		chmod +x "${script}"
		osascript > /dev/null <<- EOM
			display dialog "A new version of yabai was just installed and yabai will restart shortly.\n\nDo you want to reinstall the scripting addition (osascript will prompt for elevated privileges)?" with title "$(yabai --version)" buttons {"Install", "Cancel"} default button 2
			if button returned of result = "Install" then
				do shell script "${script}" with administrator privileges
			end if
		EOM
		rm -f "${script}"
	fi
	
	echo "[yabai-update] restarting yabai"
	yabai --restart-service
}

(main && rm -f "${LOCKFILE}") &
```

</details>

### Tiling Emacs

Emacs is not a well-behaved citizen of macOS. Try using [&rightarrow;&nbsp;emacs-mac](https://bitbucket.org/mituharu/emacs-mac) from the Homebrew tap [&rightarrow;&nbsp;emacsmacport](https://github.com/railwaycat/homebrew-emacsmacport).

If Emacs is still not recognized by yabai, try enabling menu-bar-mode.

```emacs-lisp
(menu-bar-mode t)
```

### Flash highlight to identify focused window 

The following command can be bound to a hotkey to identify the focused window on demand.
```
yabai -m window --opacity 0.1 && sleep $(yabai -m config window_opacity_duration) && yabai -m window --opacity 0.0
```

The following signal can be added to your yabai config to automatically flash the focused window when focus changes.
```
yabai -m signal --add label="flash_focus" event="window_focused" action="yabai -m window \$YABAI_WINDOW_ID --opacity 0.1 && sleep $(yabai -m config window_opacity_duration) && yabai -m window \$YABAI_WINDOW_ID --opacity 0.0"
```

### Constrain space focus to current display with optional cycling

Focus next space of current display. No-op if the current space is the last space of its display.

space_focus_next.sh
```
if [[ $(yabai -m query --spaces --display | jq '.[-1]."has-focus"') == "false" ]]; then yabai -m space --focus next; fi
```

Focus previous space of current display. No-op if the current space is the first space of its display.

space_focus_prev.sh
```
if [[ $(yabai -m query --spaces --display | jq '.[0]."has-focus"') == "false" ]]; then yabai -m space --focus prev; fi
```

Focus next space of current display. Wrap to the first space of the current display if the current space is the last space of its display.

space_cycle_next.sh
```
info=$(yabai -m query --spaces --display)
last=$(echo $info | jq '.[-1]."has-focus"')

if [[ $last == "false" ]]; then
    yabai -m space --focus next
else
    yabai -m space --focus $(echo $info | jq '.[0].index')
fi
```

Focus previous space of current display. Wrap to the last space of the current display if the current space is the first space of its display.

space_cycle_prev.sh
```
info=$(yabai -m query --spaces --display)
first=$(echo $info | jq '.[0]."has-focus"')

if [[ $first == "false" ]]; then
    yabai -m space --focus prev
else
    yabai -m space --focus $(echo $info | jq '.[-1].index')
fi
```




































## 最新 asciidoc 格式文档
:man source:   Yabai
:man version:  {revnumber}
:man manual:   Yabai Manual

ifdef::env-github[]
:toc:
:toc-title:
:toc-placement!:
endif::[]

yabai(1)
========

ifdef::env-github[]
toc::[]
endif::[]

Name
----

yabai - window manager

Synopsis
--------

*yabai* [*--load-sa*|*--uninstall-sa*|*--install-service*|*--uninstall-service*|*--start-service*|*--restart-service*|*--stop-service*|*--message*,*-m* 'msg'|*--config*,*-c* 'config_file'|*--verbose*,*-V*|*--version*,*-v*|*--help*,*-h*]

Description
-----------

*yabai* is a tiling window manager for macOS based on binary space partitioning.

Options
-------
*--load-sa*::
    Load the scripting-addition into Dock.app. +
    Installs and updates the scripting-addition when necessary. +
    Path is /Library/ScriptingAdditions/yabai.osax. +
    System Integrity Protection must be partially disabled.

*--uninstall-sa*::
    Uninstall the scripting-addition. Must be run as root. +
    Path is /Library/ScriptingAdditions/yabai.osax. +
    System Integrity Protection must be partially disabled.

*--install-service*::
    Writes a launchd service file to disk. +
    Path is ~/Library/LaunchAgents/com.koekeishiya.yabai.plist.

*--uninstall-service*::
    Removes a launchd service file from disk. +
    Path is ~/Library/LaunchAgents/com.koekeishiya.yabai.plist.

*--start-service*::
    Enables, loads, and starts the launchd service. +
    Will install service file if it does not exist.

*--restart-service*::
    Attempts to restart the service instance.

*--stop-service*::
    Stops a running instance of the service and unloads it.

*--message*, *-m* '<msg>'::
    Send message to a running instance of yabai.

*--config*, *-c* '<config_file>'::
    Use the specified configuration file. +
    Executes using `/usr/bin/env sh -c <config_file>` if the exec-bit is set. +
    Interpreted using `/usr/bin/env sh <config_file>` if the exec-bit is unset.

*--verbose*, *-V*::
    Output debug information to stdout.

*--version*, *-v*::
    Print version to stdout and exit.

*--help*, *-h*::
    Print options to stdout and exit.

Definitions
-----------

[subs=+macros]
----
REGEX       := https://www.gnu.org/software/findutils/manual/html_node/find_html/posix_002dextended-regular-expression-syntax.html[POSIX extended regular expression syntax]

LABEL       := arbitrary string/text used as an identifier

LAYER       := below | normal | above | auto

BOOL_SEL    := on | off

FLOAT_SEL   := 0 < <value> <= 1.0

RULE_SEL    := <index> | LABEL

SIGNAL_SEL  := <index> | LABEL

DIR_SEL     := north | east | south | west

STACK_SEL   := stack.prev | stack.next | stack.first | stack.last | stack.recent

WINDOW_SEL  := prev | next | first | last | recent | mouse | largest | smallest | sibling | first_nephew | second_nephew | uncle | first_cousin | second_cousin | STACK_SEL | DIR_SEL | <window id>

DISPLAY_SEL := prev | next | first | last | recent | mouse | DIR_SEL | <arrangement index (1-based)> | LABEL

SPACE_SEL   := prev | next | first | last | recent | mouse | <mission-control index (1-based)> | LABEL

EASING      := ease_in_sine  | ease_out_sine  | ease_in_out_sine  |
               ease_in_quad  | ease_out_quad  | ease_in_out_quad  |
               ease_in_cubic | ease_out_cubic | ease_in_out_cubic |
               ease_in_quart | ease_out_quart | ease_in_out_quart |
               ease_in_quint | ease_out_quint | ease_in_out_quint |
               ease_in_expo  | ease_out_expo  | ease_in_out_expo  |
               ease_in_circ  | ease_out_circ  | ease_in_out_circ
----

Domains
-------

Config
~~~~~~

General Syntax
^^^^^^^^^^^^^^

yabai -m config <global setting>::
    Get or set the value of <global setting>.

yabai -m config [--space '<SPACE_SEL>'] <space setting>::
    Get or set the value of <space setting>.

Global Settings
^^^^^^^^^^^^^^^

*debug_output* ['<BOOL_SEL>']::
    Enable output of debug information to stdout.

*external_bar* ['<main|all|off>:<top_padding>:<bottom_padding>']::
    Specify top and bottom padding for a potential custom bar that you may be running. +
    'main': Apply the given padding only to spaces located on the main display. +
    'all':  Apply the given padding to all spaces regardless of their display. +
    'off':  Do not apply any special padding.

*menubar_opacity* ['<FLOAT_SEL>']::
    Changes the transparency of the macOS menubar. +
    If the value is 0.0, the menubar will no longer respond to mouse-events, effectively hiding the menubar permanently. +
    The menubar will automatically become fully opaque upon entering a native-fullscreen space, and adjusted down afterwards.

*mouse_follows_focus* ['<BOOL_SEL>']::
    When focusing a window, put the mouse at its center.

*focus_follows_mouse* ['autofocus|autoraise|off']::
    Automatically focus the window under the mouse.

*display_arrangement_order* ['default|vertical|horizontal']::
    Specify how displays are ordered (determined by center point). +
    'default': Native macOS ordering. +
    'vertical': Order by y-coordinate (followed by x-coordinate when equal). +
    'horizontal': Order by x-coordinate (followed by y-coordinate when equal).

*window_origin_display* ['default|focused|cursor']::
    Specify which display a newly created window should be managed in. +
    'default': The display in which the window is created (standard macOS behaviour). +
    'focused': The display that has focus when the window is created. +
    'cursor': The display that currently holds the mouse cursor.

*window_placement* ['first_child|second_child']::
    Specify whether managed windows should become the first or second leaf-node.

*window_zoom_persist* ['<BOOL_SEL>']::
    Windows will keep their zoom-state through layout changes.

*window_shadow* ['<BOOL_SEL>|float']::
    Draw shadow for windows. +
    System Integrity Protection must be partially disabled.

*window_opacity* ['<BOOL_SEL>']::
    Enable opacity for windows. +
    System Integrity Protection must be partially disabled.

*window_opacity_duration* ['<FLOAT_SEL>']::
    Duration of transition between active / normal opacity. +
    System Integrity Protection must be partially disabled.

*active_window_opacity* ['<FLOAT_SEL>']::
    Opacity of the focused window. +
    System Integrity Protection must be partially disabled.

*normal_window_opacity* ['<FLOAT_SEL>']::
    Opacity of an unfocused window. +
    System Integrity Protection must be partially disabled.

*window_animation_duration* ['<FLOAT_SEL>']::
    Duration of window frame animation. +
    If 0.0, the change in dimension is not animated. +
    Requires Screen Recording permissions. +
    System Integrity Protection must be partially disabled.

*window_animation_easing* ['<EASING>']::
    Easing function to use for window animations. +
    See https://easings.net for details.

*insert_feedback_color* ['0xAARRGGBB']::
    Color of the *window --insert* message and mouse_drag selection. +
    The purpose is to provide a visual preview of the new window frame.

*split_ratio* ['<FLOAT_SEL>']::
    Specify the size distribution when a window is split.

*split_type* ['vertical|horizontal|auto']::
    Specify how a window should be split. +
    'vertical': The window is split along the y-axis. +
    'horizontal': The window is split along the x-axis. +
    'auto': The axis is determined based on width/height ratio.

*mouse_modifier* ['cmd|alt|shift|ctrl|fn']::
    Keyboard modifier used for moving and resizing windows.

*mouse_action1* ['move|resize']::
    Action performed when pressing 'mouse_modifier' + 'button1'.

*mouse_action2* ['move|resize']::
    Action performed when pressing 'mouse_modifier' + 'button2'.

*mouse_drop_action* ['swap|stack']::
    Action performed when a bsp-managed window is dropped in the center of some other bsp-managed window.

Space Settings
^^^^^^^^^^^^^^

*layout* ['bsp|stack|float']::
    Set the layout of the selected space.

*top_padding* ['<integer number>']::
    Padding added at the upper side of the selected space.

*bottom_padding* ['<integer number>']::
    Padding added at the lower side of the selected space.

*left_padding* ['<integer number>']::
    Padding added at the left side of the selected space.

*right_padding* ['<integer number>']::
    Padding added at the right side of the selected space.

*window_gap* ['<integer number>']::
    Size of the gap that separates windows for the selected space.

*auto_balance* ['<BOOL_SEL>']::
    Balance the window tree upon change, so that all windows occupy the same area.

Display
~~~~~~~

General Syntax
^^^^^^^^^^^^^^

yabai -m display ['<DISPLAY_SEL'>] '<COMMAND>'

COMMAND
^^^^^^^

*--focus* '<DISPLAY_SEL>'::
    Focus the given display.

*--space* '<SPACE_SEL>'::
    The given space will become visible on the selected display, without changing focus. +
    The given space must belong to the selected display. +
    System Integrity Protection must be partially disabled.

*--label* ['<LABEL>']::
    Label the selected display, allowing that label to be used as an alias in commands that take a `DISPLAY_SEL` parameter. +
    If the command is called without an argument it will try to remove a previously assigned label.

Space
~~~~~

General Syntax
^^^^^^^^^^^^^^

yabai -m space ['<SPACE_SEL>'] '<COMMAND>'

COMMAND
^^^^^^^

*--focus* '<SPACE_SEL>'::
    Focus the given space. +
    System Integrity Protection must be partially disabled.

*--switch* '<SPACE_SEL>'::
    The selected space will always be the currently focused space. +
    The given space substitutes the selected space, gaining focus. +
    If the selected space and the given space belong to different displays, this behaves like '--swap'. +
    If the selected space and the given space belong to the same display, this behaves like '--focus'. +
    System Integrity Protection must be partially disabled.

*--create*  ['<DISPLAY_SEL>']::
    Create a new space on the given display. +
    If none specified, use the display of the active space instead. +
    System Integrity Protection must be partially disabled.

*--destroy* ['<SPACE_SEL>']::
    Remove the given space. +
    If none specified, use the selected space instead. +
    System Integrity Protection must be partially disabled.

*--move* '<SPACE_SEL>'::
    Move position of the selected space to the position of the given space. +
    The selected space and given space must both belong to the same display. +
    System Integrity Protection must be partially disabled.

*--swap* '<SPACE_SEL>'::
    Swap the selected space with the given space. +
    If the selected space and given space belong to different displays, all the windows will swap. +
    If the selected space and given space belong to the same display, the actual spaces will swap. +
    System Integrity Protection must be partially disabled.

*--display* '<DISPLAY_SEL>'::
    Send the selected space to the given display. +
    System Integrity Protection must be partially disabled.

*--equalize* ['x-axis|y-axis']::
    Reset the split ratios on the selected space to the default value along the given axis. +
    If no axis is specified, use both.

*--balance* ['x-axis|y-axis']::
    Adjust the split ratios on the selected space so that all windows along the given axis occupy the same area. +
    If no axis is specified, use both.

*--mirror* 'x-axis|y-axis'::
    Flip the tree of the selected space along the given axis.

*--rotate* '90|180|270'::
    Rotate the tree of the selected space.

*--padding* 'abs|rel:<top>:<bottom>:<left>:<right>'::
    Padding added at the sides of the selected space.

*--gap* 'abs|rel:<gap>'::
    Size of the gap that separates windows on the selected space.

*--toggle* 'padding|gap|mission-control|show-desktop'::
    Toggle space setting on or off for the selected space.

*--layout* 'bsp|stack|float'::
    Set the layout of the selected space.

*--label* ['<LABEL>']::
    Label the selected space, allowing that label to be used as an alias in commands that take a `SPACE_SEL` parameter. +
    If the command is called without an argument it will try to remove a previously assigned label.

Window
~~~~~~

General Syntax
^^^^^^^^^^^^^^

yabai -m window ['<WINDOW_SEL>'] '<COMMAND>'

COMMAND
^^^^^^^

*--focus* ['<WINDOW_SEL>']::
    Focus the given window. +
    If none specified, focus the selected window instead.

*--close* ['<WINDOW_SEL>']::
    Close the given window. +
    If none specified, close the selected window instead. +
    Only works on windows that provide a close button in its titlebar.

*--minimize* ['<WINDOW_SEL>']::
    Minimize the given window. +
    If none specified, minimize the selected window instead. +
    Only works on windows that provide a minimize button in its titlebar.

*--deminimize* '<WINDOW_SEL>'::
    Restore the given window if it is minimized. +
    The window will only get focus if the owning application has focus. +
    Note that you can also '--focus' a minimized window to restore it as the focused window.

*--display* '<DISPLAY_SEL>'::
    Send the selected window to the given display.

*--space* '<SPACE_SEL>'::
    Send the selected window to the given space.

*--swap* '<WINDOW_SEL>'::
    Swap position of the selected window and the given window.

*--warp* '<WINDOW_SEL>'::
    Re-insert the selected window, splitting the given window.

*--stack* '<WINDOW_SEL>'::
    Stack the given window on top of the selected window. +
    Any kind of warp operation performed on a stacked window will unstack it.

*--insert* '<DIR_SEL>|stack'::
    Set the splitting mode of the selected window. +
    If the current splitting mode matches the selected mode, the action will be undone.

*--grid* '<rows>:<cols>:<start-x>:<start-y>:<width>:<height>'::
    Set the frame of the selected window based on a self-defined grid.

*--move* 'abs|rel:<dx>:<dy>'::
    If type is 'rel' the selected window is moved by 'dx' pixels horizontally and 'dy' pixels vertically. +
    If type is 'abs' 'dx' and 'dy' will become the new position.

*--resize* 'top|left|bottom|right|top_left|top_right|bottom_right|bottom_left|abs:<dx>:<dy>'::
    Resize the selected window by moving the given handle 'dx' pixels horizontally and 'dy' pixels vertically. +
    If handle is 'abs' the new size will be 'dx' width and 'dy' height and cannot be used on managed windows.

*--ratio* 'rel|abs:<dr>'::
    If type is 'rel' the split ratio of the selected window is changed by 'dr', otherwise 'dr' will become the new split ratio. +
    A positive/negative delta will increase/decrease the size of the left-child.

*--toggle* 'float|sticky|pip|shadow|split|zoom-parent|zoom-fullscreen|native-fullscreen|expose|<LABEL>'::
    Toggle the given property of the selected window. +
    The following properties require System Integrity Protection to be partially disabled: sticky, pip, shadow, LABEL (scratchpad identifier) .

*--sub-layer* '<LAYER>'::
    Set the stacking sub-layer of the selected window. +
    The window will no longer be eligible for automatic change in sub-layer when managed/unmanaged. +
    Specify the value 'auto' to reset back to normal and make it become automatically managed. +
    System Integrity Protection must be partially disabled.

*--opacity* '<FLOAT_SEL>'::
    Set the opacity of the selected window. +
    The window will no longer be eligible for automatic change in opacity upon focus change. +
    Specify the value '0.0' to reset back to full opacity and make it become automatically managed. +
    System Integrity Protection must be partially disabled.

*--raise* ['<WINDOW_SEL>']::
    Orders the selected window above the given window, or to the front within its layer. +
    System Integrity Protection must be partially disabled.

*--lower* ['<WINDOW_SEL>']::
    Orders the selected window below the given window, or to the back within its layer. +
    System Integrity Protection must be partially disabled.

*--scratchpad* ['<LABEL>|recover']::
    Unique identifier used to identify a window scratchpad. +
    An identifier may only be assigned to a single window at any given time. +
    A scratchpad window will automatically be treated as a (manage=off) floating window. +
    If the scratchpad is already taken by another window, this assignment will fail. +
    If the scratchpad is re-assigned, the previous identifier will become available. +
    If no value is given, the window will seize to be a scratchpad window. +
    The special value 'recover' can be used to forcefully bring all scratchpad windows to the front. +
    This can be useful if windows become inaccessible due to a restart or crash. +
    System Integrity Protection must be partially disabled.

Query
~~~~~~

General Syntax
^^^^^^^^^^^^^^

yabai -m query '<COMMAND>' ['<PROPERTIES>'] ['<ARGUMENT>']

COMMAND
^^^^^^^

*--displays*::
    Retrieve information about displays.

*--spaces*::
    Retrieve information about spaces.

*--windows*::
    Retrieve information about windows.

ARGUMENT
^^^^^^^^

*--display* ['<DISPLAY_SEL>']::
    Constrain matches to the selected display.

*--space* ['<SPACE_SEL>']::
    Constrain matches to the selected space.

*--window* ['<WINDOW_SEL>']::
    Constrain matches to the selected window.

PROPERTIES
^^^^^^^^^^

A comma-separated string containing the name of fields to include in the output. +
The name of the provided fields must be present in the dataformat of the corresponding entity.

DATAFORMAT
^^^^^^^^^^

DISPLAY
[subs=+macros]
----
{
    "id": number,
    "uuid": string,
    "index": number,
    "label": string,
    "frame": object {
        "x": number,
        "y": number,
        "w": number,
        "h": number
    },
    "spaces": array of number,
    "has-focus": bool
}
----

SPACE
[subs=+macros]
----
{
    "id": number,
    "uuid": string,
    "index": number,
    "label": string,
    "type": string,
    "display": number,
    "windows": array of number,
    "first-window": number,
    "last-window": number,
    "has-focus": bool,
    "is-visible": bool,
    "is-native-fullscreen": bool
}
----

WINDOW
[subs=+macros]
----
{
    "id": number,
    "pid": number,
    "app": string,
    "title": string,
    "scratchpad": string,
    "frame": object {
        "x": number,
        "y": number,
        "w": number,
        "h": number,
    },
    "role": string,
    "subrole": string,
    "root-window": bool,
    "display": number,
    "space": number,
    "level": number,
    "sub-level": number,
    "layer": string,
    "sub-layer": string,
    "opacity": number,
    "split-type": string,
    "split-child": string,
    "stack-index": number,
    "can-move": bool,
    "can-resize": bool,
    "has-focus": bool,
    "has-shadow": bool,
    "has-parent-zoom": bool,
    "has-fullscreen-zoom": bool,
    "has-ax-reference": bool,
    "is-native-fullscreen": bool,
    "is-visible": bool,
    "is-minimized": bool,
    "is-hidden": bool,
    "is-floating": bool,
    "is-sticky": bool,
    "is-grabbed": bool
}
----

Some window properties are only accessible when yabai has a valid AX-reference for that window. +
This AX-reference can only be retrieved when the space that the window is visible on, is active. +
If windows are already opened on inactive spaces when yabai is launched, yabai can detect those +
windows and retrieve a limited amount of information about them. In addition, yabai window commands +
will NOT WORK for these windows. These windows can be identified by looking at the `has-ax-reference` +
property. Once the space that the window belongs to becomes active, yabai will automatically create +
an AX-reference. The queries will from that point forwards contain complete information, and the window +
can be used with yabai window commands.

The properties that contain incorrect information for windows with `has-ax-reference: false` are as follows:
----
{
    "role": string,
    "subrole": string,
    "can-move": bool,
    "can-resize": bool
}
----

Rule
~~~~

All rules that match the given filter will be applied in the order they were registered. +
If multiple rules specify a value for the same property, the latter rule will end up overriding that value. +
If the display and space properties are both set, the space property will take precedence. +
The following properties require System Integrity Protection to be partially disabled: sticky, sub-layer, opacity, scratchpad.

General Syntax
^^^^^^^^^^^^^^

yabai -m rule '<COMMAND>'

COMMAND
^^^^^^^

*--add [--one-shot] ['<ARGUMENT>']*::
    Add a new rule. Rules apply to windows that spawn after said rule has been added. +
    If '--one-shot' is present it will apply once and automatically remove itself.

*--apply ['<RULE_SEL>' | '<ARGUMENT>']*::
    Apply a rule to currently known windows. +
    If no argument is given, all existing rules will apply. +
    If an index or label is given, that particular rule will apply. +
    Arguments can also be provided directly, just like in the *--add* command. +
    Existing `--one-shot` rules that have yet to apply will be ignored by this command.

*--remove '<RULE_SEL>'*::
    Remove an existing rule with the given index or label.

*--list*::
    Output list of registered rules.

ARGUMENT
^^^^^^^^

*label='<LABEL>'*::
    Label used to identify the rule with a unique name

*app[!]='<REGEX>'*::
    Name of application. If '!' is present, invert the match.

*title[!]='<REGEX>'*::
    Title of window. If '!' is present, invert the match.

*role[!]='<REGEX>'*::
    https://developer.apple.com/documentation/applicationservices/carbon_accessibility/roles?language=objc[Accessibility role of window]. If '!' is present, invert the match.

*subrole[!]='<REGEX>'*::
    https://developer.apple.com/documentation/applicationservices/carbon_accessibility/subroles?language=objc[Accessibility subrole of window]. If '!' is present, invert the match.

*display='[^]<DISPLAY_SEL>'*::
    Send window to display. If '^' is present, follow focus.

*space='[^]<SPACE_SEL>'*::
    Send window to space. If '^' is present, follow focus.

*manage='<BOOL_SEL>'*::
    Window should be managed (tile vs float). +
    Most windows will be managed automatically, so this should mainly be used to make a window float.

*sticky='<BOOL_SEL>'*::
    Window appears on all spaces. +
    System Integrity Protection must be partially disabled.

*mouse_follows_focus='<BOOL_SEL>'*::
    When focusing the window, put the mouse at its center. Overrides the global *mouse_follows_focus* setting.

*sub-layer='<LAYER>'*::
    Window is ordered within the given stacking sub-layer. +
    The window will no longer be eligible for automatic change in sub-layer when managed/unmanaged. +
    Specify the value 'auto' to reset back to normal and make it become automatically managed. +
    System Integrity Protection must be partially disabled.

*opacity='<FLOAT_SEL>'*::
    Set window opacity. +
    The window will no longer be eligible for automatic change in opacity upon focus change. +
    Specify the value '0.0' to reset back to full opacity and make it become automatically managed. +
    System Integrity Protection must be partially disabled.

*native-fullscreen='<BOOL_SEL>'*::
    Window should enter native macOS fullscreen mode.

*grid='<rows>:<cols>:<start-x>:<start-y>:<width>:<height>'*::
    Set window frame based on a self-defined grid.

*scratchpad='<LABEL>'*::
    Unique identifier used to identify a window scratchpad. +
    An identifier may only be assigned to a single window at any given time. +
    A scratchpad window will automatically be treated as a (manage=off) floating window. +
    If this rule matches multiple windows, only the first window that matched will be assigned this scratchpad identifier. +
    System Integrity Protection must be partially disabled.

DATAFORMAT
^^^^^^^^^^

[subs=+macros]
----
{
    "index": number,
    "label": string,
    "app": string,
    "title": string,
    "role": string,
    "subrole": string,
    "display": number,
    "space": number,
    "follow_space": bool,
    "opacity": number,
    "manage": bool (optional),
    "sticky": bool (optional),
    "mouse_follows_focus": bool (optional),
    "sub-layer": string,
    "native-fullscreen": bool (optional),
    "grid": string,
    "scratchpad": string,
    "one-shot": bool,
    "flags": string
}
----

Signal
~~~~~~

A signal is a simple way for the user to react to some event that has been processed. +
Arguments are passed through environment variables.

General Syntax
^^^^^^^^^^^^^^

yabai -m signal '<COMMAND>'

COMMAND
^^^^^^^

*--add event='<EVENT>' action='<ACTION>' [label='<LABEL>'] [app[!]='<REGEX>'] [title[!]='<REGEX>'] [active='yes|no']*::
    Add an optionally labelled signal to execute an action after processing an event of the given type. +
    Some signals can be specified to trigger based on the application name and/or window title, and its active/focused state.

*--remove '<SIGNAL_SEL>'*::
    Remove an existing signal with the given index or label.

*--list*::
    Output list of registered signals.

EVENT
^^^^^

*application_launched*::
    Triggered when a new application is launched. +
    Eligible for *app* filter. +
    Passes one argument: $YABAI_PROCESS_ID

*application_terminated*::
    Triggered when an application is terminated. +
    Eligible for *app* and *active* filter. +
    Passes one argument: $YABAI_PROCESS_ID

*application_front_switched*::
    Triggered when the front-most application changes. +
    Passes two arguments: $YABAI_PROCESS_ID, $YABAI_RECENT_PROCESS_ID

*application_activated*::
    Triggered when an application is activated. +
    Eligible for *app* filter. +
    Passes one argument: $YABAI_PROCESS_ID

*application_deactivated*::
    Triggered when an application is deactivated. +
    Eligible for *app* filter. +
    Passes one argument: $YABAI_PROCESS_ID

*application_visible*::
    Triggered when an application is unhidden. +
    Eligible for *app* filter. +
    Passes one argument: $YABAI_PROCESS_ID

*application_hidden*::
    Triggered when an application is hidden. +
    Eligible for *app* and *active* filter. +
    Passes one argument: $YABAI_PROCESS_ID

*window_created*::
    Triggered when a window is created. +
    Also applies to windows that are implicitly created at application launch. +
    Eligible for *app* and *title* filter. +
    Passes one argument: $YABAI_WINDOW_ID

*window_destroyed*::
    Triggered when a window is destroyed. +
    Also applies to windows that are implicitly destroyed at application exit. +
    Eligible for *app* and *active* filter. +
    Passes one argument: $YABAI_WINDOW_ID

*window_focused*::
    Triggered when a window becomes the key-window. +
    Eligible for *app* and *title* filter. +
    Passes one argument: $YABAI_WINDOW_ID

*window_moved*::
    Triggered when a window changes position. +
    Eligible for *app*, *title* and *active* filter. +
    Passes one argument: $YABAI_WINDOW_ID

*window_resized*::
    Triggered when a window changes dimensions. +
    Eligible for *app*, *title* and *active* filter. +
    Passes one argument: $YABAI_WINDOW_ID

*window_minimized*::
    Triggered when a window has been minimized. +
    Eligible for *app*, *title* and *active* filter. +
    Passes one argument: $YABAI_WINDOW_ID

*window_deminimized*::
    Triggered when a window has been deminimized. +
    Eligible for *app* and *title* filter. +
    Passes one argument: $YABAI_WINDOW_ID

*window_title_changed*::
    Triggered when a window changes its title. +
    Eligible for *app*, *title* and *active* filter. +
    Passes one argument: $YABAI_WINDOW_ID

*space_created*::
    Triggered when a space is created. +
    Passes two arguments: $YABAI_SPACE_ID, $YABAI_SPACE_INDEX

*space_destroyed*::
    Triggered when a space is destroyed. +
    Passes one argument: $YABAI_SPACE_ID

*space_changed*::
    Triggered when the active space has changed. +
    Passes four arguments: $YABAI_SPACE_ID, $YABAI_SPACE_INDEX, $YABAI_RECENT_SPACE_ID, $YABAI_RECENT_SPACE_INDEX

*display_added*::
    Triggered when a new display has been added. +
    Passes two arguments: $YABAI_DISPLAY_ID, $YABAI_DISPLAY_INDEX

*display_removed*::
    Triggered when a display has been removed. +
    Passes one argument: $YABAI_DISPLAY_ID

*display_moved*::
    Triggered when a change has been made to display arrangement. +
    Passes two arguments: $YABAI_DISPLAY_ID, $YABAI_DISPLAY_INDEX

*display_resized*::
    Triggered when a display has changed resolution. +
    Passes two arguments: $YABAI_DISPLAY_ID, $YABAI_DISPLAY_INDEX

*display_changed*::
    Triggered when the active display has changed. +
    Passes four arguments: $YABAI_DISPLAY_ID, $YABAI_DISPLAY_INDEX, $YABAI_RECENT_DISPLAY_ID, $YABAI_RECENT_DISPLAY_INDEX

*mission_control_enter*::
    Triggered when mission-control activates. +
    Passes one argument: $YABAI_MISSION_CONTROL_MODE

*mission_control_exit*::
    Triggered when mission-control deactivates. +
    Passes one argument: $YABAI_MISSION_CONTROL_MODE

*dock_did_change_pref*::
    Triggered when the macOS Dock preferences changes.

*dock_did_restart*::
    Triggered when Dock.app restarts.

*menu_bar_hidden_changed*::
    Triggered when the macOS menubar 'autohide' setting changes.

*system_woke*::
    Triggered when macOS wakes from sleep.

ACTION
^^^^^^

Arbitrary command executed through */usr/bin/env sh -c*

DATAFORMAT
^^^^^^^^^^

[subs=+macros]
----
{
    "index": number,
    "label": string,
    "app": string,
    "title": string,
    "active": bool (optional),
    "event": string,
    "action": string
}
----

Exit Codes
----------

If *yabai* can't handle a message, it will return a non-zero exit code.

Author
------

Åsmund Vikane <aasvi93 at gmail.com>


# 个人配置
以下是我的个人 yabai 配置文件个人 yabairc 配置文件的内容：

```shell
#!/usr/bin/env sh

# 如果没有关闭 Mac 的 SIP，那么在 BigSur 及以上的系统中，更改配置文件后，需要手动加载过配置文件
#  - https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)
# 如果已经关闭 Mac 的 SIP，那么通过下面命令就可以让 yabai 的配置文件热更新了
# 也可以在该配置文件中增加这句，这样每次重启系统时不用自己输入
yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
sudo yabai --load-sa

# ------------------------------------------------------ #
# -------------------Variables-------------------------- #
# ------------------------------------------------------ #

# 当前配置文件的路径
scripts_path="${HOME}/.config/yabai/scripts"

# 获取当前桌面数量
space_count=$(yabai -m query --spaces | jq '. | length')

# 获取当前桌面模式
get_display_mode() {
    # 获取显示器数量
    display_info=$(yabai -m query --displays)
    display_count=$(yabai -m query --displays | jq -r 'length')

    if [ "$display_count" -eq 1 ]; then
        echo 'mac'
        return
    fi

    # 如果有两个显示屏，并且其中一个是 1080P 的竖屏，那么是公司的模式
    if [ "$display_count" -eq 2 ]; then
        for ((i=0; i<$display_count; i++)); do
            frame_w=$(yabai -m query --displays | jq -r ".[$i].frame.w")
            frame_h=$(yabai -m query --displays | jq -r ".[$i].frame.h")

            if [ "$frame_w" = "1080.0000" ] && [ "$frame_h" = "1920.0000" ]; then
                echo 'company'
                return
            fi
        done
    fi

    echo 'other'
}

display_mode=$(get_display_mode)

# ------------------------------------------------------ #
# -------------------Global Settings-------------------- #
# ------------------------------------------------------ #

# 在多显示器情况下，新建的窗口默认在**哪个显示器**出现
# - default: 在创建窗口的显示器出现（mac 的默认行为）
# - focused: 在当前聚焦的显示器出现
# - cursor: 在鼠标指针所在的显示器出现
yabai -m config window_origin_display default

# 当前屏幕下，新窗口的出现在**屏幕的哪个位置**
# - first_child: （父节点模式）如果当前是 vertical split，则出现在*左侧*；如果是 horizontal split，则出现在*上方*
# - second_child: （子节点模式）如果当前是 vertical split，则出现在*右侧*；如果是 horizontal split，则出现在*下方*
yabai -m config window_placement second_child

# 窗口阴影值
# - on: 总是展示
# - off: 总是关闭
# - float: 只有浮动窗口展示
yabai -m config window_shadow on

# 窗口不透明
# - on: 总是展示
# - off: 总是关闭
yabai -m config window_opacity on
# *激活*窗口的不透明度（仅当 window_opacity on 时才有效）
yabai -m config active_window_opacity 1.0
# *普通*窗口不透明度（仅当 window_opacity on 时才有效）
yabai -m config normal_window_opacity 0.90
# 激活窗口和普通窗口切换时，*不透明度的过渡时间*（仅当 window_opacity on 时才有效）
yabai -m config window_opacity_duration 0.0

yabai -m config insert_feedback_color 0xffd75f5f

# 动画
yabai -m config window_animation_duration 0.1

# 所有窗口都使用相同比例的空间
# - on: 总是开启
# - off: 总是关闭
yabai -m config auto_balance off

# 分屏后*旧:新*窗口的比例（仅当 auto_balance off 时有效）
yabai -m config split_ratio 0.50

# 配合 sketchyBar 给底部让出空间
yabai -m config external_bar all:40:0

# ==================================================== #
# ==================== 鼠标相关 ======================== #
# ==================================================== #

# 窗口切换时，鼠标自动移动到当前使用窗口的中心
# - on: 总是开启
# - off: 总是关闭
yabai -m config mouse_follows_focus off

# 是否自动聚焦到鼠标所在窗口
# - off: 总是关闭
# - autoraise:
# - autofocus:
yabai -m config focus_follows_mouse off

# 按住对应修饰键时，yabai 不自动调整平铺（默认情况下调整窗口大小时，yabai 会自适应调整平铺）；配置时通常会关闭 focus_follows_mouse
# - cmd
# - alt
# - shift
# - ctrl
# - fn
yabai -m config mouse_modifier shift

# modifier + 左键的行为
# - move
# - resize
yabai -m config mouse_action1 move

# modifier + 右键的行为
# - move
# - resize
yabai -m config mouse_action2 resize

# 在平铺管理情况下，拖动一个窗口到另一窗口位置时的操作
# - swap: 交换窗口位置
# - stack: 堆叠在旧窗口上
yabai -m config mouse_drop_action swap

# ----------------------------------------------------------- #
# ------------General Space Settings------------------------- #
# ----------------------------------------------------------- #

# yabai 布局模式
# - bsp: 平铺
# - stack: 堆叠
# - float: 浮动
yabai -m config layout bsp

# 窗口和屏幕边缘的距离（优先级低于 gap）
yabai -m config top_padding 10
yabai -m config bottom_padding 10
yabai -m config left_padding 10
yabai -m config right_padding 10

# 窗口与窗口之间的间距（优先级高于 padding）
yabai -m config window_gap 05

# ------------------------------------------------------------ #
# -----------------Specific Apps------------------------------ #
# ------------------------------------------------------------ #

# manage: 是否使用 yabai 管理
# - on
# - off
# sticky: 是否总是置顶
# - on
# - off
# sub-layer:
# - below
# - normal
# - above

# 浮动窗口
# manage_off_apps='^(系统偏好设置|System Preferences|预览|Preview|universalAccessAuthWarn|System Information|活动监视器|Activity Monitor)$'
# yabai -m rule --add manage=off app="${manage_off_apps}"

manage_off_apps=(
    "^(系统设置|System Settings)$"
    "^(系统偏好设置|System Preferences)$"
    "^System Information$"
    "^(活动监视器|Activity Monitor)$"
    "^Finder$"
    "^Alfred Preferences$"
    "^飞书$"
    "^Feishu$"
    "^Lark$"
    "^Lark Meetings$"
    "^Seal$"
    "^Karabiner-Elements$"
    "^Karabiner-EventViewer$"
    "^Things$"
    "^Bartender 4$"
    "^微信$"
    "^Clash Verge$"
    "^同程管家$"
    "^NotchDrop$"
)

for app in "${manage_off_apps[@]}"; do
    yabai -m rule --add app="${app}" manage=off sticky=off
done

yabai -m rule --add app="^(universalAccessAuthWarn)$" sticky=on
yabai -m rule --add app="^(预览|Preview)$" sticky=on

# Arc 浏览器的设置窗口悬浮
arc_browser_settins_titles=(
    "^LadenxxxxD$"
    "^General$"
    "^Profiles$"
    "^Max$"
    "^Links$"
    "^Shortcuts$"
)

for title in "${arc_browser_settins_titles[@]}"; do
    yabai -m rule --add app="^Arc$" title="${title}" manage=off 
done

# 非企业微信本体 统统悬浮
yabai -m rule --add app="^企业微信" title!="企业微信" manage=off 

# --------------------------------------------------------- #
# ---------------------Space Layouts----------------------- #
# --------------------------------------------------------- #
yabai -m space 1 --label main
yabai -m space 2 --label code
yabai -m space 3 --label msg
yabai -m space 4 --label term

if [ "$display_mode" = "company" ]; then
    echo "company mode"
    yabai -m space 2 --label code2
    yabai -m space 4 --label code
    yabai -m space 5 --label term
else
    # 如果桌面数量不是 5，恢复到默认配置
    yabai -m space 1 --label main
    yabai -m space 2 --label code
    yabai -m space 3 --label msg
    yabai -m space 4 --label term
fi


# sapce 1
yabai -m rule --add space=^main app="^(Arc)$"

# sapce 2
yabai -m rule --add space=^code app="^(Code)$" manage=on
yabai -m signal --add event=window_created app="^Code$" action="sleep 0.5 && sh $scripts_path/stack_all_vscode.s"

# sapce 3
space3_apps='^(企业微信|预览|QSpace Pro|Finder)$'
yabai -m rule --add space=^msg app="${space3_apps}"

# sapce 4
space4_apps='^(WezTerm|iTerms)$'
yabai -m rule --add space=^term app="${space4_apps}"

echo "${display_mode}"
echo "yabai configuration loaded.."
```
