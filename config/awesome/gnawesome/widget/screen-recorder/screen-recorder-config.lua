local user_preferences = {}

user_preferences.user_resolution			= '1366x768'							-- Screen	WIDTHxHEIGHT
user_preferences.user_offset				= '0,0'									-- Offset 	x,y
user_preferences.user_audio					= false									-- bool   	true or false
user_preferences.user_save_directory		= '$(xdg-user-dir VIDEOS)/Recordings/'	-- String 	$HOME
user_preferences.user_mic_lvl				= '20'									-- String
user_preferences.user_fps					= '30'									-- String

return user_preferences