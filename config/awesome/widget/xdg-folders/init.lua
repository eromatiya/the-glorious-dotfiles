local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local settings = require("widget.xdg-folders.settings")
local create_xdg_widgets = function()
	local separator = wibox.widget({
		orientation = settings[THEME].orientation,
		forced_height = dpi(1),
		forced_width = dpi(1),
		span_ratio = 0.55,
		widget = wibox.widget.separator,
	})

	return wibox.widget({
		layout = settings[THEME].layout_align,
		{
			separator,
			require("widget.xdg-folders.home")(),
			require("widget.xdg-folders.documents")(),
			require("widget.xdg-folders.downloads")(),
			-- require('widget.xdg-folders.pictures')(),
			-- require("widget.xdg-folders.videos")(),
			separator,
			require("widget.xdg-folders.trash")(),
			layout = settings[THEME].layout_fixed,
		},
	})
end

return create_xdg_widgets
