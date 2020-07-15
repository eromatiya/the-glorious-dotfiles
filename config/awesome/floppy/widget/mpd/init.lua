local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/mpd/icons/'
local clickable_container = require('widget.clickable-container')
local music_box = require('widget.mpd.music-box')
local toggle_music_box = music_box.toggle_music_box

local return_button = function()
	local widget = wibox.widget {
		{
			id = 'icon',
			image = widget_icon_dir .. 'music.svg',
			widget = wibox.widget.imagebox,
			resize = true
		},
		layout = wibox.layout.align.horizontal
	}

	local widget_button = wibox.widget {
		{
			widget,
			margins = dpi(7),
			widget = wibox.container.margin
		},
		widget = clickable_container
	}

	local music_tooltip =  awful.tooltip
	{
		objects = {widget_button},
		text = 'None',
		mode = 'outside',
		margin_leftright = dpi(8),
		margin_topbottom = dpi(8),
		align = 'right',
		preferred_positions = {'right', 'left', 'top', 'bottom'}
	}

	widget_button:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					music_tooltip.visible = false
					awesome.emit_signal('widget::music', 'mouse')
				end
			)
		)
	)

	widget_button:connect_signal(
		"mouse::enter", 
		function() 
			awful.spawn.easy_async_with_shell(
				'mpc status',
				function(stdout) 
				music_tooltip.text = string.gsub(stdout, '\n$', '')
				end
			)
		end
	)


	return widget_button

end

return return_button
