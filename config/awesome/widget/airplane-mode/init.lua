local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local watch = awful.widget.watch
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require("widget.clickable-container")
local config_dir = gears.filesystem.get_configuration_dir()
local widget_dir = config_dir .. "widget/airplane-mode/"
local widget_icon_dir = widget_dir .. "icons/"
local icons = require("theme.icons")
local toggle_component = require("widget.shared.components.toggle")
local circular_toggle_component = require("widget.shared.components.circular_toggle")
local ap_state = false
local naughty = require("naughty")
local airplane_mode_off_icon = widget_icon_dir .. "airplane-mode-off.svg"
local airplane_mode_on_icon = widget_icon_dir .. "airplane-mode.svg"
local toggles = require("widget.toggles")

local ap_off_cmd = [[
	rfkill unblock wlan
]]

local ap_on_cmd = [[
	rfkill block wlan
]]
local ap_off_callback = function()
	awful.spawn.easy_async_with_shell(ap_off_cmd, function()
		naughty.notification({
			app_name = "Network Manager",
			title = "<b>Airplane mode disabled!</b>",
			message = "Enabling radio devices",
			icon = airplane_mode_off_icon,
		})
	end)
end
local ap_on_callback = function()
	awful.spawn.easy_async_with_shell(ap_on_cmd, function()
		naughty.notification({
			app_name = "Network Manager",
			title = "<b>Airplane mode enabled!</b>",
			message = "Disabling radio devices",
			icon = airplane_mode_on_icon,
		})
	end)
end

local action_name = wibox.widget({
	text = "Airplane Mode",
	font = "Inter Bold 10",
	align = "left",
	widget = wibox.widget.textbox,
})

local action_status = wibox.widget({
	text = "Off",
	font = "Inter Regular 10",
	align = "left",
	widget = wibox.widget.textbox,
})

local action_info = wibox.widget({
	layout = wibox.layout.fixed.vertical,
	action_name,
	action_status,
})

local button_widget = wibox.widget({
	{
		{
			id = "icon",
			image = widget_icon_dir .. "airplane-mode-off.svg",
			widget = wibox.widget.imagebox,
			resize = true,
		},
		layout = wibox.layout.align.horizontal,
	},
	margins = dpi(15),
	forced_height = dpi(48),
	forced_width = dpi(48),
	widget = wibox.container.margin,
})
local icon_map = {
	floppy = wibox.widget({
		id = "icon",
		image = icons.toggled_off,
		widget = wibox.widget.imagebox,
		resize = true,
	}),
	default = wibox.widget({
		id = "icon",
		image = widget_icon_dir .. "airplane-mode-off.svg",
		widget = wibox.widget.imagebox,
		resize = true,
	}),
}
local icon = icon_map[THEME] or icon_map.default
local toggle_widget = wibox.widget({
	{
		icon,
		layout = wibox.layout.align.horizontal,
	},
	top = dpi(7),
	bottom = dpi(7),
	widget = wibox.container.margin,
})
local button_theme_map = {
	floppy = toggle_component:new(ap_on_callback, ap_off_callback),
	default = circular_toggle_component:new(
		airplane_mode_on_icon,
		airplane_mode_off_icon,
		ap_on_callback,
		ap_off_callback
	),
}

local widget_button = wibox.widget({
	{
		button_theme_map[THEME] or button_theme_map.default,
		widget = clickable_container,
	},
	bg = beautiful.groups_bg,
	shape = gears.shape.circle,
	widget = wibox.container.background,
})
-- 🔧 refactor this 

local check_airplane_mode_state = function()
	local cmd = "cat " .. widget_dir .. "airplane_mode"

	awful.spawn.easy_async_with_shell(cmd, function(stdout)
		local status = stdout

		if status:match("true") then
			ap_state = true
		elseif status:match("false") then
			ap_state = false
		else
			ap_state = false
			awful.spawn.easy_async_with_shell('echo "false" > ' .. widget_dir .. "airplane_mode", function(stdout) end)
		end
	end)
end

check_airplane_mode_state()

-- TODO: what?
gears.timer({
	timeout = 5,
	autostart = true,
	callback = function()
		check_airplane_mode_state()
	end,
})

local action_widget = wibox.widget({
	layout = wibox.layout.fixed.horizontal,
	spacing = dpi(10),
	widget_button,
	{
		layout = wibox.layout.align.vertical,
		expand = "none",
		nil,
		action_info,
		nil,
	},
})
local toggle_action_widget = wibox.widget({
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
	widget = wibox.container.margin,
})

local action_widget_map = {
	floppy = toggle_action_widget,
}
-- return action_widget_map[THEME] or action_widget
return toggles.airplane_mode
