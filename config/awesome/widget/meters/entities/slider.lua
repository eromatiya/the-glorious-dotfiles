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
		forced_height = _,
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
local height_map = {
	floppy = dpi(2),
}
---@param id string
function slider:new(id)
	self[2].id = id
	self[2].forced_height = height_map[THEME] or dpi(24)
	return wibox.widget(self)
end

return slider
