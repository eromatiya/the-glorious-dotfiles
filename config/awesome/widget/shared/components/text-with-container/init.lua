local text_class = require("widget.shared.components.regular-text")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")
local text_with_container = {
	text_widget = _,
	margins = dpi(5),
	bg = beautiful.groups_bg,
}
---@param text string |table
---@param margins any
function text_with_container:new(text, margins)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	if type(text) == table then
		---@param text table
		text = table.concat(text, ", ")
	end
	o.text_widget = text_class:new(text, _, _)
	local margin_widget = wibox.container.margin(o.text_widget.widget)
	margin_widget.margins = margins or o.margins
	o.widget = wibox.widget({
		layout = wibox.container.background,
		bg = o.bg,
		shape = gears.shape.rounded_rect,
	})
	return o.widget
end
return text_with_container
