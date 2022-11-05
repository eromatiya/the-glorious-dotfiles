local wibox = require("wibox")
---@type {floppy: widgetPositioning, default: widgetPositioning}
local settings = {
	floppy = {
		orientation = "horizontal",
		layout_align = wibox.layout.align.vertical,
		layout_fixed = wibox.layout.fixed.vertical,
	},
	default = {
		orientation = "vertical",
		layout_align = wibox.layout.align.horizontal,
		layout_fixed = wibox.layout.fixed.horizontal,
	},
}
local mt = {
	__index = function()
		return settings.default
	end,
}
setmetatable(settings, mt)
return settings
