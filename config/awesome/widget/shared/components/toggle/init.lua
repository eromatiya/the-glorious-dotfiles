local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local icons = require("theme.icons")
local icon = require("widget.shared.components.icon")
local clickable_container = require("widget.clickable-container")

local toggle = {
	widget_params = {
		{
			id = "icon",
			widget = wibox.widget.imagebox,
			image = icons.toggled_off,
			-- layout = wibox.layout.align.horizontal,
			resize = true,
		},
		margins = dpi(97),
		widget = wibox.container.margin,
	},
	toggle_on = false,
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
		wibox_widget.icon:set_image(icons.toggled_on)
		self.toggle_on_callback()
	else
		wibox_widget.icon:set_image(icons.toggled_off)
		self.toggle_on_callback()
	end
	self.toggle_on = not self.toggle_on
end
return toggle
