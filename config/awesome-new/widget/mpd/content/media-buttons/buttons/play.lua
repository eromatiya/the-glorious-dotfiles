local wibox = require("wibox")
local dirs = require("widget.mpd.content.directories")
return wibox.widget({
	{
		id = "play",
		image = dirs.icons .. "play.svg",
		resize = true,
		opacity = 0.8,
		widget = wibox.widget.imagebox,
	},
	layout = wibox.layout.align.horizontal,
})
