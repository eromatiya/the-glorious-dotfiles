<div align="center">
    <h3><img src="https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/banner.png" align="center" height="200px"></h3>
    <p align="center">a glorified dotfiles</p>
</div>


## Table of Contents

<img src="https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/sidebanner.png" alt="sidebanner_img" align="right" width="300px">

- [Details](#starring)
- [Features](#features)
- [Screenshots](#screenshots)
- [Dependencies](#dependencies)
    - [Required Dependencies](#required-dependencies)
    - [Optional Dependencies](#optional-dependencies)
    - [Recommended Dependencies](#recommended-packages)
    - [Recommended Fonts](#recommended-fonts)
- [Getting Started](#getting-started)
- [How to's](#how-to's)
	- [Fix the errors on startup](#fix-the-errors-on-start-up)
	- [Fix the font](#fix-the-font)
	- [Fix rofi application menu size](#fix-rofi-application-menu-size)
	- [Use Powerlevel10k prompt](#use-the-powerlevel10k-prompt)
- [Keybindings](#keybindings)
- [File Structure](#basic-file-structure)
- [Configuration](#configuration-and-preferences)
- [About Widgets](#about-widgets)
	- [Weather Widget](#weather-widget)
	- [Email Widget](#email-widget)
	- [Calculator Widget](#calculator-widget)
	- [Trash Widget](#trash-widget)
	- [Music Widget](#music-widget)
	- [Screen-recorder Widget](#screen-recorder-widget)
- [About Modules](#about-modules)
	- [Lockscreen Module](#lockscreen-module)
	- [Titlebar Module](#titlebar-module)
	- [Dynamic Wallpaper Module](#dynamic-wallpaper-module)
	- [Backdrop Module](#backdrop-module)
	- [Menu Module](#menu-module)
- [More](#more)
	- [Antialiasing](#anti-aliased-corners)
- [Testing the setup in VMs](#testing-the-setup-in-vms)
- [TODOs](#todos)
- [Having a problem?](#having-a-problem?)
- [Acknowledgement](#acknowledgement)



## Starring

- [`archlinux`](https://www.archlinux.org/download/) as distribution
- [`awesomewm`](https://awesomewm.org) as window manager
- [`kitty`](https://github.com/kovidgoyal/kitty) as terminal emulator
- [`tryone144's picom`](https://github.com/tryone144/compton/tree/feature/dual_kawase) as compositor
- [`rofi-git branch`](https://github.com/davatorium/rofi) as application launcher
- [`SF Pro Text`](https://developer.apple.com/fonts/) as the setup font
- [`trivago`](https://www.youtube.com/watch?v=dQw4w9WgXcQ) as hotel

## Extras

- [`tela`](https://github.com/vinceliuice/Tela-icon-theme) as icon theme
- [`vimix`](https://github.com/vinceliuice/Vimix-cursors) as cursor theme


## Features

+ Notification Center
+ Dynamic Wallpaper
+ Web Search
+ Application Dashboard
+ Brightness and Volume OSDs
+ Functional Trash Widget
+ Built-in Screen Recorder Widget
+ Lockscreen Module with Face Capture<sup>yep. this is overkill</sup>

I designed these setups to get rid of desktop environment and I'm loving it. 

## Screenshots


### Floppy

Floppy was meant to be a clone by design of the infamous [Flurry Desktop](https://www.reddit.com/r/unixporn/comments/apktsx/flurry_i_know_you_like_tiling_managers_and_i_want/). I named it Floppy because I thought it would flop when I first [posted](https://www.reddit.com/r/unixporn/comments/de0m3v/awesome_floppy/) it in r/unixporn.


| Busy |
| --- |
| ![Screenshot](https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/setups/floppy/dirty.png) |


| Application Menu |
| --- | 
| ![Screenshot](https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/setups/floppy/appmenu.png) |


| Lockscreen |
| --- |
| ![Screenshot](https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/setups/floppy/lockscreen.png) |


| Web Search | Screen Recorder | Today Panel |
| --- | --- | --- |
| ![Screenshot](https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/setups/floppy/websearch.png) | ![Screenshot](https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/setups/floppy/screenrec.png) | ![Screenshot](https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/setups/floppy/todaypanel.png) |


### GNawesOME

GNawesOME is a weird name. GNawesOME was meant to be a GNOME clone. Instead, it became a hybrid of macOS, iOS, GNOME, and Deepin. I regret nothing.

| Busy |
| --- |
| ![Screenshot](https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/setups/gnawesome/busy.png) |


| Dirty |
| --- |
| ![Screenshot](https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/setups/gnawesome/dirty.png) |


| Lockscreen |
| --- | 
| ![Screenshot](https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/setups/gnawesome/lockscreen.png) |


## Dependencies


### Required Dependencies

| Name | Description | Why/Where is it needed? |
| --- | --- | --- |
| [`awesome-git`](https://github.com/awesomeWM/awesome) |  Highly configurable framework window manager | isn't it obvious? |
| [`rofi-git`](https://github.com/davatorium/rofi) | Window switcher, application launcher and dmenu replacement | Application launcher |
| [`tryone144's picom`](https://github.com/tryone144/compton/tree/feature/dual_kawase) | A compositor for X11 | a compositor with kawase-blur |

### Optional Dependencies

Dependencies needed to achieve the setup's full potential. These are **optional**.

| Name | Description | Will be used by |
| --- | --- | --- |
| `xbacklight` | RandR-based backlight control application | Brightness widget and OSD |
| `alsa-utils` | An alternative implementation of Linux sound support | Volume widget and OSD |
| `acpi`,`acpid`,`acpi_call` | Show battery status and other ACPI info | Power/Battery Widgets. No need for this if you're not using a laptop |
| `mpd` | Server-side application for playing music | Music widget |
| `mpc` | Minimalist command line interface to MPD | Music widget |
| `maim` | Make image | Screenshot tool |
| `feh` | Image viewer and wallpaper setter | Screenshot previews, wallpapers |
| `xclip` | Command line interface to the X11 clipboard | Will be used in saving the screenshots to clipboard |
| `xprop` | Property displayer for X | Custom titlebars for each client |
| `imagemagick` | An image viewing/manipulation program | Music widget/Extracts hardcoded album cover from songs |
| `blueman` | Manages bluetooth | default launch application for bluetooth widget |
| `redshift` | Sets color temperature of display according to time of day | Blue light widget |
| `xfce4-power-manager` | Manages power | default launch application for battery widget |
| `upower` | upower - UPower command line tool | Battery widget |
| `xdg_menu` or `awesome-freedesktop` | Generates a list of installed applications | Menu Module/Useful for generating app list |
| `noto-fonts-emoji` | Google Noto emoji fonts | Emoji support for notification center |
| `jq` | Command-line JSON processor | Read weather |


### Recommended Packages

+ **Terminal emulators**: `kitty`, `urxvt`
+ **Web Browser**: `firefox` with custom css. You can find css themes here [r/FirefoxCSS](https://www.reddit.com/r/FirefoxCSS/) and here [r/unixporn](https://www.reddit.com/r/unixporn/).
+ **File Manager**: `nemo`
+ **Editors**: `vim`, `neovim`, or `sublime text` with some plugins
+ **Launchers**: `rofi`
+ **Music Player**: `ncmpcpp`, `mpd` and `mpc` combination or `lollypop`


### Recommended Fonts

+ Setup font
	- [`SF Pro Text`](https://developer.apple.com/fonts/)
+ Terminal font
	- [`MesloLGS NF`](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k)


### Getting started

1. Install the AwesomeWM **git master branch**. So if you're using the stable version or if you don't have AwesomeWM installed, install it now. Assuming you're using the elevated one - Arch Linux, you can install it by using an AUR helper. In this example let's use `yay`

	```bash
	$ yay -Syu awesome-git --removemake
	```

	Note that you can also build it yourself. Clone the [repository](https://github.com/awesomeWM/awesome) then follow the instructions there.

2. Install the dependecies. You don't have to install it all, it's your choice after all. The only required packages are [these](#required-dependencies). You can change all the applications used in the setup with your preference.

3. If you have a current AwesomeWM configuration, **make sure to create a backup** in case of emergency.

4. Clone my repo:

	```bash
	$ git clone --depth=1 https://github.com/manilarome/the-glorious-dotfiles/
	```

4. Just copy the `the-glorious-dotfiles/config/awesome/SETUPNAME` folder to your `$HOME/.config/`.

```bash
# Use the Floppy setup
$ cp -r the-glorious-dotfiles/config/awesome/floppy $HOME/.config/awesome

# Use the GNawesOME setup
$ cp -r the-glorious-dotfiles/config/awesome/gnawesome $HOME/.config/awesome
```

5. Reload AwesomeWM by pressing <kbd>Mod4 + Shift + r</kbd>.


## How to's

These are the common problems encountered.

### Fix the errors on start-up

Are you using the **git master branch** of AwesomeWM? No? Follow the instructions [here](#getting-started).


### Fix the font

> **THE FONT SIZE IS TOO BIG!**

The setup uses the `SF Pro Text` font of Apple. You need to install it or you can just use your preferred font family.

**Recommended font installation**:
1. If you're using Archlinux, you can find it in the AUR.

```bash
$ yay -S otf-san-francisco-pro
```

- Don't have Arch?<sup>aww you poor little soul</sup> 
	
	- You can download the `SF Pro` font from Apple's [website](https://developer.apple.com/fonts/). The file extension should be `.dmg`.
	
	- Go to your Downloads directory.
		
		```bash
		$ cd $HOME\Downloads
		```
		
	- Then execute the following commands. We will use `7z` to extract the fonts:
	
		```bash
		$ 7z x SF-Font-Pro.dmg
		$ 7z x SanFranciscoPro/San\ Francisco\ Pro.pkg
		$ 7z x "Payload~"
		```
	
	- The fonts are now extracted and it has a `.OTF` file extension. You can find it in the `Library/Fonts` folder in the same Downloads directory. Now, copy/move it to:
			
	User only: `$HOME/.local/share/fonts/apple/`  
	System wide: `/usr/share/fonts/apple/`

	Create the folder if it doesn't exist.

2. Reload <kbd>Mod4 + Control + r</kbd>. <kbd>Mod4</kbd> is the Windows key.

Optional: Set it as your system font using `lxappearance` or something . I think you can also change your system font by editing some of your gtk dotfiles. You can also follow the instructions [here](https://jichu4n.com/posts/how-to-set-default-fonts-and-font-aliases-on-linux/) to make your font rendering better.

### Fix rofi application menu size

The rofi is configured to work on a `1366x768` resolution laptop so it will not work out of the box in a monitor with a larger/smaller resolution. To fix that:

1. Open `awesome/configuration/rofi/appmenu/rofi.rasi`

#### If you're using `Floppy`:

1. Find the `window {}` block, change the `height` and `width`.

- Tips:
	- The top panel has 28px height, so `$(YOUR_SCREEN_HEIGHT) - 28 = ROFI_HEIGHT`.
	- While the left panel has 45px width, so `$(YOUR_SCREEN_WIDTH) - 45 = ROFI_WIDTH`.
	- It is also advisable to alter the values of `padding` in the `mainbox {}` and `element {}` block.

- Note:
	- In multihead setups, both rofi configuration will only open in your PRIMARY screen. You can change that by changing the `monitor` value in the `configuration {}` block. More info in `man rofi`.

#### If you're using `GNawesOME`:

- Note:
	- Unlike in `Floppy`, the rofi will open in fullscreen mode and will open in the focused screen.
	- It's likely that you still need to change the `paddings` in the `mainbox {}` and `element {}` block.


### Use the Powerleve10k prompt

<img src="https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/powlevel10k.png" align="center" height="130px"></h3>

1. Check the $SHELL you're using right now.

```bash
$ echo $SHELL
```

The output should be `/usr/bin/zsh`.

2. Not using ZSH? Well, it's a requirement. So to achieve the glory of Powerlevel10k you have to install it first. Assuming you're using the best distro in the universe, **Arch Linux**<sup>(i'm not joking)</sup>, you can install it by:

```bash
# Update your system then install zsh
$ pacman -Syu zsh
```

3. Change your $SHELL from whatever you're using right now to ZSH.

```bash
# User
$ chsh -s $(which zsh)

# System-wide
$ sudo chsh -s $(which zsh)
```

4. Now, install `oh-my-zsh`:

```bash
# via curl
$ sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# via wget
$ sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
```

4. Download the recommended font [here](https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k). *Optional but highly recommended.* If you don't want to install the font, skip to instruction #8.

5. Install the font by copying it to:

```bash
# User only
cp FONTNAME.TTF $HOME/.local/share/fonts/TTF/

# System-wide
cp FONTNAME.TTF /usr/share/fonts/TTF/
```

If the folder doesn't exist, create it.

7. Change your terminal font to `MesloLGS NF`.

8. Install the Powerlevel10k theme

```bash
$ git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
```

9. Open `~/.zshrc` with your editor

```bash
$ $EDITOR $HOME/.zshrc
```

10. Find the line `ZSH_THEME=robbyrussell` it's not easy to miss. Then change it to `ZSH_THEME=powerlevel10k/powerlevel10k`.

11. Open your terminal. There should be some instructions/dialog there that will greet you and will guide you to theme your Powerlevel10k prompt.

12. More info about Powerlevel10k [here](https://github.com/romkatv/powerlevel10k). 


## Keybindings

**Mod4** is the Windows key. Note that these are the universally implemented in all of my setups so some are missing. All the keybindings in global menu can be located by pressing <kbd>Mod4 + F1</kbd>.

### Launchers

<kbd>Mod4 + Return</kbd> - Launch default terminal  
<kbd>Mod4 + \`</kbd> Launch dropdown terminal  
<kbd>Mod4 + Shift + e</kbd> - Launch default file manager  
<kbd>Mod4 + Shift + f</kbd> - Launch default web browser  
<kbd>Mod4 + e</kbd> - Launch application menu  
<kbd>Mod4 + Shift + Escape</kbd> Launch system monitor 

### Navigation

<kbd>Mod4 + F2</kbd> - Open today panel  
<kbd>Mod4 + F3</kbd> - Open notification panel/Open settings panel

### Utilities

<kbd>Control + Escape</kbd> - Toggle system tray  
<kbd>Mod4 + l</kbd> - Lock the screen  
<kbd>Mod4 + t</kbd> - Toggle redshift filter  
<kbd>Mod4 + [</kbd> - Decrease the blur effect  
<kbd>Mod4 + ]</kbd> - Increase the blur effect  
<kbd>Print</kbd> - Take a screenshot  
<kbd>Mod4 + Shift + s</kbd> - Take a selected screenshot  

### Awesome

<kbd>Mod4 + F1</kbd> - Show keybindings  
<kbd>Control + Mod4 + R</kbd> - Reload awesome wm configuration  
<kbd>Control + Mod4 + q</kbd> - Quit awesome wm  


## Basic File Structure

+ `Configuration` contains the keybindings, client rules, tags, rofi and picom configuration, startup applications, credentials storage, and tag-list.
+ `Layout` hold the disposition of the widgets, panels and sidebars.
+ `Module` contains all the standalone extra modular features available. You can disable/enable them without causing errors.
+ `Theme` holds all the aesthetic aspects like colors, fonts, and beautiful configuration. It also contains the wallpapers and icons.
+ `Widget` contains all the widgets and its configurations.
+ `Binaries` contains all the binaries needed for a certain task.


## Configuration and Preferences

+ **Configure theme's colors/aesthetics?**

	Awesome WM uses the `beautiful` library to beautify your setup.

	Change the values here:
	- `awesome/theme/default-theme.lua`
	- `awesome/theme/theme-name/init.lua`

+ **Configure Panels and bars?**
	
	The panels and sidebars are located in:
	- `awesome/layout/`
	- `awesome/widget/right-dashboard/`

	Top panel location:
	- `awesome/layout/top-panel.lua`

	Left panel location:
	- `awesome/layout/left-panel/init.lua`

	Right/Notificaton panel location:
	- `awesome/widget/right-dashboard/right-panel.lua`

	The right/notification panel is optional, you can remove it from the top panel.

+ **Configure Start-up and default applications**
	
	You can change the applications here:
	- `awesome/configuration/apps.lua`

+ **Configure Keybindings?**
	
	You can check keybinds by pressing <kbd>Mod4 + F1</kbd>.

	Client keybindings:
	- `awesome/configuration/client/keys.lua`

	Global keybindings:
	- `awesome/configuration/keys/global.lua`

+ **Configure client rules?**
	
	The client rules manages the behaviour of the client. Is it floating? Is it above the other clients? Is it under the other clients, perhaps? What tag will the client spawn?

	Client rules:
	- `awesome/configuration/client/rules.lua`

+ **Configure client tags?**
	
	Tags are the "workspaces". Terminal, web browsers, text editors are few of the tags used here.

	Client tags:
	- `awesome/configuration/tags/init.lua`

+ **Configure the compositor?**
	
	The compositor we are using is tryone144's picom [feature/dual_kawase](https://github.com/tryone144/compton/tree/feature/dual_kawase) branch that provides the `kawase blur` shader. It gives the beautiful<sup>**beauty is subjective**</sup> blur effect.

	Compositor configuration file:
	-  `awesome/configuration/picom.conf`

+ **Configure rofi?**
	
	What is rofi? Rofi is a window switcher,  application launcher, ssh dialog and dmenu replacement

	Rofi location:
	- `awesome/configuration/rofi/`

	We will use two rofi configuration. One is for application launcher and the second one is for web searching.

	Rofi Application Launcher:
	- `awesome/configuration/rofi/appmenu/rofi.rasi`

	Rofi Web Search:
	- `awesome/configuration/rofi/sidebar/rofi.rasi`

	Rofi Web Search History file:
	- `awesome/configuration/rofi/sidebar/history.txt`


+ **Weather and Email Credentials**
	
	You can put your credentials in the `awesome/configuration/secrets.lua` file.
	Notes:
	- Your credentials are exposed.
	- It is better to encrypt it by using GnuPG, for example.


## About Widgets


#### Weather Widget

<img src="https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/widgets/weather.png" alt="weather_img" align="right" width="350px">
	
How to get a credentials for weather widget?

- OpenWeatherMap is our weather provider. So go to OpenWeatherMap's [website](https://home.openweathermap.org/).
- Register, log-in, and then go [here](https://home.openweathermap.org/api_keys) to generate your very own API keys. 
- Put your credentials in `awesome/configuration/secrets.lua`.

- Depends:
	`jq`


#### Email Widget

<img src="https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/widgets/email.png" alt="email_img" align="right" width="350px">
	
How to get a valid credentials for email widget?

The widget uses an IMAP. 
So it means that any email service provider that provides an IMAP support is supported by the widget.

- You need an email_address.
- You must generate an app password for your account. Your account password **WILL NOT WORK!** An App Password is required!
- Just search the instruction in the internet on how to generate an App Password for your email account.
- You need an imap_server.
	- Just get your email service provider's imap server. Gmail's imap server is `imap.gmail.com`. You can search it in the internet.
- Provide the port.
		Again, you can just search it in the internet. Gmail's port is `993`.
- Put your credentials in `awesome/configuration/secrets.lua`.


#### Calculator Widget

<img src="https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/widgets/calculator.png" alt="calculator_img" align="right" width="350px">
	
The calculator widget is the result of my boredom. 
- Supports:
	- Basic math operations
	- Keyboard support

- Tips:
	Enable keyboard support by hovering your mouse above the calculator.
	Or toggle it on/off by pressing the keyboard button.
	Only numbers, arithmetic operators, and decimal point is accepted.

- Keyboard Binding:
	- <kbd>=</kbd> and <kbd>Return</kbd> to evaluate.
	- <kbd>BackSpace</kbd> to delete the last digit.
	- <kbd>Escape</kbd> to clear the screen.
	- <kbd>x</kbd> stops the keygrabbing.

- Note:
	- While in keygrabbing mode, your keyboard's focus will be on the calculator. So you're AwesomeWM keybinding will stop working.<sup>temporarily of course.</sup> 

- Stopping the keygrabbing mode:
	- Move away your cursor from the calculator.
	- Toggle it off using the keyboard button.
	- Press <kbd>x</kbd>.


#### Trash Widget

<img src="https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/widgets/trash.png" alt="trash_img" align="right" width="350px">

The trash widget.. well errm.. is actually useful.
It monitors your trash directory using the AwesomeWM's `awful.spawn.with_line_callback()` and `gio monitor trash:///`, then updates the icon if there is changes.

- Tip:
	Right-click to show the menu.


#### Music Widget

- Depends:
	- `mpd`, `mpc`

- Optional Depends:
	- music file with metadata
	- music file with hardcoded album cover

It is better if you have a music file with metadata.


#### Screen Recorder Widget

<img src="https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/widgets/screen-recorder.png" alt="recorder_img" align="right" width="350px">

This is actually useful for basic screen recording.

- Depends: 
	- `ffmpeg`

- Features:
	- You can toggle microphone on and off.
	- Change the settings on the main widget.

- Note: 
	- You can change the default settings in `awesome/widget/screen-recorder/screen-recorder-config.lua` 



### About Modules

#### Lockscreen Module

<img src="https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/modules/lockscreen.png" alt="lockscreen_img" align="right" width="350px">
	
Inspired by [elenapan](https://github.com/elenapan/)'s lockscreen module.
	
- Depends:
	- `ffmpeg`
	- a webcam

- Features:
	- Using `ffmpeg`, it captures a picture using your webcam if the password is wrong. (Enabled by default)
		- Will store the images to `$HOME/Pictures/Intruder/` folder.

- Keyboard Binding:
	- <kbd>Mod4 + l</kbd> - lock the screen
	- <kbd>Control + u</kbd> or <kbd>Escape</kbd> - clear the typed password
	- <kbd>Return</kbd> - validate password

- Background modes
	- `blur` method uses `imagemagick`'s `convert` to blur the background. 
		- There's also a dynamic background functionality like the one with the `dynamic-wallpaper` module. It changes the blurred background image based on time. This is enabled by default. If disabled, it will use the default wallpaper. Configure it in `awesome/module/lockscreen.lua`.

	- `root` uses the root background/wallpaper as the lockscreen's background image.
	- `background` use the `beautiful.background` color as the background image. Use it with blur and transparency to make it more beautiful.

- Note:
	- The default password is `toor` and it's in `awesome/configuration/secrets.lua`.
	- Integrated with the `user-profile` widget to get the profile picture.
	- You can also set your picture manually.


#### Titlebar Module

The titlebar module is quite flexible. You can set the titlebar's position, color, and size for each client differently.

<img src="https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/modules/custom-titlebars.png">

1. Open `awesome/modules/titlebar.lua`.
2. Find the `Customize` block.
3. You can customize the titlebar of a client using its `class`, `instance` or `name`. Use `xprop` to get the needed value.

	For example, let's create a customized titlebar for kitty terminal that has a class name `kitty`:

	```lua
	if c.class == "kitty" then
		decorate_titlebar(c, 'right', '#ff00ff', 20)
	end
	```

	The class `kitty` will have a purple-colored right titlebar with a size of 20 pixels


#### Dynamic Wallpaper Module
	
Another fruit of my boredom.

- Note:
	- The wallpapers are in `awesome/theme/wallpapers/`
	- It has a four scheduled time:
		- `morning`, `noon`, `night`, `midnight`
	- Right now, it only searches for `*.jpg` image format. You can change it by editing the wallpaper name in the `awesome/module/dynamic-wallpaper.lua`


#### Backdrop Module

<img src="https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/modules/backdrop.png" alt="lockscreen_img" align="right" width="350px">

This module is developed by [PapyElGringo](https://github.com/PapyElGringo/) for his [material-awesome](https://github.com/PapyElGringo/material-awesome). This module adds a backdrop blur to the dialogs and modals. You can disable it by setting the `draw_backdrop` to `false` in the `awesome/configuration/client/rules.lua`


#### Menu Module

Yes, this is somewhat useless when we're using a tiling window managers, buuut... AwesomeWM is not a tiling window manager. It's a framework! And it handles floating clients pretty well. Sooo...

- Depends:
	- `xdg-menu` or [`awesome-freedesktop`](https://github.com/lcpz/awesome-freedesktop/). 

- `xdg-menu` needs a manual intervention. More info [here](https://wiki.archlinux.org/index.php/Awesome#Applications_menu)
- `awesome-freedesktop` will populate the menu for you. More info [here](https://github.com/lcpz/awesome-freedesktop/)


## More

### Anti-aliased corners

An example of anti-aliased titlebars:

<img src="https://github.com/manilarome/the-glorious-dotfiles/blob/master/screenshots/antialias.png" alt="antialias">

Anti-aliasing is pretty doable, but it requires a hackish way to do it and the code is ugly and unmaintainable<sup>(yeah just like my code)</sup>. Implementing it will make the titlebar module more obscure and will more likely break things.

*Anti-aliasing can be applied to any wibox by making its background color transparent and putting all its items in a shaped container with the desired background color.*

The explanation above is from [elenapan](https://github.com/elenapan/dotfiles#anti-aliasing)'s documentation.

It means we have to add more than one titlebar around the client with transparent background then put a *shaped container* inside it to act as the titlebar's background. 


Code example on how to create an anti-aliased left titlebar:

```lua
-- A titlebar with a color of #00000000, a black color with full transparency.
awful.titlebar(c, {position = 'left', size = title_bar_size, bg = "#00000000"}) : setup {
	{   
		{
			awful.titlebar.widget.closebutton    (c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.minimizebutton (c),
			layout  = wibox.layout.fixed.vertical
		},
		{
			buttons = buttons,
			layout  = wibox.layout.flex.vertical
		},
		{ 
			awful.titlebar.widget.floatingbutton (c),
			layout = wibox.layout.fixed.vertical
		},
		layout = wibox.layout.align.vertical,
	},
	-- Purple color, this will act as the titlebar's background color.
	bg = "#ff00ff",
	-- This is the anti-aliased shaped container that will have the purple color and will act as the titlebar's background with 9 as the corner radius.
	shape = function(cr, width, height)
		gears.shape.partially_rounded_rect(cr, width, height, true, false, false, true, 9) 
	end,
	widget = wibox.container.background
}
```

## Testing the setup in VMs

+ If you want to try it on a virtual machine, kitty and picom's kawase blur will not likely work. It's because the said programs need a newer OpenGL support which the virtual machines doesn't have. If you're using VMWare you must set it to compatibility mode that supports OpenGL >=3.3.

## TODOs

- [x] Multi-monitor support  
- [ ] Scrollable Notification Center<sup>send help</sup>
- [x] Adjust picom's blur strength using a slider
- [x] Extend the screen recorder widget's functionality
- [ ] Refactor for cleaner code


## Having a problem?

Having an issue, problem, errors, fixes, or suggestions? Just open an [issue](https://github.com/manilarome/the-glorious-dotfiles/issues) or [pull request](https://github.com/manilarome/the-glorious-dotfiles/pulls).


## Acknowledgement
+ [**PapyElGringo**](https://github.com/PapyElGringo/) for the inspiration. I was inspired by his [marterial-awesome](https://github.com/PapyElGringo/material-awesome) to start ricing again. `material-awesome` is one of the most functional and beautiful<sup>at the same time</sup> rice I have ever seen.
+ [**elenapan**](https://github.com/elenapan/dotfiles), [**addyfe**](https://github.com/addy-dclxvi/almighty-dotfiles) for the inspiration.
+ **pdonadeo** for the [Rofi Web Search](https://github.com/pdonadeo/rofi-web-search) script.
+ Also thanks to the developers of AwesomeWM and to the contributors in my repo. ♥


## A counter that will boost my ego
[![HitCount](http://hits.dwyl.com/manilarome/Glorified-Dotfiles.svg)](http://hits.dwyl.com/manilarome/the-glorified-dotfiles)
