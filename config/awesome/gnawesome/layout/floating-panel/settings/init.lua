local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi

local clickable_container = require('widget.clickable-container')
local icons = require('theme.icons')

return function(s)

	return wibox.widget {
		layout = wibox.layout.flex.horizontal,
		spacing = dpi(7),
		require('layout.floating-panel.settings.hardware-monitor'),
		require('layout.floating-panel.settings.quick-settings'),
	}
end
