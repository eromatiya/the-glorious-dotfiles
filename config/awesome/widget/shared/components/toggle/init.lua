local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local icons = require("theme.icons")
local icon = require("widget.shared.components.icon")
local clickable_container = require("widget.clickable-container")

---@class toggle_comp
---@field wibox_widget unknown
---@field toggle_on boolean
---@field toggle_on_callback function
---@field toggle_off_callback function
---@field toggle_on_icon unknown
---@field toggle_off_icon unknown
local toggle = {
	widget_params = {
		{
			id = "icon",
			widget = wibox.widget.imagebox,
			image = icons.toggled_off,
			resize = true,
		},
		margins = dpi(5),
		widget = wibox.container.margin,
	},
	toggle_on = false,
	toggle_on_icon = icons.toggled_on,
	toggle_off_icon = icons.toggled_off,
}

---@param toggle_on_callback function
---@param toggle_off_callback function
function toggle:new(toggle_on_callback, toggle_off_callback)
	local o = {}
	o.toggle_on_callback = toggle_on_callback or function() end
	o.toggle_off_callback = toggle_off_callback or function() end
	self.__index = self
	setmetatable(o, self)
	o.wibox_widget = wibox.widget(o.widget_params)
	o.wibox_widget:buttons(gears.table.join(awful.button({}, 1, nil, function()
		o:toggle()
	end)))
	return o.wibox_widget
end
function toggle:toggle()
	local wibox_widget = self.wibox_widget
	if not self.toggle_on then
		wibox_widget.icon:set_image(self.toggle_on_icon)
		self.toggle_on_callback()
	else
		wibox_widget.icon:set_image(self.toggle_off_icon)
		self.toggle_off_callback()
	end
	self.toggle_on = not self.toggle_on
end
return toggle
