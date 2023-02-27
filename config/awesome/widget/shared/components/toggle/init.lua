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
---@field watch_script string| string[] | nil
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
---@param watch_script string| string[] | nil
function toggle:new(toggle_on_callback, toggle_off_callback, watch_script)
	local o = {}
	o.toggle_on_callback = toggle_on_callback or function() end
	o.toggle_off_callback = toggle_off_callback or function() end
	o.watch_script = watch_script or nil
	self.__index = self
	setmetatable(o, self)
	o.wibox_widget = wibox.widget(o.widget_params)
	o.wibox_widget:buttons(gears.table.join(awful.button({}, 1, nil, function()
		o:toggle(false)
	end)))
	return o.wibox_widget
end
function toggle:toggle(silent)
	local wibox_widget = self.wibox_widget
	if not self.toggle_on then
		wibox_widget.icon:set_image(self.toggle_on_icon)
		if not silent then
			self.toggle_on_callback()
		end
	else
		wibox_widget.icon:set_image(self.toggle_off_icon)
		if not silent then
			self.toggle_off_callback()
		end
	end
	self.toggle_on = not self.toggle_on
end
function toggle:register_watch_script()
	awful.widget.watch(self.watch_script, 60, function(_, stdout)
		if stdout:match("true") then
			self.toggle_on = true
		elseif stdout:match("false") then
			self.toggle_on = false
		else
			pcall(function()
				error("Invalid watch script output: must be on or off")
			end)
			return
		end
		self:toggle(true)
	end)
end

return toggle
