local wibox = require("wibox")
local dirs = require("widget.mpd.content.directories")
	{
		id = "next",
		image = widget_icon_dir .. "next.svg",
		resize = true,
		opacity = 0.8,
		widget = wibox.widget.imagebox,
	},
	layout = wibox.layout.align.horizontal,
})
