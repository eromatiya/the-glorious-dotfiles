local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')

local watch = awful.widget.watch

local dpi = require('beautiful').xresources.apply_dpi

local clickable_container = require('widget.wifi.clickable-container')

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/wifi/icons/'

local icons = require('theme.icons')

local wifi_state = false



local action_name = wibox.widget {
	text = 'Wireless Connection',
	font = 'SF Pro Text Regular 11',
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

local update_imagebox = function()
	if wifi_state then
		button_widget.icon:set_image(icons.toggled_on)
	else
		button_widget.icon:set_image(icons.toggled_off)
	end
end

local check_device_state = function()

	awful.spawn.easy_async_with_shell(
		'rfkill list wlan', 
		function(stdout)
			if stdout:match('Soft blocked: yes') then
				wifi_state = false
			else
				wifi_state = true
			end
		
			update_imagebox()
		end
	)
end

check_device_state()


local power_on_cmd = [[
	
	rfkill unblock wlan

	# Create an AwesomeWM Notification
	awesome-client "
	naughty = require('naughty')
	naughty.notification({
		app_name = 'WiFi Manager',
		title = 'System Notification',
		message = 'Initializing WiFi device...',
		icon = ']] .. widget_icon_dir .. 'loading' .. '.svg' .. [['
	})
	"
]]

local power_off_cmd = [[

	rfkill block wlan

	# Create an AwesomeWM Notification
	awesome-client "
	naughty = require('naughty')
	naughty.notification({
		app_name = 'WiFi Manager',
		title = 'System Notification',
		message = 'The WiFi device has been disabled.',
		icon = ']] .. widget_icon_dir .. 'wifi-off' .. '.svg' .. [['
	})
	"
]]


local toggle_action = function()
	if wifi_state then
		wifi_state = false
		awful.spawn.easy_async_with_shell(
			power_off_cmd, 
			function(stdout) end
		)
	else
		wifi_state = true
		awful.spawn.easy_async_with_shell(
			power_on_cmd,
			function(stdout) end
		)
	end
	update_imagebox()
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
	'rfkill list wlan', 
	5,
	function(_, stdout)
		check_device_state()
		collectgarbage('collect')
	end
)


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


return action_widget
