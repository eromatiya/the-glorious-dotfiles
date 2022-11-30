local name_class = require("widget.shared.components.name")
local regular_text = require("widget.shared.components.regular-text")
local setter = require("widget.theme-setter")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local awful = require("awful")
local gears = require("gears")
local element = {
	margin = dpi(5),
	bg = beautiful.groups_bg,
	selected_bg = "#FFFFFF",
	fg = beautiful.fg_modal,
	selected_fg = "#000000",
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
	o.name = name
	o.name_widget = name_class:new(o.name, _, _)
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
	o.widget = wibox.container.background(margin_widget, o.bg, _)
	o:register_events()
	o.widget:buttons(gears.table.join(awful.button({}, 1, nil, function()
		o:confirm()
	end)))

	return o
end
function element:confirm()
	setter:set(string.lower(self.name))
	-- TODO: do this for screen if possible
	-- local w = mouse.current_wibox
	-- self.widget.cursor = "watch"
	awful.spawn.with_shell("awesome-client 'awesome.restart()'")
end
function element:select()
	self.widget.bg = self.selected_bg
	self.widget.fg = self.selected_fg
end
function element:deselect()
	self.widget.bg = self.bg
	self.widget.fg = self.fg
end
function element:register_events()
	self.widget:connect_signal("mouse::enter", function()
		self:select()
	end)
	self.widget:connect_signal("mouse::leave", function()
		self:deselect()
	end)
end

return element
