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
local scripts = require("widget.toggles.scripts")

---@class toggle_widget_args
---@field name string
---@field toggle_on_callback function
---@field toggle_off_callback function
---@field toggle_on_icon string
---@field toggle_off_icon string
---@field watch_script table | string | nil

-- 🔧 TODO: add function that checks the initial state of wlan and sets the toggle properly
---@type toggle_widget_args
local airplane_mode = {
	name = "Airplane Mode",
	toggle_off_callback = function()
		awful.spawn.easy_async_with_shell(scripts.airplane_mode.toggle_off_script, function()
			naughty.notification({
				app_name = "Network Manager",
				title = "<b>Airplane mode disbaled!</b>",
				message = "Enabling radio devices",
				icon = airplane_mode_off_icon,
			})
		end)
	end,
	toggle_on_callback = function()
		awful.spawn.easy_async_with_shell(scripts.airplane_mode.toggle_on_script, function()
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
	watch_script = scripts.airplane_mode.watch_script,
}

---@type toggle_widget_args
local bluetooth = {
	name = "Bluetooth",
	toggle_off_callback = function()
		awful.spawn.easy_async_with_shell(scripts.bluetooth.toggle_off_script, function()
			naughty.notification({
				app_name = "Bluetooth Manager",
				title = "<b> System Notification</b>",
				message = "The bluetooth device has been disabled!",
				icon = icons.bluetooth.off,
			})
		end)
	end,
	toggle_on_callback = function()
		awful.spawn.easy_async_with_shell(scripts.bluetooth.toggle_on_script, function()
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
	watch_script = scripts.bluetooth.watch_script,
}

---@type toggle_widget_args
local blue_light = {
	name = "Blue Light",
	toggle_off_callback = function()
		awful.spawn.easy_async_with_shell(scripts.blue_light.toggle_off_script, function()
			naughty.notification({
				app_name = "Blue Light Manager",
				title = "<b> System Notification</b>",
				message = "Blue light has been disabled!",
				icon = icons.blue_light.off,
			})
		end)
	end,
	toggle_on_callback = function()
		awful.spawn.easy_async_with_shell(scripts.blue_light.toggle_on_script, function()
			naughty.notification({
				app_name = "Blue Light Manager",
				title = "<b> System Notification</b>",
				message = "Blue light has been enabled!",
				icon = icons.blue_light.on,
			})
		end)
	end,
	toggle_on_icon = icons.blue_light.on,
	toggle_off_icon = icons.blue_light.off,
	watch_script = scripts.blue_light.watch_script,
}
---@type toggle_widget_args
local blur_effects = {
	name = "Blur Effects",
	toggle_off_callback = function()
		awful.spawn.easy_async_with_shell(scripts.blue_light.toggle_off_script, function()
			naughty.notification({
				app_name = "Blue Light Manager",
				title = "<b> System Notification</b>",
				message = "Blue light has been disabled!",
				icon = icons.blue_light.off,
			})
		end)
	end,
	toggle_on_callback = function()
		awful.spawn.easy_async_with_shell(scripts.blue_light.toggle_on_script, function()
			naughty.notification({
				app_name = "Blue Light Manager",
				title = "<b> System Notification</b>",
				message = "Blue light has been enabled!",
				icon = icons.blue_light.on,
			})
		end)
	end,
	toggle_on_icon = icons.blue_light.on,
	toggle_off_icon = icons.blue_light.off,
	watch_script = scripts.blue_light.watch_script,
}
---@alias toggle_widgets "airplane_mode" | "blue_light" |"bluetooth"
---@type table<toggle_widgets, any>
local toggle_widgets = {
	airplane_mode = airplane_mode,
	bluetooth = bluetooth,
	blue_light = blue_light,
}
return toggle_widgets
