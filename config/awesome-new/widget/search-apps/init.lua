local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local filesystem = gears.filesystem
local config_dir = filesystem.get_configuration_dir()
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widget.clickable-container')
local widget_icon_dir = config_dir .. '/widget/search-apps/icons/'
local apps = require('configuration.apps')

local return_button = function()

	local widget = wibox.widget {
		{
			id = 'icon',
			image = widget_icon_dir .. 'app-launcher.svg',
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

	widget_button:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					awful.spawn(apps.default.rofi_appmenu, false)
				end
			)
		)
	)

	return widget_button
end

return return_button