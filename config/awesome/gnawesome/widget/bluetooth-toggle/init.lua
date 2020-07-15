local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local naughty = require('naughty')
local watch = awful.widget.watch
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widget.bluetooth-toggle.clickable-container')
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/bluetooth-toggle/icons/'
local icons = require('theme.icons')
local device_state = false

local action_name = wibox.widget {
	text = 'Bluetooth Connection',
	font = 'Inter Regular 11',
	align = 'left',
	widget = wibox.widget.textbox
}

local button_widget = wibox.widget {
	{
		id = 'icon',
		image = icons.toggled_off,
		widget = wibox.widget.imagebox,
		resize = true
	},
	layout = wibox.layout.align.horizontal
}

local widget_button = wibox.widget {
	{
		button_widget,
		top = dpi(7),
		bottom = dpi(7),
		widget = wibox.container.margin
	},
	widget = clickable_container
}

local action_widget =  wibox.widget {
	{
		action_name,
		nil,
		{
			widget_button,
			layout = wibox.layout.fixed.horizontal,
		},
		layout = wibox.layout.align.horizontal,
	},
	left = dpi(24),
	right = dpi(24),
	forced_height = dpi(48),
	widget = wibox.container.margin
}


local update_imagebox = function()
	if device_state then
		button_widget.icon:set_image(icons.toggled_on)
	else
		button_widget.icon:set_image(icons.toggled_off)
	end
end


local check_device_state = function()
	awful.spawn.easy_async_with_shell(
		'rfkill list bluetooth', 
		function(stdout)
			if stdout:match('Soft blocked: yes') then
				device_state = false
			else
				device_state = true
			end
			update_imagebox()
		end
	)
end

check_device_state()


local power_on_cmd = [[
	rfkill unblock bluetooth

	# Create an AwesomeWM Notification
	awesome-client "
	naughty = require('naughty')
	naughty.notification({
		app_name = 'Bluetooth Manager',
		title = 'System Notification',
		message = 'Initializing bluetooth device...',
		icon = ']] .. widget_icon_dir .. 'loading' .. '.svg' .. [['
	})
	"

	# Add a delay here so we can enable the bluetooth
	sleep 1
	
	bluetoothctl power on
]]

local power_off_cmd = [[
	bluetoothctl power off
	rfkill block bluetooth

	# Create an AwesomeWM Notification
	awesome-client "
	naughty = require('naughty')
	naughty.notification({
		app_name = 'Bluetooth Manager',
		title = 'System Notification',
		message = 'The bluetooth device has been disabled.',
		icon = ']] .. widget_icon_dir .. 'bluetooth-off' .. '.svg' .. [['
	})
	"
]]


local toggle_action = function()
	if device_state then
		device_state = false
		awful.spawn.easy_async_with_shell(
			power_off_cmd, 
			function(stdout)
				update_imagebox()
			end
		)
	else
		device_state = true
		awful.spawn.easy_async_with_shell(
			power_on_cmd, 
			function(stdout)
				update_imagebox()
			end
		)
	end
end


widget_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				toggle_action()
			end
		)
	)
)

watch(
	'rfkill list bluetooth', 
	5,
	function(_, stdout)
		check_device_state()
		collectgarbage('collect')
	end
)


return action_widget
