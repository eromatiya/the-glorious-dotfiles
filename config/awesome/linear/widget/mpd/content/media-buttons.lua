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
		widget = wibox.widget.imagebox
	},
	layout = wibox.layout.align.horizontal
}

media_buttons.next_button_image = wibox.widget {
	{
		id = 'next',
		image = widget_icon_dir .. 'next.svg',
		resize = true,
		widget = wibox.widget.imagebox
	},
	layout = wibox.layout.align.horizontal
}

media_buttons.prev_button_image = wibox.widget {
	{
		id = 'prev',
		image = widget_icon_dir .. 'prev.svg',
		resize = true,
		widget = wibox.widget.imagebox
	},
	layout = wibox.layout.align.horizontal
}

media_buttons.repeat_button_image = wibox.widget {
	{
		id = 'rep',
		image = widget_icon_dir .. 'repeat-on.svg',
		resize = true,
		widget = wibox.widget.imagebox
	},
	layout = wibox.layout.align.horizontal
}

media_buttons.random_button_image = wibox.widget {
	{
		id = 'rand',
		image = widget_icon_dir .. 'random-on.svg',
		resize = true,
		widget = wibox.widget.imagebox
	},
	layout = wibox.layout.align.horizontal
}

media_buttons.play_button = wibox.widget {
	{
		media_buttons.play_button_image,
		margins = dpi(7),
		widget = wibox.container.margin
	},
	widget = clickable_container
}

media_buttons.next_button = wibox.widget {
	{
		media_buttons.next_button_image,
		margins = dpi(10),
		widget = wibox.container.margin
	},
	widget = clickable_container
}

media_buttons.prev_button = wibox.widget {
	{
		media_buttons.prev_button_image,
		margins = dpi(10),
		widget = wibox.container.margin
	},
	widget = clickable_container
}

media_buttons.repeat_button = wibox.widget {
	{
		media_buttons.repeat_button_image,
		margins = dpi(10),
		widget = wibox.container.margin
	},
	widget = clickable_container
}

media_buttons.random_button = wibox.widget {
	{
		media_buttons.random_button_image,
		margins = dpi(10),
		widget = wibox.container.margin
	},
	widget = clickable_container
}

media_buttons.navigate_buttons = wibox.widget {
	expand = 'none',
	layout = wibox.layout.align.horizontal,
	media_buttons.repeat_button,
	{
		layout = wibox.layout.fixed.horizontal,
		media_buttons.prev_button,
		media_buttons.play_button,
		media_buttons.next_button,
		forced_height = dpi(35),
	},
	media_buttons.random_button,
	forced_height = dpi(35),
}

return media_buttons