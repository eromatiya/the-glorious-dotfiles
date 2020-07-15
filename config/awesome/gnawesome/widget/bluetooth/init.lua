local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local naughty = require('naughty')
local watch = awful.widget.watch
local dpi = require('beautiful').xresources.apply_dpi

local apps = require('configuration.apps')

local clickable_container = require('widget.clickable-container')

local config_dir = gears.filesystem.get_configuration_dir()

local widget_icon_dir = config_dir .. 'widget/bluetooth/icons/'

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

	local bluetooth_tooltip = awful.tooltip
	{
		objects = {widget_button},
		mode = 'outside',
		align = 'right',
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
				bluetooth_tooltip.markup = 'Bluetooth is off'
			else
				widget_icon_name = 'bluetooth'
				bluetooth_tooltip.markup = 'Bluetooth is on'
			end
			widget.icon:set_image(widget_icon_dir .. widget_icon_name .. '.svg')
			collectgarbage('collect')
		end,
		widget
	)

	return widget_button

end

return return_button