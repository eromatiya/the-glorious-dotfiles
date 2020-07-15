local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local watch = awful.widget.watch
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widget.airplane-mode.clickable-container')
local config_dir = gears.filesystem.get_configuration_dir()
local widget_dir = config_dir .. 'widget/airplane-mode/'
local widget_icon_dir = widget_dir .. 'icons/'
local icons = require('theme.icons')
local ap_state = false

local action_name = wibox.widget {
	text = 'Airplane Mode',
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

local update_imagebox = function()
	if ap_state then
		button_widget.icon:set_image(icons.toggled_on)
	else
		button_widget.icon:set_image(icons.toggled_off)
	end
end

local check_airplane_mode_state = function()

	local cmd = 'cat ' .. widget_dir .. 'airplane_mode'

	awful.spawn.easy_async_with_shell(
		cmd, 
		function(stdout)
			local status = stdout
			
			if status:match("true") then
				ap_state = true
			elseif status:match("false") then
				ap_state = false
			else
				ap_state = false
				awful.spawn.easy_async_with_shell(
					'echo "false" > ' .. widget_dir .. 'airplane_mode', 
					function(stdout)
					end
				)
			end
			
			update_imagebox()
		end
	)
end

check_airplane_mode_state()

local ap_off_cmd = [[
	
	rfkill unblock wlan

	# Create an AwesomeWM Notification
	awesome-client "
	naughty = require('naughty')
	naughty.notification({
		app_name = 'Network Manager',
		title = '<b>Airplane mode disabled!</b>',
		message = 'Initializing network devices',
		icon = ']] .. widget_icon_dir .. 'airplane-mode-off' .. '.svg' .. [['
	})
	"
	]] .. "echo false > " .. widget_dir .. "airplane_mode" .. [[
]]

local ap_on_cmd = [[

	rfkill block wlan

	# Create an AwesomeWM Notification
	awesome-client "
	naughty = require('naughty')
	naughty.notification({
		app_name = 'Network Manager',
		title = '<b>Airplane mode enabled!</b>',
		message = 'Disabling radio devices',
		icon = ']] .. widget_icon_dir .. 'airplane-mode' .. '.svg' .. [['
	})
	"
	]] .. "echo true > " .. widget_dir .. "airplane_mode" .. [[
]]


local toggle_action = function()
	if ap_state then
		awful.spawn.easy_async_with_shell(
			ap_off_cmd, 
			function(stdout) 
				ap_state = false
				update_imagebox()
			end
		)
	else
		awful.spawn.easy_async_with_shell(
			ap_on_cmd,
			function(stdout)
				ap_state = true
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

gears.timer {
	timeout = 5,
	autostart = true,
	callback  = function()
		check_airplane_mode_state()
	end
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

return action_widget
