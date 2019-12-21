local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')

local dpi = require('beautiful').xresources.apply_dpi

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/music/icons/'


-- Album Cover
album_cover_img =
wibox.widget {
	{
		id = 'cover',
		image = PATH_TO_ICONS .. 'vinyl' .. '.svg',
		resize = true,
		clip_shape = gears.shape.rounded_rect,
		widget = wibox.widget.imagebox,
	},
	layout = wibox.layout.fixed.vertical
}


return album_cover_img