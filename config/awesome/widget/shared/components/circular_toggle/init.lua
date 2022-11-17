local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local icons = require("theme.icons")
local icon = require("widget.shared.components.icon")
local name = require("widget.shared.components.name")
local clickable_container = require("widget.clickable-container")

---@class circular_toggle
---@field wibox_widget unknown
---@field toggle_on boolean
---@field toggle_on_callback function
---@field toggle_off_callback function
---@field toggled_on_icon unknown
---@field toggled_off_icon unknown
---@field icon_widget unknown
local toggle = {
	widget_params = {
		{
			margins = dpi(15),
			forced_height = dpi(48),
			forced_width = dpi(48),
			widget = wibox.container.margin,
		},
		bg = beautiful.groups_bg,
		shape = gears.shape.circle,
		widget = wibox.container.background,
	},
	toggle_on = false,
	status_widget = wibox.widget({
		layout = wibox.layout.align.vertical,
		expand = "none",
		nil,
		{
			id = "name",
			text = "Off",
			font = "Inter Bold 10",
			align = "left",
			widget = wibox.widget.textbox,
		},
		nil,
	}),
	icon_widget = wibox.widget({
		id = "icon",
		image = _,
		widget = wibox.widget.imagebox,
		resize = true,
	}),
}

---@param toggle_on_icon string
---@param toggle_off_icon string
---@param toggle_on_callback function
---@param toggle_off_callback function
function toggle:new(toggle_on_icon, toggle_off_icon, toggle_on_callback, toggle_off_callback)
	---@type circular_toggle
	local o = {}

	o.toggle_on_callback = toggle_on_callback or function() end
	o.toggle_off_callback = toggle_off_callback or function() end
	o.toggled_on_icon = toggle_on_icon or icons.toggled_on
	o.toggled_off_icon = toggle_off_icon or icons.toggled_off

	self.__index = self
	setmetatable(o, self)
	-- icon
	o.icon_widget:set_image(toggle_off_icon)
	-- layout
	local layout_widget = wibox.layout.fixed.horizontal()
	layout_widget:add(o.icon_widget)
	-- adding icon margins and bg
	table.insert(o.widget_params[1], layout_widget)
	o.wibox_widget = wibox.widget(o.widget_params)
	-- buttons
	o.wibox_widget:buttons(gears.table.join(awful.button({}, 1, nil, function()
		o:toggle()
	end)))
	return { o.wibox_widget, o.status_widget }
end
function toggle:toggle()
	local wibox_widget = self.wibox_widget
	if not self.toggle_on then
		self.icon_widget:set_image(self.toggled_on_icon)
		wibox_widget.bg = beautiful.accent
		self.status_widget.name:set_text("On")
		self.toggle_on_callback()
	else
		self.icon_widget:set_image(self.toggled_off_icon)
		wibox_widget.bg = beautiful.groups_bg
		self.status_widget.name:set_text("Off")
		self.toggle_off_callback()
	end
	self.toggle_on = not self.toggle_on
end
return toggle
