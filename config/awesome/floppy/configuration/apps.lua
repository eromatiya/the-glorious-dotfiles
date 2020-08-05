local filesystem = require('gears.filesystem')
local config_dir = filesystem.get_configuration_dir()
local bin_dir = config_dir .. 'binaries/'

return {

	-- The default applications that we will use in keybindings and widgets
	default = {

		-- Terminal Emulator
		terminal				= 'kitty',

		-- GUI Text Editor
		text_editor 			= 'subl3',

		-- Web browser
		web_browser 			= 'firefox',

		-- GUI File manager
		file_manager 			= 'dolphin',

		-- Network manager
		network_manager 		= 'nm-connection-editor',

		-- Bluetooth manager
		bluetooth_manager 		= 'blueman-manager',

		-- Power manager
		power_manager 			= 'xfce4-power-manager',

		-- GUI Package manager
		package_manager 		= 'pamac-manager',

		-- Lockscreen
		lock 					= 'awesome-client "awesome.emit_signal(\'module::lockscreen_show\')"',
		
		-- Quake-like Terminal
		quake 					= 'kitty --name QuakeTerminal',

		-- Rofi Web Search
		rofi_global				= 'rofi -dpi ' .. screen.primary.dpi .. 
									' -show "Global Search" -modi "Global Search":' .. config_dir .. 
									'/configuration/rofi/global/rofi-spotlight.sh' .. 
									' -theme ' .. config_dir ..
									'/configuration/rofi/global/rofi.rasi',

		-- Application Menu
		rofi_appmenu 			= 'rofi -dpi ' .. screen.primary.dpi ..
									' -show drun -theme ' .. config_dir ..
									'/configuration/rofi/appmenu/rofi.rasi'

		-- You can add more default applications here
	},
	
	-- List of apps to start once on start-up
	-- auto-start.lua module will start these

	run_on_start_up = {

		-- Compositor
		'picom -b --experimental-backends --dbus --config ' ..
		config_dir .. '/configuration/picom.conf',

		-- Bluetooth tray icon
		'blueman-applet',

		-- Music Server
		'mpd',

		-- Power manager
		'xfce4-power-manager',

		-- Credential manager
		'/usr/lib/polkit-kde-authentication-agent-1 &' ..
		' eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)',
		
		-- Load X Colors
		'xrdb $HOME/.Xresources',

		-- NetworkManager Applet
		'nm-applet',

		-- Audio Equalizer
		'pulseeffects --gapplication-service',

		-- Auto lock timer
		[[
		xidlehook --not-when-fullscreen --not-when-audio --timer 600 \
		"awesome-client 'awesome.emit_signal(\"module::lockscreen_show\")'" ""
		]]

		-- You can add more start-up applications here
	},

	-- List of binaries/shell scripts that will execute a certain task

	bins = {

		-- Full Screenshot
		full_screenshot = bin_dir .. 'snap full',

		-- Area Selected Screenshot
		area_screenshot = bin_dir .. 'snap area',

		-- Update profile picture
		update_profile  = bin_dir .. 'profile-image'
	}
}
