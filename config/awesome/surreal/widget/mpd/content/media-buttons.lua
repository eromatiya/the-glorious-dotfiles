local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widget.clickable-container')
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/mpd/icons/'
local media_buttons = {}

media_buttons.play_button_image = wibox.widget {
	{
		id = 'play',
		image = widget_icon_dir .. 'play.svg',
		resize = true,
		opacity = 0.8,
		widget = wibox.widget.imagebox
	},
	layout = wibox.layout.align.horizontal
}

media_buttons.next_button_image = wibox.widget {
	{
		id = 'next',
		image = widget_icon_dir .. 'next.svg',
		resize = true,
		opacity = 0.8,
		widget = wibox.widget.imagebox
	},
	layout = wibox.layout.align.horizontal
}

media_buttons.prev_button_image = wibox.widget {
	{
		id = 'prev',
		image = widget_icon_dir .. 'prev.svg',
		resize = true,
		opacity = 0.8,
		widget = wibox.widget.imagebox
	},
	layout = wibox.layout.align.horizontal
}

media_buttons.play_button = wibox.widget {
	{
		{
			media_buttons.play_button_image,
			margins = dpi(7),
			widget = wibox.container.margin
		},
		widget = clickable_container
	},
	forced_width = dpi(36),
	forced_height = dpi(36),
	bg = beautiful.transparent,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
	end,
	widget = wibox.container.background
}

media_buttons.next_button = wibox.widget {
	{
		{
			media_buttons.next_button_image,
			margins = dpi(10),
			widget = wibox.container.margin
		},
		widget = clickable_container
	},
	forced_width = dpi(36),
	forced_height = dpi(36),
	bg = beautiful.transparent,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
	end,
	widget = wibox.container.background
}

media_buttons.prev_button = wibox.widget {
	{
		{
			media_buttons.prev_button_image,
			margins = dpi(10),
			widget = wibox.container.margin
		},
		widget = clickable_container
	},
	forced_width = dpi(36),
	forced_height = dpi(36),
	bg = beautiful.transparent,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
	end,
	widget = wibox.container.background
}

media_buttons.navigate_buttons = wibox.widget {
	layout = wibox.layout.fixed.horizontal,
	media_buttons.prev_button,
	media_buttons.play_button,
	media_buttons.next_button
}

return media_buttons
