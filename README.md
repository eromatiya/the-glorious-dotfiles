<div align="center">
    <h3>
    	<img src="images/banner-glorious.png" align="center" height="200px">
    </h3>
    <p align="center">
    	<strong>
    		a glorified dotfiles
    	</strong>
    </p>
</div>

<div align="center">
	
[![maintained](https://img.shields.io/maintenance/yes/2020?label=maintained&style=flat-square)](https://github.com/manilarome/the-glorious-dotfiles/commits/master) [![contributions](https://img.shields.io/badge/contribution-welcome-brightgreen&?style=flat-square)](https://github.com/manilarome/the-glorious-dotfiles/pulls) [![HitCount](http://hits.dwyl.com/manilarome/Glorified-Dotfiles.svg)](http://hits.dwyl.com/manilarome/the-glorified-dotfiles)

</div>

<div align="center">
	<a href="https://github.com/manilarome/the-glorious-dotfiles/wiki">
		<img src="images/button-wiki.png" width="100px">
	</a>
	<a href="https://github.com/manilarome/the-glorious-dotfiles/wiki/Dependencies">
		<img src="images/button-depends.png" width="100px">
	</a>
	<a href="https://github.com/manilarome/the-glorious-dotfiles/wiki/Getting-Started">
		<img src="images/button-install.png" width="100px">
	</a>
	<a href="https://github.com/manilarome/the-glorious-dotfiles/wiki/Gallery">
		<img src="images/button-gallery.png" width="100px">
	</a>
	<br><br>
</div>

<p align='center'>
	<img alt='glorious' src='https://raw.githubusercontent.com/manilarome/the-glorious-screenshots/master/glorious.gif'/>
	<br/>
	<h3>
		Welcome to the glorious dotfiles!
	</h3>
</p>

<p align='center'>
	<br/>
	This is a collection/stash of my linux configurations also known as dotfiles. I don't know why did I wasted my time writing these, especially my AwesomeWM setups. Or maybe it's because... I did it for me. I liked it. I was good at it. And I was really -- I was alive. ;) So no wasted time after all. You're probably here because of my awesome dotfiles. So yeah, steal what you want. Don't forget to check my <a href='https://github.com/manilarome/'>other projects!</a>
</p>


## [Wiki here](https://github.com/manilarome/the-glorious-dotfiles/wiki)

The wiki will guide you to replicate my setups. So read the frickin' manual! If you post an issue that can be solve by reading it, I'll drop kick you.

## Summary and details

If you're too lazy to open the wiki, here's some of the details you need to know.

### Starring

- [`archlinux`](https://www.archlinux.org/download/) as distribution
- [`fish`] as shell
- [`awesomewm`](https://awesomewm.org) as window manager
- [`kitty`](https://github.com/kovidgoyal/kitty) as terminal emulator
- [`picom-git`](https://github.com/yshui/picom) as compositor
- [`rofi-git branch`](https://github.com/davatorium/rofi) as application launcher
- [`inter-font`](https://github.com/rsms/inter/) as the setup font
- [`trivago`](https://www.youtube.com/watch?v=dQw4w9WgXcQ) as hotel

### Required dependencies

| Name | Description | Why/Where is it needed? |
| --- | --- | --- |
| [`awesome-git`](https://github.com/awesomeWM/awesome) |  Highly configurable framework window manager | Isn't it obvious? |
| [`rofi-git`](https://github.com/davatorium/rofi) | Window switcher, application launcher and dmenu replacement | Application launcher |
| [`picom-git`](https://github.com/yshui/picom) | A compositor for X11 | A compositor with kawase-blur |
| [`inter-font`](https://github.com/rsms/inter/) | A typeface specially designed for user interfaces | Setup font | 

### Installation and usage

1. Install the [required dependencies](#required-dependencies). Note that there's also an [optional dependencies](https://github.com/manilarome/the-glorious-dotfiles/wiki/Dependencies#optional-dependencies).
2. Clone this repository.

	```bash
	$ git clone --depth 1 https://github.com/manilarome/the-glorious-dotfiles/
	```

3. Make sure to create a backup if you have a current AwesomeWM configuration.
4. Copy the `the-glorious-dotfiles/config/awesome/SETUPNAME` folder to your `"${HOME}"/.config/`. I'll just assume that you don't have an `awesome` folder in your `~/.config/`:

	```bash
	# Use the Floppy setup
	$ cp -r the-glorious-dotfiles/config/awesome/floppy $HOME/.config/awesome

	# Use the GNawesOME setup
	$ cp -r the-glorious-dotfiles/config/awesome/gnawesome $HOME/.config/awesome

	# Use the Linear setup
	$ cp -r the-glorious-dotfiles/config/awesome/linear $HOME/.config/awesome

	# Use the Surreal setup
	$ cp -r the-glorious-dotfiles/config/awesome/surreal $HOME/.config/awesome
	```

5. Reload AwesomeWM by pressing <kbd>Super + Shift + r</kbd>.

```
$ yay -S the-glorious-dotfiles
```

## TODOs

My TODOs or roadmap for my awesomewm setups.

- [x] Scrollable Notification Center<sup>needs improvement</sup>
- [x] Lockscreen PAM Integration
- [x] Multi-monitor support  
- [x] Refactor for cleaner code<sup>WIP</sup>
- [x] Extend the screen recorder widget's functionality
- [x] Adjust picom's blur strength using a slider


## Selling the dotfiles

Why would I want this?

### Core features

These are the features included in my AwesomeWM setups!

+ Notification Center
+ Dynamic Wallpaper
+ File/Web Searching like macOS' Spotlight
+ Application Dashboard
+ Brightness and Volume OSDs
+ Functional Trash Widget
+ Built-in Screen Recorder Widget
+ Built-in Calculator Widget
+ Email Widget
+ Weather Widget
+ Quake Terminal
+ Hardware Monitor
+ Blue Light Filter Widgets 
+ Lockscreen Module with Face Capture and PAM Integration
+ Easter eggs!<sup>Mostly bugs</sup>
+ Any many more!

I don't really rice just to make it beautiful, I want it to be also functional so that's why it's ***"bloated"*** with features.

### Gallery

Some of these are outdated, so it is better if you try them yourself. 

| Floppy |
| --- |
| ![screenshot](https://raw.githubusercontent.com/manilarome/the-glorious-screenshots/master/floppy.webp) |

| GNawesOME |
| --- |
| ![screenshot](https://raw.githubusercontent.com/manilarome/the-glorious-screenshots/master/gnawesome.webp) |

| Linear |
| --- |
| ![screenshot](https://raw.githubusercontent.com/manilarome/the-glorious-screenshots/master/linear.webp) |

| Surreal |
| --- |
| ![screenshot](https://raw.githubusercontent.com/manilarome/the-glorious-screenshots/master/surreal.webp) |

| Lockscreen with [PAM Integration](https://github.com/RMTT/lua-pam) |
| --- |
| ![Screenshot](https://raw.githubusercontent.com/manilarome/the-glorious-screenshots/master/lockscreen.webp) |

| Application Menu |
| --- |
| ![Screenshot](https://raw.githubusercontent.com/manilarome/the-glorious-screenshots/master/app-menu.webp) |

| Exit Screen |
| --- |
| ![Screenshot](https://raw.githubusercontent.com/manilarome/the-glorious-screenshots/master/exit-screen.webp) |

| Multihead |
| --- |
| ![Screenshot](https://raw.githubusercontent.com/manilarome/the-glorious-screenshots/master/multihead.webp) |

| [Rofi Global Search](https://github.com/manilarome/rofi-spotlight) |
| --- |
| ![Screenshot](https://raw.githubusercontent.com/manilarome/the-glorious-screenshots/master/rofi-global.webp) |

| [blurredfox CSS theme for Firefox](https://github.com/manilarome/blurredfox/) |
| --- |
| ![Screenshot](https://raw.githubusercontent.com/manilarome/the-glorious-screenshots/master/blurredfox.webp)

| [thunderblurred CSS theme for Thunderbird](https://github.com/manilarome/thunderblurred) |
| --- |
| ![Screenshot](https://raw.githubusercontent.com/manilarome/the-glorious-screenshots/master/thunderblurred.webp) |

<br>

## Thanks to all the contributors here! And also to the awesomewm devs! Appreciate it! <3
