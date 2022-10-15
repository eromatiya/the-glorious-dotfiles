local awful = require('awful')
local gears = require('gears')
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/mpd/icons/'
local ui_content = require('widget.mpd.content')
local album_cover = ui_content.album_cover
local song_info = ui_content.song_info
local vol_slider = ui_content.volume_slider
local media_buttons = ui_content.media_buttons

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
			local album_icon = widget_icon_dir .. 'vinyl' .. '.svg'
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
			collectgarbage('collect')
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
			else
				play_button_img:set_image(widget_icon_dir .. 'play.svg')
			end
		end
	)
end

local update_all_content = function()
	update_title()
	update_artist()
	update_cover()
	check_if_playing()
end

local mpd_startup = [[
# Let's make sure that MPD is running.
if [ -z $(pgrep mpd) ]; then mpd; fi
]]

local mpd_change_event_listener = [[
sh -c '
mpc idleloop player
'
]]

local kill_mpd_change_event_listener = [[sh -c "
ps x | 
grep 'mpc idleloop player' | 
grep -v grep | 
awk '{print $1}' | 
xargs kill
"]]

awful.spawn.easy_async_with_shell(
	mpd_startup, 
	function ()
		awful.spawn.easy_async_with_shell(
			kill_mpd_change_event_listener, 
			function ()
				update_all_content()
				awful.spawn.with_line_callback(
					mpd_change_event_listener, {
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
