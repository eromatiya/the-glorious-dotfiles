local user_preferences = {}
local config = require('configuration.config')

-- Screen	WIDTHxHEIGHT
user_preferences.user_resolution = config.widget.screen_recorder.resolution or '1366x768'

-- Offset 	x,y
user_preferences.user_offset = config.widget.screen_recorder.offset or '0,0'

-- bool   	true or false
user_preferences.user_audio = config.widget.screen_recorder.audio or false

-- String 	$HOME
user_preferences.user_save_directory = config.widget.screen_recorder.save_directory or '$(xdg-user-dir VIDEOS)/Recordings/'	

-- String
user_preferences.user_mic_lvl = config.widget.screen_recorder.mic_level or '20'

-- String
user_preferences.user_fps = config.widget.screen_recorder.fps or '30'

return user_preferences
