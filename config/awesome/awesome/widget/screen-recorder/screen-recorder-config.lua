local user_preferences = {}


user_resolution 	= '1366x768'					-- Screen 	WIDTHxHEIGHT
user_offset 		= '0,0' 						-- Offset 	x,y
user_audio 			= false							-- bool   	true or false
user_save_directory = '$HOME/Videos/Recordings/'	-- String 	$HOME
user_mic_lvl 		= '20'							-- String
user_fps 			= '30'							-- String


user_preferences.user_resolution = user_resolution
user_preferences.user_offset = user_offset
user_preferences.user_audio = user_audio
user_preferences.user_save_directory = user_save_directory
user_preferences.user_mic_lvl = user_mic_lvl
user_preferences.user_fps = user_fps

return user_preferences