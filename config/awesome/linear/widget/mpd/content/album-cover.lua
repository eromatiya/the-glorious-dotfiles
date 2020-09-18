local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/mpd/icons/'

local album_cover_img = wibox.widget {
	{
		id = 'cover',
		image = widget_icon_dir .. 'vinyl.svg',
		resize = true,
		clip_shape = gears.shape.rounded_rect,
		widget = wibox.widget.imagebox,
	},
	layout = wibox.layout.fixed.vertical
}


return album_cover_img