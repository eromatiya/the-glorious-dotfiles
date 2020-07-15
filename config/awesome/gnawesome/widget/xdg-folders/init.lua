local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi

local create_xdg_widgets = function()
	local separator =  wibox.widget {
		orientation = 'vertical',
		forced_height = dpi(1),
		forced_width = dpi(1),
		span_ratio = 0.55,
		widget = wibox.widget.separator
	}

	return wibox.widget {
		layout = wibox.layout.align.horizontal,
	  	{
			separator,
			require('widget.xdg-folders.home')(),
			require('widget.xdg-folders.documents')(),
			require('widget.xdg-folders.downloads')(),
			-- require('widget.xdg-folders.pictures')(),
			-- require('widget.xdg-folders.videos')(),
			separator,
			-- require('widget.xdg-folders.trash')(),
			layout = wibox.layout.fixed.horizontal
	  	},
	}
end

return create_xdg_widgets
