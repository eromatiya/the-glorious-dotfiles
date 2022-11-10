local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local watch = awful.widget.watch
local dpi = beautiful.xresources.apply_dpi
local icon = {
	layout = wibox.layout.align.vertical,
	expand = "none",
	nil,
	{
		image = _,
		resize = true,
		widget = wibox.widget.imagebox,
	},
	nil,
}

---@param image_path string
---@param margins unknown
function icon:new(image_path, margins)
	local o = {}
	o.image = image_path
	setmetatable(o, self)
	self.__index = self
	local image_with_margins = {
		o,
		margins = margins or dpi(5),
		widget = wibox.container.margin,
	}
	local image_with_bkg = {
		image_with_margins,
		bg = beautiful.groups_bg,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
		end,
		widget = wibox.container.background,
	}
	return wibox.widget(image_with_bkg)
end

return icon
