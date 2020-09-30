local filesystem = require('gears.filesystem')
local config_dir = filesystem.get_configuration_dir()
local utils_dir = config_dir .. 'utilities/'

return {
	-- The default applications that we will use in keybindings and widgets
	default = {
		terminal = 'kitty',		-- Default terminal emulator
		web_browser = 'firefox',		-- Default web browser
		text_editor = 'subl3',		-- Default text editor
		file_manager = 'dolphin',		-- Default file manager
		multimedia = 'vlc',		-- Default media player
		game = 'supertuxkart',		-- Default game, can be a launcher like steam
		graphics = 'gimp-2.10',		-- Default graphics editor
		sandbox = 'virtualbox',		-- Default sandbox
		development = '',		-- Default IDE
		network_manager = 'kitty iwctl',		-- Default network manager
		bluetooth_manager = 'blueman-manager',		-- Default bluetooth manager
		power_manager = 'xfce4-power-manager',		-- Default power manager
		package_manager = 'pamac-manager',		-- Default gui package manager
		lock = 'awesome-client "awesome.emit_signal(\'module::lockscreen_show\')"',		-- Default locker
		quake = 'kitty --name QuakeTerminal',		-- Default quake terminal
		rofi_global = 'rofi -dpi ' .. screen.primary.dpi .. 
							' -show "Global Search" -modi "Global Search":' .. config_dir .. 
							'/configuration/rofi/global/rofi-spotlight.sh' .. 
							' -theme ' .. config_dir ..
							'/configuration/rofi/global/rofi.rasi',		-- Default rofi global menu
		rofi_appmenu = 'rofi -dpi ' .. screen.primary.dpi ..
							' -show drun -theme ' .. config_dir ..
							'/configuration/rofi/appmenu/rofi.rasi'		-- Default app menu

		-- You can add more default applications here
	},
	-- List of apps to start once on start-up
	-- auto-start.lua module will start these
	run_on_start_up = {
		'picom -b --experimental-backends --dbus --config ' ..
		config_dir .. '/configuration/picom.conf',		-- Compositor
		'blueman-applet',		-- Blueman applet
		'mpd',		-- Music server
		'/usr/bin/lxqt-policykit-agent &' ..
		' eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)',		-- Polkit and keyring
		'xrdb $HOME/.Xresources',		-- Load X colors
		'pulseeffects --gapplication-service',		-- Audio equalizer
		[[
		xidlehook --not-when-fullscreen --not-when-audio --timer 600 \
		"awesome-client 'awesome.emit_signal(\"module::lockscreen_show\")'" ""
		]]		-- Lockscreen timer

		-- You can add more start-up applications here
	},
	-- List of binaries/shell scripts that will execute for a certain task
	utils = {
		full_screenshot = utils_dir .. 'snap full',		-- Fullscreen screenshot
		area_screenshot = utils_dir .. 'snap area',		-- Area screenshot
		update_profile  = utils_dir .. 'profile-image'		-- Update profile picture
	}
}
