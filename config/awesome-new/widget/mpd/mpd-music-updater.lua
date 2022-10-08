local gears = require('gears')
local awful = require('awful')
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/mpd/icons/'
local ui_content = require('widget.mpd.content')

local album_cover = ui_content.album_cover
local prog_bar = ui_content.progress_bar
local track_time = ui_content.track_time
local song_info = ui_content.song_info
local vol_slider = ui_content.volume_slider
local media_buttons = ui_content.media_buttons

local apps = require('configuration.apps')

local update_cover = function()
	
	local extract_script = [=[
		MUSIC_DIR="$(xdg-user-dir MUSIC)"
		TMP_DIR="/tmp/awesomewm/${USER}/"
		TMP_COVER_PATH=${TMP_DIR}"cover.jpg"
		TMP_SONG="${TMP_DIR}current-song"

		CHECK_EXIFTOOL=$(command -v exiftool)

		if [ ! -d "${TMP_DIR}" ]; then
			mkdir -p "${TMP_DIR}";
		fi

		if [ ! -z "$CHECK_EXIFTOOL" ]; then

			SONG="$MUSIC_DIR/$(mpc -p 6600 --format "%file%" current)"
			PICTURE_TAG="-Picture"
			
			if [[ "$SONG" == *".m4a" ]]; then
				PICTURE_TAG="-CoverArt"
			fi

			# Extract album cover using perl-image-exiftool
			exiftool -b "$PICTURE_TAG" "$SONG"  > "$TMP_COVER_PATH"

		else

			#Extract image using ffmpeg
			cp "$MUSIC_DIR/$(mpc --format %file% current)" "$TMP_SONG"

			ffmpeg \
			-hide_banner \
			-loglevel 0 \
			-y \
			-i "$TMP_SONG" \
			-vf scale=300:-1 \
			"$TMP_COVER_PATH" > /dev/null 2>&1

			rm "$TMP_SONG"
		fi
			
		img_data=$(identify $TMP_COVER_PATH 2>&1)

		# Delete the cover.jpg if it's not a valid image
		if [[ $img_data == *"insufficient"* ]]; then
			rm $TMP_COVER_PATH
		fi

		if [ -f $TMP_COVER_PATH ]; then 
			echo $TMP_COVER_PATH; 
		fi
	]=]

	awful.spawn.easy_async_with_shell(
		extract_script, 
		function(stdout)
			local album_icon = widget_icon_dir .. 'vinyl.svg'

			if not (stdout == nil or stdout == '') then
				album_icon = stdout:gsub('%\n', '')
			end

			album_cover.cover:set_image(gears.surface.load_uncached(album_icon))
			
			album_cover:emit_signal('widget::redraw_needed')
			album_cover:emit_signal('widget::layout_changed')
			
			collectgarbage('collect')
		end
	)
end

local update_progress_bar = function()
	awful.spawn.easy_async_with_shell(
		[[
		mpc status | awk 'NR==2 { split($4, a); print a[1]}'  |  tr -d '[\%\(\)]'
		]], 
		function(stdout)
			local progress_bar = prog_bar.music_bar
			if stdout ~= nil then
				progress_bar:set_value(tonumber(stdout))
			else
				progress_bar:set_value(0)
			end
		end
	)
end

local update_time_progress = function()
	awful.spawn.easy_async_with_shell(
		[[
		mpc status | awk 'NR==2 { split($3, a, "/"); print a[1]}' | tr -d '[\%\(\)]'
		]],
		function(stdout)
			local time_status = track_time.time_status
			if stdout ~= nil then
				time_status:set_text(tostring(stdout))
			else
				time_status:set_text('00:00')
			end
		end
	)

end

local update_time_duration = function()
	awful.spawn.easy_async_with_shell(
		[[
		mpc --format %time% current
		]],
		function(stdout)
			local time_duration = track_time.time_duration
			if stdout ~= nil then
				time_duration:set_text(tostring(stdout))
			else
				time_duration:set_text('99:59')
			end
		end
	)
end

local update_file = function()
	awful.spawn.easy_async_with_shell(
		[[
		mpc -f %file% current
		]], 
		function(stdout)
			file_name = stdout:gsub('%\n','')
		end
	)
	return file_name
end

local update_title = function()

	awful.spawn.easy_async_with_shell(
		[[
		mpc -f %title% current
		]],
		function(stdout)
		
			-- Remove new lines
			local title = stdout:gsub('%\n', '')

			local title_widget = song_info.music_title
			local title_text = song_info.music_title:get_children_by_id('title')[1]
			
			-- Make sure it's not null
			if not (title == nil or title == '') then
				title_text:set_text(title)			
			else

				awful.spawn.easy_async_with_shell(
					[[
					mpc -f %file% current
					]], 
					function(stdout)

						if not (stdout == nil or stdout == '') then

							file_name = stdout:gsub('%\n','')
			
							file_name = file_name:sub(1, title:len() - 5) .. ''

							title_text:set_text(file_name)

						else
							-- Set title
							title_text:set_text('Play some music!')

						end
						title_widget:emit_signal('widget::redraw_needed')
						title_widget:emit_signal('widget::layout_changed')
					end
				)
			
			end

			title_widget:emit_signal('widget::redraw_needed')
			title_widget:emit_signal('widget::layout_changed')

			collectgarbage('collect')
		end
	)
