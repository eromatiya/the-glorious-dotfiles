local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')

local dpi = beautiful.xresources.apply_dpi

local clickable_container = require('widget.clickable-container')

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/music/icons/'


local media_buttons = {}


play_button_image = wibox.widget {
	{
		id = 'play',
		image = widget_icon_dir .. 'play' .. '.svg',
		resize = true,
		widget = wibox.widget.imagebox
	},
	layout = wibox.layout.align.horizontal
}


local next_button_image = wibox.widget {
	{
		id = 'next',
		image = widget_icon_dir .. 'next' .. '.svg',
		resize = true,
		widget = wibox.widget.imagebox
	},
	layout = wibox.layout.align.horizontal
}


local prev_button_image = wibox.widget {
	{
		id = 'prev',
		image = widget_icon_dir .. 'prev' .. '.svg',
		resize = true,
		widget = wibox.widget.imagebox
	},
	layout = wibox.layout.align.horizontal
}


repeat_button_image = wibox.widget {
	{
		id = 'rep',
		image = widget_icon_dir .. 'repeat-on' .. '.svg',
		resize = true,
		widget = wibox.widget.imagebox
	},
	layout = wibox.layout.align.horizontal
}


random_button_image = wibox.widget {
	{
		id = 'rand',
		image = widget_icon_dir .. 'random-on' .. '.svg',
		resize = true,
		widget = wibox.widget.imagebox
	},
	layout = wibox.layout.align.horizontal
}


play_button = wibox.widget {
	{
		play_button_image,
		margins = dpi(7),
		widget = wibox.container.margin
	},
	widget = clickable_container
}


next_button = wibox.widget {
	{
		next_button_image,
		margins = dpi(10),
		widget = wibox.container.margin
	},
	widget = clickable_container
}


prev_button = wibox.widget {
	{
		prev_button_image,
		margins = dpi(10),
		widget = wibox.container.margin
	},
	widget = clickable_container
}


repeat_button = wibox.widget {
	{
		repeat_button_image,
		margins = dpi(10),
		widget = wibox.container.margin
	},
	widget = clickable_container
}


random_button = wibox.widget {
	{
		random_button_image,
		margins = dpi(10),
		widget = wibox.container.margin
	},
	widget = clickable_container
}


navigate_buttons = wibox.widget {
	expand = 'none',
	layout = wibox.layout.align.horizontal,
	repeat_button,
	{
		layout = wibox.layout.fixed.horizontal,
		prev_button,
		play_button,
		next_button,
		forced_height = dpi(35),
	},
	random_button,
	forced_height = dpi(35),
}


media_buttons.play_button_image = play_button_image
media_buttons.play_button = play_button
media_buttons.next_button = next_button
media_buttons.prev_button = prev_button
media_buttons.repeat_button_image = repeat_button_image
media_buttons.repeat_button = repeat_button
media_buttons.random_button_image = random_button_image
media_buttons.random_button = random_button

media_buttons.navigate_buttons = navigate_buttons

return media_buttons