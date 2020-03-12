local awful = require('awful')
local naughty = require('naughty')

local user_config = require('widget.screen-recorder.screen-recorder-config')

local scripts_tbl = {}


local ffmpeg_pid = nil


-- Get user settings
user_resolution = user_config.user_resolution or '1024x768'
user_offset = user_config.user_offset or '0,0'
user_audio = user_config.user_audio or false
user_dir = user_config.user_save_directory or '$HOME/Videos/Recordings/'
user_mic_lvl = user_config.user_mic_lvl or '10'
user_fps = user_config.user_fps or '30'


update_user_settings = function(res, offset, audio)
	user_resolution = res
	user_offset = offset
	user_audio = audio
end


check_settings = function()
	-- For debugging purpose only
	-- naughty.notification({
	-- 	message=user_resolution .. ' ' .. user_offset .. tostring(user_audio)
	-- })
end



local create_save_directory = function()

	local create_dir_cmd = [[
	dir=]] .. user_dir .. [[

	if [ ! -d $dir ]; then
		mkdir -p $dir
	fi
	]]

	awful.spawn.easy_async_with_shell(
		create_dir_cmd, 
		function(stdout) end
	)

end

create_save_directory()



local kill_existing_recording_ffmpeg = function()
	-- Let's killall ffmpeg instance first after awesome (re)-starts if there's any
	awful.spawn.easy_async_with_shell(
		[[
		ps x | grep "ffmpeg -video_size" | grep -v grep | awk '{print $1}' | xargs kill
		]], 
		function(stdout) end
	)
end

kill_existing_recording_ffmpeg()



local turn_on_the_mic = function()

	awful.spawn.easy_async_with_shell(
		[[
		amixer set Capture cap
		amixer set Capture ]].. user_mic_lvl ..[[%
		]], 
		function() end
	)

end

local ffmpeg_stop_recording = function()

	awesome.kill(
		ffmpeg_pid, awesome.unix_signal.SIGINT
	)
end


local create_notification = function(file_dir)
	local open_image = naughty.action {
		name = 'Open',
		icon_only = false,
	}

	local delete_image = naughty.action {
		name = 'Delete',
		icon_only = false,
	}

	local close = naughty.action {
		name = 'Close',
		icon_only = false,
	}

	open_image:connect_signal('invoked', function()
		awful.spawn('xdg-open ' .. file_dir, false)
	end)

	delete_image:connect_signal('invoked', function()
		awful.spawn('rm -rf ' .. file_dir, false)
	end)

	naughty.notification ({
		app_name = 'Screenshot Tool',
		timeout = 60,
		title = 'Snap!',
		message = 'Recording finished and now can be viewed!',
		actions = { open_image, delete_image, close }
	})
end


local ffmpeg_start_recording = function(audio, filename)

	local add_audio_str = ' ' 

	if audio then
		turn_on_the_mic()
		add_audio_str = ' -f pulse -ac 2 -i default ' 
	end

	ffmpeg_pid = awful.spawn.easy_async_with_shell(
		[[		
		file_name=]] .. filename .. [[		

		ffmpeg -video_size ]] .. user_resolution .. [[ -framerate ]] .. user_fps .. [[ -f x11grab \
		-i :0.0+]] .. user_offset .. add_audio_str .. [[ $file_name
		]],
		function(stdout, stderr)

			if stderr and stderr:match('Invalid argument') then
				naughty.notification({
					app_name = 'Screen recorder widget',
					title = 'Invalid configuration!',
					message = 'Oof! The capture area ' .. user_resolution ..' at position ' .. user_offset .. ' is outside the screen size.' .. 
					'\nDecrease the capture area/geometery or remove the offset.',
					urgency = 'critical'
				})
				_G.sr_recording_stop()
				return
			end

			create_notification(filename)

		end
	)
end


local create_unique_filename = function(audio)
	awful.spawn.easy_async_with_shell(
		[[
		dir=]] .. user_dir .. [[
		date=$(date '+%Y-%m-%d_%H-%M-%S')
		format=.mp4

		echo ${dir}${date}${format} | tr -d '\n'
		]],
		function(stdout) 
			local filename = stdout

			ffmpeg_start_recording(audio, filename)
		end)
end


start_recording = function(audio_mode)

	create_save_directory()
	create_unique_filename(audio_mode)

end

stop_recording = function()

	ffmpeg_stop_recording()

end


-- User preferences

scripts_tbl.user_resolution = user_resolution
scripts_tbl.user_offset = user_offset
scripts_tbl.user_audio = user_audio
scripts_tbl.update_user_settings = update_user_settings


scripts_tbl.start_recording = start_recording
scripts_tbl.stop_recording = stop_recording

scripts_tbl.check_settings = check_settings

return scripts_tbl