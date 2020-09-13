return {
	widget = {
		email  = {
			address       = '',
			app_password  = '',
			imap_server   = 'imap.gmail.com',
			port          = '993'
		},

		weather = {
			key           = '',
			city_id       = '',
			units         = 'metric',
			update_interval = 1200
		},

		network = {
			wired_interface = 'enp0s0',
			wireless_interface = 'wlan0'
		},

		clock = {
			military_mode = false,
		},

		screen_recorder = {
			resolution = '1366x768',
			offset = '0,0',
			audio = false,
			save_directory = '$(xdg-user-dir VIDEOS)/Recordings/',
			mic_level = '20',
			fps = '30'
		}
	},

	module = {
		
	}
}
