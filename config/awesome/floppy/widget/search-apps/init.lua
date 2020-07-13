-------------------------------------------------
-- Rofi toggler widget for Awesome Window Manager
-- Shows the application list
-- Use rofi-git master branch
-------------------------------------------------

local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')

local filesystem = gears.filesystem
local dpi = require('beautiful').xresources.apply_dpi

local apps = require('configuration.apps')
local clickable_container = require('widget.clickable-container')

local config_dir = filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. '/widget/search-apps/icons/'

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
			margins = dpi(10),
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
		            local focused = awful.screen.focused()

		            if focused.left_panel then
		                focused.left_panel:HideDashboard()
		                focused.left_panel.opened = false
		            end
		            if focused.right_panel then
		                focused.right_panel:HideDashboard()
		            end
					awful.spawn(apps.default.rofiappmenu, false)
				end
			)
		)
	)


	return widget_button
end

return return_button