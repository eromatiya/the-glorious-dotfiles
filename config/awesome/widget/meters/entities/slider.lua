local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local slider = {
	nil,
	{
		id = "",
		max_value = 100,
		value = 0,
		forced_height = dpi(24),
		color = "#f2f2f2EE",
		background_color = "#ffffff20",
		shape = gears.shape.rounded_rect,
		widget = wibox.widget.progressbar,
	},
	nil,
	expand = "none",
	forced_height = dpi(36),
	layout = wibox.layout.align.vertical,
}
---@param id string
---@param height number
function slider:new(id, height)
	self[1][1].id = id
	self[1][1].forced_height = height
end
return slider
