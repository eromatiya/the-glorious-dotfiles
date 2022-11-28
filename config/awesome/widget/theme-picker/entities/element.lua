local name_class = require("widget.shared.components.name")
local regular_text = require("widget.shared.components.regular-text")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")
local element = {
	margin = dpi(5),
	bg = beautiful.groups_bg,
	fg = beautiful.fg_modal,
	border_width = dpi(1),
	border_color = beautiful.border_modal,
	spacing = dpi(5),
}
---@param name string
---@param description string
function element:new(name, description)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.name_widget = name_class:new(name, _, _)
	o.description_widget = regular_text:new(description or "N/A", _, _)
	local layout_widget = wibox.widget({
		o.name_widget,
		nil,
		o.description_widget,
		layout = wibox.layout.flex.horizontal,
		spacing = o.spacing,
	})
	local margin_widget = wibox.container.margin(layout_widget)
	margin_widget.margins = o.margin
	local background_widget = wibox.container.background(margin_widget, o.bg, gears.shape.rounded_rect)
	return background_widget
end
return element
