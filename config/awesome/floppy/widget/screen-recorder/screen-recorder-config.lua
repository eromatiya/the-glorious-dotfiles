local user_preferences = {}


user_resolution 	= '1366x768'							-- Screen 	WIDTHxHEIGHT
user_offset 		= '0,0' 								-- Offset 	x,y
user_audio 			= false									-- bool   	true or false
user_save_directory = '$(xdg-user-dir VIDEOS)/Recordings/'	-- String 	$HOME
user_mic_lvl 		= '20'									-- String
user_fps 			= '30'									-- String


user_preferences.user_resolution = user_resolution or '1024x768'
user_preferences.user_offset = user_offset or '0,0'
user_preferences.user_audio = user_audio or false
user_preferences.user_save_directory = user_save_directory or '$(xdg-user-dir VIDEOS)/Recordings/'
user_preferences.user_mic_lvl = user_mic_lvl or '10'
user_preferences.user_fps = user_fps or '30'

return user_preferences