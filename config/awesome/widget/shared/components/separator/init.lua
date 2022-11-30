local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local separator = { orientation = "horizontal" }
function separator:new(orientation)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.widget = wibox.widget({
		orientation = orientation or o.orientation,
		forced_height = dpi(1),
		forced_width = dpi(1),
		span_ratio = 0.55,
		widget = wibox.widget.separator,
	})
	return o
end
---@param orientation "horizontal" | "vertical'
function separator:set_orientation(orientation)
	self.widget.orientation = orientation
end
return separator
