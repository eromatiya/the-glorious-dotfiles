local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local clickable_container = require("widget.clickable-container")
local dpi = require("beautiful").xresources.apply_dpi

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. "widget/xdg-folders/icons/"
local button = {
	icon_params = {
		image = _,
		resize = true,
		widget = wibox.widget.imagebox,
	},
	margins = dpi(10),
	click_cb = function() end,
}

---@param name string
---@param image string
---@param margins any
---@param click_cb function
function button:new(name, image, margins, click_cb)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.icon_params.image = image
	o.icon_widget = wibox.widget(o.icon_params)
	local layout_widget = wibox.layout.fixed.horizontal()
	layout_widget:add(o.icon_widget)
	local margin_widget = wibox.container.margin(layout_widget)
	margin_widget.margins = margins or o.margins
	o.widget = wibox.widget({
		margin_widget,
		widget = clickable_container,
	})
	o.widget:buttons(gears.table.join(awful.button({}, 1, nil, click_cb or o.click_cb)))
	o.tooltip = awful.tooltip({
		objects = { o.widget },
		mode = "outside",
		align = "right",
		text = name or "N/A",
		margin_leftright = dpi(8),
		margin_topbottom = dpi(8),
		preferred_positions = { "top", "bottom", "right", "left" },
	})
	return o
end
---@param image string
function button:set_image(image)
	self.icon_widget.image = image
end
function button:set_markup(image)
	self.tooltip.markup = image
end

return button
