local awful = require('awful')
local naughty = require('naughty')
local user_config = require('widget.screen-recorder.screen-recorder-config')
local scripts_tbl = {}
local ffmpeg_pid = nil

-- Get user settings
scripts_tbl.user_resolution = user_config.user_resolution
scripts_tbl.user_offset = user_config.user_offset
scripts_tbl.user_audio = user_config.user_audio
scripts_tbl.user_dir = user_config.user_save_directory
scripts_tbl.user_mic_lvl = user_config.user_mic_lvl
scripts_tbl.user_fps = user_config.user_fps

scripts_tbl.update_user_settings = function(res, offset, audio)
	scripts_tbl.user_resolution = res
	scripts_tbl.user_offset = offset
	scripts_tbl.user_audio = audio
end

scripts_tbl.check_settings = function()
	-- For debugging purpose only
	-- naughty.notification({
	-- 	message=scripts_tbl.user_resolution .. ' ' .. scripts_tbl.user_offset .. tostring(scripts_tbl.user_audio)
	-- })
end

local create_save_directory = function()

	local create_dir_cmd = [[
	dir="]] .. scripts_tbl.user_dir .. [["

	if [ ! -d "$dir" ]; then
		mkdir -p "$dir"
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
		ps x | grep 'ffmpeg -video_size' | grep -v grep | awk '{print $1}' | xargs kill
		]], 
		function(stdout) end
	)
end

kill_existing_recording_ffmpeg()

local turn_on_the_mic = function()
	awful.spawn.easy_async_with_shell(
		[[
		amixer set Capture cap
		amixer set Capture ]].. scripts_tbl.user_mic_lvl ..[[%
		]], 
		function() end
	)
end

local ffmpeg_stop_recording = function()
	-- Let's killall ffmpeg instance first after awesome (re)-starts if there's any
	awful.spawn.easy_async_with_shell(
		[[
		ps x | grep 'ffmpeg -video_size' | grep -v grep | awk '{print $1}' | xargs kill -2
		]], 
		function(stdout) end
	)
end

local create_notification = function(file_dir)
	local open_video = naughty.action {
		name = 'Open',
		icon_only = false,
	}

	local delete_video = naughty.action {
		name = 'Delete',
		icon_only = false,
	}

	open_video:connect_signal(
		'invoked',
		function()
			awful.spawn('xdg-open ' .. file_dir, false)
		end
	)

	delete_video:connect_signal(
		'invoked',
		function()
			awful.spawn('gio trash ' .. file_dir, false)
		end
	)

	naughty.notification ({
		app_name = 'Screen Recorder',
		timeout = 60,
		title = '<b>Recording Finished!</b>',
		message = 'Recording can now be viewed.',
		actions = { open_video, delete_video }
	})
end

local ffmpeg_start_recording = function(audio, filename)
	local add_audio_str = ' ' 

	if audio then
		turn_on_the_mic()
		add_audio_str = '-f pulse -ac 2 -i default' 
	end

	ffmpeg_pid = awful.spawn.easy_async_with_shell(
		[[		
		file_name=]] .. filename .. [[

		ffmpeg -video_size ]] .. scripts_tbl.user_resolution .. [[ -framerate ]] .. scripts_tbl.user_fps .. [[ -f x11grab \
		-i :0.0+]] .. scripts_tbl.user_offset .. ' ' .. add_audio_str .. [[ -c:v libx264 -crf 20 -profile:v baseline -level 3.0 -pix_fmt yuv420p $file_name
		]], 
		function(stdout, stderr)
			if stderr and stderr:match('Invalid argument') then
				naughty.notification({
					app_name = 'Screen Recorder',
					title = '<b>Invalid Configuration!</b>',
					message = 'Please, put a valid settings!',
					timeout = 60,
					urgency = 'normal'
				})
				awesome.emit_signal('widget::screen_recorder')
				return
			end
			create_notification(filename)
		end
	)
end

local create_unique_filename = function(audio)
	awful.spawn.easy_async_with_shell(
		[[
		dir="]] .. scripts_tbl.user_dir .. [["
		date=$(date '+%Y-%m-%d_%H-%M-%S')
		format=.mp4

		echo "${dir}${date}${format}" | tr -d '\n'
		]],
		function(stdout) 
			local filename = stdout
			ffmpeg_start_recording(audio, filename)
		end
	)
end

scripts_tbl.start_recording = function(audio_mode)
	create_save_directory()
	create_unique_filename(audio_mode)
end

scripts_tbl.stop_recording = function()
	ffmpeg_stop_recording()
end

return scripts_tbl