end

local update_artist = function()
	awful.spawn.easy_async_with_shell(
		[[
		mpc -f %artist% current
		]],
		function(stdout)
		
			-- Remove new lines
			local artist = stdout:gsub('%\n', '')

			local artist_widget = song_info.music_artist

			local artist_text = artist_widget:get_children_by_id('artist')[1]

			if not (artist == nil or artist == '') then

				artist_text:set_text(artist)
			
			else
				

				awful.spawn.easy_async_with_shell(
					[[
					mpc -f %file% current
					]], 
					function(stdout)
						if not (stdout == nil or stdout == '') then

							artist_text:set_text('unknown artist')

						else
							artist_text:set_text('or play some porn?')

						end
						artist_widget:emit_signal('widget::redraw_needed')
						artist_widget:emit_signal('widget::layout_changed')
					end
				)
			end

			artist_widget:emit_signal('widget::redraw_needed')
			artist_widget:emit_signal('widget::layout_changed')
		end
	)
end

local update_volume_slider = function()
	awful.spawn.easy_async_with_shell(
		[[
		mpc volume
		]], 
		function(stdout) 			
			local volume_slider = vol_slider.vol_slider
			if stdout:match('n/a') then
				return
			end
			volume_slider:set_value(tonumber(stdout:match('%d+')))
		end
	)
end

local check_if_playing = function()
	awful.spawn.easy_async_with_shell(
		[[
		mpc status | awk 'NR==2' | grep -o playing
		]],
		function(stdout)
			local play_button_img = media_buttons.play_button_image.play
			if not (stdout == nil or stdout == '') then
				play_button_img:set_image(widget_icon_dir .. 'pause.svg')
				update_volume_slider()
			else
				play_button_img:set_image(widget_icon_dir .. 'play.svg')
			end
		end
	)
end

local check_repeat_status = function()
	awful.spawn.easy_async_with_shell(
		[[
		mpc status | sed -n '/random/p' | cut -c23-24 | sed 's/^[ \t]*//'
		]],
		function(stdout)
			local repeat_button_img = media_buttons.repeat_button_image.rep
			if stdout:match('on') then
				repeat_button_img:set_image(widget_icon_dir .. 'repeat-on.svg')
			else
				repeat_button_img:set_image(widget_icon_dir .. 'repeat-off.svg')
			end
		end
	)
end

local check_random_status = function()
	awful.spawn.easy_async_with_shell(
		[[
		mpc status | sed -n '/random/p' | cut -c37-38 | sed 's/^[ \t]*//'
		]],
		function(stdout)

			local random_button_image = media_buttons.random_button_image.rand
			
			if stdout:match("on") then
				random_button_image:set_image(widget_icon_dir .. 'random-on.svg')
			else
				random_button_image:set_image(widget_icon_dir .. 'random-off.svg')
			end
		end
	)
end

vol_slider.vol_slider:connect_signal(
	'property::value',
	function()
		awful.spawn.easy_async_with_shell(
			'mpc volume ' .. vol_slider.vol_slider:get_value(), 
			function() end
		)
	end
)

local update_all_content = function()
	update_progress_bar()
	update_time_progress()
	update_time_duration()
	update_title()
	update_artist()
	update_cover()
	check_if_playing()
	check_repeat_status()
	check_random_status()
	update_volume_slider()
end

-- Update progress bar and time every N seconds
gears.timer.start_new(
	10,
	function()
		update_progress_bar()
		update_time_progress()
		return true
	end
)

local mpd_startup = [[
# Let's make sure that MPD is running.
if [ -z $(pgrep mpd) ]; then mpd; fi
]]

local mpd_change_event_listener = [[
sh -c '
mpc idleloop player
'
]]

local kill_mpd_change_event_listener = [[
ps x | 
grep "mpc idleloop player" | 
grep -v grep | 
awk '{print $1}' | 
xargs kill
]]

awful.spawn.easy_async_with_shell(
	mpd_startup, 
	function ()
		awful.spawn.easy_async_with_shell(
			kill_mpd_change_event_listener, 
			function ()
				update_all_content()
				awful.spawn.with_line_callback(
					mpd_change_event_listener,
					{
						stdout = function(line)
							update_all_content()
						end
					}
				)
			end
		)
	end
)

media_buttons.play_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				awful.spawn.with_shell('mpc toggle')
			end
		)
	)
)

media_buttons.next_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				awful.spawn.with_shell('mpc next')
			end
		)
	)
)

media_buttons.prev_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				awful.spawn.with_shell('mpc prev')
			end
		)
	)
)

media_buttons.repeat_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				awful.spawn.easy_async_with_shell(
					'mpc repeat', 
					function () 
						check_repeat_status()
					end
				)
			end
		)
	)
)

media_buttons.random_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				awful.spawn.easy_async_with_shell(
					'mpc random', 
					function () 
						check_random_status()
					end
				)
			end
		)
	)
)
