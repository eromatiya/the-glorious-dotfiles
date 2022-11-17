local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local config_dir = gears.filesystem.get_configuration_dir()
local widget_dir = config_dir .. "widget/"
-- 🔧 TODO: move those into icons of this dir
local airplane_mode_icon_dir = widget_dir .. "airplane-mode/icons/"
local airplane_mode_off_icon = airplane_mode_icon_dir .. "airplane-mode-off.svg"
local airplane_mode_on_icon = airplane_mode_icon_dir .. "airplane-mode.svg"
local icons = require("widget.toggles.icons")

---@class toggle_widget_args
---@field name string
---@field toggle_on_callback function
---@field toggle_off_callback function
---@field toggle_on_icon string
---@field toggle_off_icon string

-- 🔧 TODO: add function that checks the initial state of wlan and sets the toggle properly
---@type toggle_widget_args
local airplane_mode = {
	name = "Airplane Mode",
	toggle_off_callback = function()
		awful.spawn.easy_async_with_shell("rfkill unblock wlan", function()
			naughty.notification({
				app_name = "Network Manager",
				title = "<b>Airplane mode disbaled!</b>",
				message = "Enabling radio devices",
				icon = airplane_mode_off_icon,
			})
		end)
	end,
	toggle_on_callback = function()
		awful.spawn.easy_async_with_shell("rfkill block wlan", function()
			naughty.notification({
				app_name = "Network Manager",
				title = "<b>Airplane mode enabled!</b>",
				message = "Disabling radio devices",
				icon = airplane_mode_on_icon,
			})
		end)
	end,
	toggle_on_icon = airplane_mode_on_icon,
	toggle_off_icon = airplane_mode_off_icon,
}

local bluetooth = {
	name = "Bluetooth",
	toggle_off_callback = function()
		awful.spawn.easy_async_with_shell("rfkill block bluetooth", function()
			naughty.notification({
				app_name = "Bluetooth Manager",
				title = "<b> System Notification</b>",
				message = "The bluetooth device has been disabled!",
				icon = icons.bluetooth.off,
			})
		end)
	end,
	toggle_on_callback = function()
		awful.spawn.easy_async_with_shell("rfkill block bluetooth", function()
			naughty.notification({
				app_name = "Bluetooth Manager",
				title = "<b> System Notification</b>",
				message = "The bluetooth device has been enabled!",
				icon = icons.bluetooth.on,
			})
		end)
	end,
	toggle_on_icon = icons.bluetooth.on,
	toggle_off_icon = icons.bluetooth.off,
}
---@alias toggle_widgets "airplane_mode" | "bluetooth"
---@type table<toggle_widgets, any>
local toggle_widgets = {
	airplane_mode = airplane_mode,
	bluetooth = bluetooth,
}
return toggle_widgets
