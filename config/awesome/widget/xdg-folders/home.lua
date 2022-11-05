local wibox = require('wibox')
local awful = require('awful')
local naughty = require('naughty')
local gears = require('gears')

local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/xdg-folders/icons/'

local create_widget = function()
	local home_widget =	wibox.widget {
		{
			image = widget_icon_dir .. 'user-home.svg',
			resize = true,
			widget = wibox.widget.imagebox,
		},
		layout = wibox.layout.align.horizontal
	}

	local home_button = wibox.widget {
		{
			home_widget,
			margins = dpi(10),
			widget = wibox.container.margin
		},
		widget = clickable_container
	}

	home_button:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					awful.spawn.with_shell('xdg-open $(xdg-user-dir)')
				end
			)
		)
	)

	awful.tooltip(
		{
			objects = {home_button},
			mode = 'outside',
			align = 'right',
			text = 'Home',
			margin_leftright = dpi(8),
			margin_topbottom = dpi(8),    
			preferred_positions = {'top', 'bottom', 'right', 'left'}
		}
	)

	return home_button
end

return create_widget
