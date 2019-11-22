<div align="center">
    <h1>Glorious Dotfiles</h1>
    <p>There's no place like <b><code>~</code></b> !</p>
    <p>Fork it. Steal it. I don't care. <b><code>Just don't make it ugly</code></b> .</p>
</div>

## Details
+ **OS**: I use Arch, btw
+ **WM**: AwesomeWM
+ **Terminal Emulators**: kitty, urxvt-pixbuf, xterm
+ **Compositor**: compton-tryone-git
+ **File Manager**: nemo
+ **Launcher**: rofi-git
+ **Editor**: neovim, atom
+ **Browser**: firefox
+ **Music Player**: ncmpcpp, mpd, mpc
+ **Lock Screen**: [mantablockscreen](https://github.com/reorr/mantablockscreen)
+ **Display Manager**: sddm with [sugar-candy](https://www.opencode.net/marianarlt/sddm-sugar-candy)

# An Awesome Setup

## FEATURES!
+ **Notification Center**
+ **Brightness and Volume OSDs**
+ **Web-Search Rofi**
+ **Deepin-Like Application Dashboard**
+ **Battery/Charger Notifications Module**
+ **Dynamic Wallpaper Module**
  - Wallpaper changes based on time. You can modify it here `$HOME/.config/awesome/module/wallchange.lua`
  - Wallpapers are in `$HOME/.config/awesome/theme/wallpapers`

## My Current Theme
| Floppy | Preview |
| --- | --- |
| Desktop | ![Screenshot](https://github.com/ilovecookieee/Glorious-Dotfiles/blob/master/screenshots/floppy/desktop.png) |
| Dirty | ![Screenshot](https://github.com/ilovecookieee/Glorious-Dotfiles/blob/master/screenshots/floppy/dirty.png)   |
| Floating | ![Screenshot](https://github.com/ilovecookieee/Glorious-Dotfiles/blob/master/screenshots/floppy/dirty2.png)   |
| Dashboard | ![Screenshot](https://github.com/ilovecookieee/Glorious-Dotfiles/blob/master/screenshots/floppy/dashboard.png) |
| Notification Center | ![Screenshot](https://github.com/ilovecookieee/Glorious-Dotfiles/blob/master/screenshots/floppy/notif-center.png) |
| Widgets and a Calulator | ![Screenshot](https://github.com/ilovecookieee/Glorious-Dotfiles/blob/master/screenshots/floppy/widgets-center.png) |
| App Dashboard | ![Screenshot](https://github.com/ilovecookieee/Glorious-Dotfiles/blob/master/screenshots/floppy/application-dashboard.png) |
| Lockscreen | ![Screenshot](https://github.com/ilovecookieee/Glorious-Dotfiles/blob/master/screenshots/floppy/lockscreen.png) |
| Greeter | ![Screenshot](https://github.com/ilovecookieee/Glorious-Dotfiles/blob/master/screenshots/floppy/greeter.png) |

+ **Rounds and Lines setups are under revisions**
# Other themes preview
| Rounded | Preview |
| --- | --- |
| Desktop | ![Screenshot](https://github.com/ilovecookieee/Glorious-Dotfiles/blob/master/screenshots/rounded/desktop.png) |
| Dirty | ![Screenshot](https://github.com/ilovecookieee/Glorious-Dotfiles/blob/master/screenshots/rounded/dirty.png)   |
| Application Dashboard | ![Screenshot](https://github.com/ilovecookieee/Glorious-Dotfiles/blob/master/screenshots/rounded/appdashboard.png) |


| Lines | Preview |
| --- | --- |
| Desktop | ![Screenshot](https://github.com/ilovecookieee/Glorious-Dotfiles/blob/master/screenshots/lines/desktop.png) |
| Dirty | ![Screenshot](https://github.com/ilovecookieee/Glorious-Dotfiles/blob/master/screenshots/lines/dirty.png)   |
| Application Dashboard | ![Screenshot](https://github.com/ilovecookieee/Glorious-Dotfiles/blob/master/screenshots/lines/appdashboard.png) |


## Dependencies
Here is a complete list of dependencies needed for making these AwesomeWM setup to work.
If you notice that something is missing, please open an issue so I can add the dependency to this table.

| Dependency | Description | Why/Where is it needed? |
| --- | --- | --- |
| `awesome-git` | Window manager | yeah awesome |
| `rofi-git` | Window switcher, application launcher and dmenu replacement | Application launcher |
| `Compton-tryone` | A compositor for X11 | compositor with kawase-blur |
| `blueman` | Manages bluetooth | For bluetooth widgets |
| `xfce4-power-manager` | Manages battery/power settings | Power Settings |
| `acpi`,`acpid`,`acpi_call` | Show battery status and other ACPI info | Charger notifications |
| `pulseaudio`, `libpulse` | Sound system | Volume widgets and keybinds |
| `redshift` | Controls screen temperature | Night mode command |
| `mpd` | Server-side application for playing music | Music widgets |
| `mpc` | Minimalist command line interface to MPD | Music widgets |
| `maim` | Takes screenshots (improved `scrot`) | Screenshot keybinds |
| `xclip` | Command line interface to the X11 clipboard | Useful in taking screenshots |
| `feh` | Image viewer and wallpaper setter | Screenshot previews, wallpapers |
| `xorg-xwininfo` | Window information utility for X | it just works |
| `python3`| an interpreted, interactive, object-oriented programming language | Web-search Backend |
| `xdg_menu` | Generates a list of installed applications | Useful for generating app list |
| `imagemagick` | An image viewing/manipulation program | Album cover extractor |
| `jq` | Command-line JSON processor | Formatting |

##### Monospace
+ **[Iosevka Custom](https://github.com/elenapan/dotfiles/)**

##### Sans
+ **Google Sans**
+ **San Francisco Display**

#### Installation
+ My setup is using the dependencies above, well if you don't want bloat you can install what you want. But these are the recommended dependencies:
  - awesome-git master branch (window manager framework)
  - rofi git branch (application launcher)
  - blueman (bluetooth widgets)
  - xfce4-power-manager (power widget)
  - acpi, acpid, acpi_call, upower (battery notifications)
  - pulseaudio, alsa-utils (volume/audio keybinds)
  - mpd, mpc (music widget)
  - maim, xclip (screenshot tool)
  - xorg-xwininfo, xprop (custom titlebar)
  - python3 (web-search rofi)
  - xdg-menu (generates app list)
  - imagemagick (extract album cover, music widget)
  - jq (Formatting)
+ Copy the selected theme from `Glorious-Dotfiles/config/awesome` to `$HOME/.config/`
+ Rename it to `awesome`
+ Reload Awesome using `Super + shift + r`


# File Structure
This setup is split in multiple parts:
+ `rc.lua` the core of configuration. You can enable and disable the modules here and load all your configurations.
+ The `layout` directory contains the panel configurations. Change panel settings here or load/unload widgets.
+ In `configuration` directory you can find all the configs about the key bindings, client rules, tags, starting apps and etc.
+ The `module` consists of many files that are usually inside the `rc.lua` like notifications, app menus, etc. You can load them in the `rc.lua`.
+ The `themes` folder contains themes and colors of the setup.
+ The `widgets` contains all the widgets(of course). These are used in the panels and dashboard. It contains the wifi, bluetooth, battery widget and many more.
+ `binaries` contains bash scripts. I recently added this because running multiple bash commands inside lua is clunky sometimes. So, I decided to put them in a folder.

# Where to edit this and that?
+ Colorschemes?
  - `awesome/theme`
  - Just play with `default-theme.lua` and `SETUPNAME-theme\init.lua`
+ Panels and bars?
  - `awesome/layout`
+ Client behaviour?
  - `awesome/module/decorate-client.lua`
  - `awesome/module/titlebar-decorate-client.lua` - for titlebar behaviour. Kinda messy right now
+ Start-up Applications?
  - `awesome/configuration/apps.lua`
+ Keybindings?
  - `awesome/configuration/keys/`
+ Client rules?
  - `awesome/configuration/client/keys.lua`
+ Compositor?
  -  `awesome/configuration/compton.conf`
+ Rofi?
  - `awesome/configuration/rofi/`
+ Tags?
  - `awesome/configuration/tags/`
+ Icons?
  - `awesome/theme/icons/`
+ Wallpapers?
  - `awesome/theme/wallpapers/`
+ Modules?
  - `awesome/modules`
+ Binaries?
  - `awesome/binaries`
+ Hotel?
  - `Trivago`


# NOTE
+ This setup will not mostly work out of the box because:
  - It is only tested and configured on a 1366x768 resolution (Lenovo x230)
  - Some dependencies are not currently installed
  - Not tested in a multi-monitor setup (please send me an extra monitor so I can test it lol)
+ Check keybindings using `Super +  F1`

# ABOUT WIDGETS AND MODULES
+ You need a song with hard-coded album cover for music widget to display its cover.
+ You can disable the dialog backdrop effect in `awesome/configuration/client/rules.lua`. Just search for `dialog` and set `drawBackdrop` to false in the properties. You can also just unload the module in `rc.lua`.
+ Generating an application menu
  - Install `xdg-menu`. In Arch, it is called `archlinux-xdg-menu` It generates a list of applications installed.
  - Execute `xdg_menu --format awesome --root-menu /etc/xdg/menus/arch-applications.menu >~/.config/awesome/archmenu.lua` to generate a list to archmenu.lua
  - You can just substitute its values to `awesome/module/menu.lua`
+ You will probably have an error or the widget will not update because of `weather-update.lua`. It is because I did not include an openweathermap API keys and etc.

**So, you need to configure and tweak it by yourself to make it work properly. You can also just open a issue [here](https://github.com/ilovecookieee/Glorious-Dotfiles/issues/new).**


# Got a problem? Just open an issue [here](https://github.com/ilovecookieee/Glorious-Dotfiles/issues/new).
#### Suggestion? If you have any suggestion on how to improve this setup, please open an issue [here](https://github.com/ilovecookieee/Glorious-Dotfiles/issues/new).


**Special thanks**
+ **PapyElGringo** for the awesome [material-awesome](https://github.com/PapyElGringo/material-awesome)
+ **pdonadeo** for the [rofi-web-search.py](https://github.com/pdonadeo/rofi-web-search)
+ **[elenapan](https://github.com/elenapan/dotfiles)**
+ **[addyfe](https://github.com/addy-dclxvi/almighty-dotfiles)**
