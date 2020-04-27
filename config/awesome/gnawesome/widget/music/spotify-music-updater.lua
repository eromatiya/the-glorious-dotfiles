local gears = require('gears')
local awful = require('awful')
local naughty = require('naughty')

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/music/icons/'

local ui_content = require('widget.music.content')

local album_cover = ui_content.album_cover
local prog_bar = ui_content.progress_bar
local track_time = ui_content.track_time
local song_info = ui_content.song_info
local vol_slider = ui_content.volume_slider
local media_buttons = ui_content.media_buttons

-- We can't set/get the data for these
-- So let's hide them

prog_bar.visible = false
track_time.time_status.visible = false
track_time.time_duration.visible = false
media_buttons.repeat_button.visible = false
media_buttons.random_button.visible = false


local update_cover = function()
	local get_art_url = [[
	dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get \
	string:'org.mpris.MediaPlayer2.Player' string:'Metadata' | 
	egrep -A 1 "artUrl"| egrep -v "artUrl" | awk -F '"' '{print $2}' |
	sed -e 's/open.spotify.com/i.scdn.co/g'
	]]

	awful.spawn.easy_async_with_shell(
		get_art_url,
		function(link)
			
			local download_art = [[
			tmp_dir="/tmp/awesomewm/${USER}/"
			tmp_cover_path=${tmp_dir}"cover.jpg"

			if [ ! -d $tmp_dir ]; then
				mkdir -p $tmp_dir;
			fi

			if [ -f $tmp_cover_path]; then
				rm $tmp_cover_path
			fi

			wget -O $tmp_cover_path ]] ..link .. [[

			echo $tmp_cover_path
			]]

			awful.spawn.easy_async_with_shell(
				download_art,
				function(stdout)

					local album_icon = stdout:gsub('%\n', '')

					album_cover.cover:set_image(gears.surface.load_uncached(album_icon))

					album_cover:emit_signal("widget::redraw_needed")
					album_cover:emit_signal("widget::layout_changed")
					
					collectgarbage('collect')
				end
			)
		end
	)
end


local update_title = function()
	awful.spawn.easy_async_with_shell(
		[[
		 dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata' |
		 egrep -A 1 "title" | egrep -v "title" | awk -F '"' '{print $2}'
		]],
		function(stdout)

			local title = stdout:gsub('%\n', '')

			local title_widget = song_info.music_title

			local title_text = song_info.music_title:get_children_by_id('title')[1]

			title_text:set_text(title)

			title_widget:emit_signal("widget::redraw_needed")
			title_widget:emit_signal("widget::layout_changed")

			collectgarbage('collect')
		end
	)
end


local update_artist = function()


	awful.spawn.easy_async_with_shell(
		[[
		dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'|
		egrep -A 2 "artist" | egrep -v "artist" | egrep -v "array" | awk -F '"' '{print $2}'
		]],
		function(stdout)
		
			-- Remove new lines
			local artist = stdout:gsub('%\n', '')

			if (stdout == nil or stdout == '') then
				artist = 'Advertisement'
			end

			local artist_widget = song_info.music_artist

			local artist_text = artist_widget:get_children_by_id('artist')[1]

			artist_text:set_text(artist)

			artist_widget:emit_signal("widget::redraw_needed")
			artist_widget:emit_signal("widget::layout_changed")

			collectgarbage('collect')
		end
	)
end


local update_volume_slider = function()

-- Stop. Don't indent.
-- It's python. Nuff said
	local get_volume = [[
python - <<END
import subprocess
import os
x=0
y=0
env = os.environ
env['LANG'] = 'en_US'
app = '"Spotify"'
pactl = subprocess.check_output(['pactl', 'list', 'sink-inputs'], env=env).decode().strip().split()
if app in pactl:
    for e in pactl:
        x += 1
        if e == app:
            break
    for i in pactl[0 : x -1 ]:
        y += 1
        if i == 'Sink' and pactl[y] == 'Input' and '#' in pactl[y + 1]:
            sink_id = pactl[y+1]
        if i == 'Volume:' and '%' in pactl[y + 3]:
            volume = pactl[y + 3]
    sink_id = sink_id[1: ]
    volume = volume[ : -1 ]
    print(volume)
END
	]]

	awful.spawn.easy_async_with_shell(
		get_volume, 
		function(stdout)
			-- naughty.notification({message=stdout})
			
			local volume_slider = vol_slider.vol_slider

			volume_slider:set_value(tonumber(stdout:match('%d+')))
		end
	)
end


local check_if_playing = function()
	awful.spawn.easy_async_with_shell(
		[[
		dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' | 
		grep -A 1 "string" | awk -F '"' '{print $2}'
		]],
		function(stdout)

			local play_button_img = media_buttons.play_button_image.play
		
			if stdout:match("Playing") then
				play_button_img:set_image(widget_icon_dir .. 'pause.svg')
				update_volume_slider()
			else
				play_button_img:set_image(widget_icon_dir .. 'play.svg')
			end
		end
	)
end


local set_spotify_volume = function(value)

	local set_volume = [[
python - <<END
import subprocess
import os
import sys

x=0
y=0
env = os.environ
env['LANG'] = 'en_US'
app = '"Spotify"'
pactl = subprocess.check_output(['pactl', 'list', 'sink-inputs'], env=env).decode().strip().split()
if app in pactl:
	for e in pactl:
		x += 1
		if e == app:
			break
	for i in pactl[0 : x -1 ]:
		y += 1
		if i == 'Sink' and pactl[y] == 'Input' and '#' in pactl[y + 1]:
			sink_id = pactl[y+1]
	sink_id = sink_id[1: ]

	arg = int(]] .. value .. [[)
	if arg < 0:
		arg = 0
	if arg > 100:
		arg = 100
	subprocess.run(['pactl', 'set-sink-input-volume', sink_id, str(arg) + '%'])

END
	]]

	awful.spawn.easy_async_with_shell(
		set_volume, 
		function(stdout) end
	)

end


vol_slider.vol_slider:connect_signal(
	'property::value',
	function()
		local volume_slider = vol_slider.vol_slider
		set_spotify_volume(tostring(volume_slider:get_value()))
	end
)


local update_all_content = function()
	-- Add a delay
	gears.timer.start_new(2, function() 
		update_title()
		update_artist()
		update_cover()
		check_if_playing()
		update_volume_slider()
	end)
end


update_all_content()


media_buttons.play_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				awful.spawn.easy_async_with_shell(
					[[
					dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
					]], 
					function() 
						check_if_playing()
					end
				)
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
				awful.spawn.easy_async_with_shell(
					[[
					dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next
					]], 
					function() 
						update_all_content()
					end
				)
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
				awful.spawn.easy_async_with_shell(
					[[
					dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous
					]], 
					function() 
						update_all_content()
					end
				)
			end
		)
	)
)