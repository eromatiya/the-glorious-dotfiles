-------------------------------------------------
-- Bluetooth Widget for Awesome Window Manager
-- Shows the bluetooth status using the bluetoothctl command
-- Better with Blueman Manager
-------------------------------------------------

local awful = require('awful')
local gears = require('gears')
local naughty = require('naughty')
local wibox = require('wibox')

local watch = awful.widget.watch

local apps = require('configuration.apps')

local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi


local config_dir = gears.filesystem.get_configuration_dir()

local widget_icon_dir = config_dir .. 'widget/bluetooth/icons/'

local checker = nil


local return_button = function()

	local widget =
		wibox.widget {
		{
			id = 'icon',
			image = widget_icon_dir .. 'bluetooth-off' .. '.svg',
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
					awful.spawn(apps.default.bluetooth_manager, false)
				end
			)
		)
	)

	awful.tooltip
	{
		objects = {widget_button},
		mode = 'outside',
		align = 'right',
		timer_function = function()
			if checker then
				return 'Bluetooth is on'
			else
				return 'Bluetooth is off'
			end
		end,
		margin_leftright = dpi(8),
		margin_topbottom = dpi(8),
		preferred_positions = {'right', 'left', 'top', 'bottom'}
	}

	watch(
		'rfkill list bluetooth', 
		5,
		function(_, stdout)
			local widget_icon_name = nil
			if stdout:match('Soft blocked: yes') then
				widget_icon_name = 'bluetooth-off'
			else
				widget_icon_name = 'bluetooth'
			end

			widget.icon:set_image(widget_icon_dir .. widget_icon_name .. '.svg')

			collectgarbage('collect')
		end,
		widget
	)

	return widget_button

end

return return_button