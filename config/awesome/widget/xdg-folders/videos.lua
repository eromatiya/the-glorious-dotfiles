local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')

local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/xdg-folders/icons/'

local vid_widget =
	wibox.widget {
	{
		id = 'icon',
		widget = wibox.widget.imagebox,
		resize = true
	},
	layout = wibox.layout.align.horizontal
}

local videos_button = wibox.widget {
	{
		vid_widget,
		margins = dpi(10),
		widget = wibox.container.margin
	},
	widget = clickable_container
}

videos_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				awful.spawn({'xdg-open', HOME .. '/Videos'}, false)
			end
		)
	)
)

awful.tooltip
{
	objects = {videos_button},
	mode = 'outside',
	align = 'right',
	margin_leftright = dpi(8),
	margin_topbottom = dpi(8),
	timer_function = function()
		return 'Videos'
	end,
	preferred_positions = {'right', 'left', 'top', 'bottom'}
}

return videos_button
