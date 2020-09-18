local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widget.clickable-container')

local apps = require('configuration.apps')
local icons = require('theme.icons')

local return_button = function()

	local widget = wibox.widget {
		{
			id = 'icon',
			image = icons.search,
			resize = true,
			widget = wibox.widget.imagebox
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

	widget_button:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					awful.spawn(apps.default.rofi_global, false)
				end
			)
		)
	)

	return widget_button
end

return return_button
