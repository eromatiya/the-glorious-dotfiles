local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local music_func = {}

screen.connect_signal('request::desktop_decoration', function(s)

	-- Set music box geometry
	local music_box_margin = dpi(5)
	local music_box_height = dpi(375)
	local music_box_width = dpi(260)
	local music_box_x = nil


	s.musicpop = awful.popup {
		widget = {
		  -- Removing this block will cause an error...
		},
		ontop = true,
		visible = false,
		type = 'dock',
		screen = s,
		width = music_box_width,
		height = music_box_height,
		maximum_width = music_box_width,
		maximum_height = music_box_height,
		offset = dpi(5),
		shape = gears.shape.rectangle,
		bg = beautiful.transparent,
		preferred_anchors = {'middle', 'back', 'front'},
		preferred_positions = {'left', 'right', 'top', 'bottom'},

	}

	local ui_content = require('widget.mpd.content')

	s.album = ui_content.album_cover
	s.progress_bar = ui_content.progress_bar
	s.time_track = ui_content.track_time.time_track
	s.song_info = ui_content.song_info.music_info
	s.media_buttons = ui_content.media_buttons.navigate_buttons
	s.volume_slider  = ui_content.volume_slider.vol_slider
	
	s.musicpop : setup {
		{
			{
				layout = wibox.layout.fixed.vertical,
				expand = 'none',
				spacing = dpi(8),
				{
					s.album,
					bottom = dpi(5),
					widget = wibox.container.margin,
				},
				{
					layout = wibox.layout.fixed.vertical,
					{
						spacing = dpi(4),
						layout = wibox.layout.fixed.vertical,
						s.progress_bar,
						s.time_track,
					},
					s.song_info,
					s.media_buttons,
					s.volume_slider,
				},
			},
			top = dpi(15),
			left = dpi(15),
			right = dpi(15),
			widget = wibox.container.margin

		},
		bg = beautiful.background,
		shape = function(cr, width, height)
			gears.shape.partially_rounded_rect(
				cr, width, height, true, true, true, true, beautiful.groups_radius
			)
		end,
		widget = wibox.container.background()
	}

	s.backdrop_music = wibox {
		ontop = true,
		visible = false,
		screen = s,
		type = 'utility',
		input_passthrough = false,
		bg = beautiful.transparent,
		x = s.geometry.x,
		y = s.geometry.y,
		width = s.geometry.width,
		height = s.geometry.height
	}

	local toggle_music_box = function(type)

		local focused = awful.screen.focused()
		local music_box = focused.musicpop
		local music_backdrop = focused.backdrop_music

		if music_box.visible then
			music_backdrop.visible = not music_backdrop.visible
			music_box.visible = not music_box.visible

		else

			if type == 'keyboard' then
				music_backdrop.visible = true
				music_box.visible = true

				awful.placement.bottom_left(
					music_box,
					{
						margins = { 
							bottom = dpi(5), 
							left = dpi(music_box_x or 5)
						},
						honor_workarea = true
					}
				)
			else
				local widget_button = mouse.current_widget_geometry
				
				music_backdrop.visible = true
				music_box:move_next_to(widget_button)
				music_box_x = music_box.x
			end
		end
	end

	awesome.connect_signal(
		'widget::music',
		function(type)
			toggle_music_box(type)
		end
	)

	s.backdrop_music:buttons(
		awful.util.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					toggle_music_box()
				end
			)
		)
	)
end)


music_func.toggle_music_box = toggle_music_box

local mpd_updater = require('widget.mpd.mpd-music-updater')

return music_func 
