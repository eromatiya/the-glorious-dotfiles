local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local icons = require("theme.icons")
local icon = require("widget.shared.components.icon")
local name = require("widget.shared.components.name")
local clickable_container = require("widget.clickable-container")

---@class toggle_comp
---@field wibox_widget unknown
---@field toggle_on boolean
---@field toggle_on_callback function
---@field toggle_off_callback function
---@field toggled_on_icon unknown
---@field toggled_off_icon unknown
local toggle = {
	widget_params = {
		{
			{
				{
					id = "icon",
					image = _,
					widget = wibox.widget.imagebox,
					resize = true,
				},
				layout = wibox.layout.align.horizontal,
			},
			id = "margins",
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
	status = name:new("On", _, _),
}

---@param toggle_on_callback function
---@param toggle_off_callback function
function toggle:new(toggle_on_icon, toggle_off_icon, toggle_on_callback, toggle_off_callback)
	local o = {}
	o.toggle_on_callback = toggle_on_callback or function() end
	o.toggle_off_callback = toggle_off_callback or function() end
	o.toggled_on_icon = toggle_on_icon or icons.toggled_on
	o.toggled_off_icon = toggle_off_icon or icons.toggled_off
	self.__index = self
	setmetatable(o, self)
	local status = {
		layout = wibox.layout.align.vertical,
		expand = "none",
		nil,
		o.status,
		nil,
	}
	o.wibox_widget = wibox.widget(o.widget_params)
	o.wibox_widget:buttons(gears.table.join(awful.button({}, 1, nil, function()
		o:toggle()
	end)))
	return o.wibox_widget
end
function toggle:toggle()
	local wibox_widget = self.wibox_widget
	if not self.toggle_on then
		wibox_widget.margins.icon:set_image(self.toggled_on_icon)
		wibox_widget.bg = beautiful.accent
		-- self.status:set_text("On")
		self.toggle_on_callback()
	else
		wibox_widget.icon:set_image(self.toggled_off_icon)
		wibox_widget.bg = beautiful.groups_bg
		-- self.status:set_text("Off")
		self.toggle_off_callback()
	end
	self.toggle_on = not self.toggle_on
end
return toggle
