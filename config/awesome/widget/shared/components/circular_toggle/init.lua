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
---@field watch_script string| table | nil
local circular_toggle = {
	toggle_on = false,
	status_widget = {
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
	},
	icon_widget = _,
	margins = dpi(15),
	icon_diameter = dpi(24),
}

---@param toggle_on_icon string
---@param toggle_off_icon string
---@param toggle_on_callback function
---@param toggle_off_callback function
---@param watch_script table | string | nil
function circular_toggle:new(toggle_on_icon, toggle_off_icon, toggle_on_callback, toggle_off_callback, watch_script)
	---@type circular_toggle
	local o = {}

	o.toggle_on_callback = toggle_on_callback or function() end
	o.toggle_off_callback = toggle_off_callback or function() end
	o.toggled_on_icon = toggle_on_icon
	o.toggled_off_icon = toggle_off_icon
	o.watch_script = watch_script
	o.status_widget = wibox.widget(self.status_widget)
	o.icon_widget = wibox.widget({
		image = o.toggled_off_icon,
		widget = wibox.widget.imagebox,
		resize = true,
		forced_height = self.icon_diameter,
		forced_width = self.icon_diameter,
	})

	self.__index = self
	setmetatable(o, self)
	-- icon
	-- layout
	local layout_widget = wibox.layout.fixed.horizontal()
	layout_widget:add(o.icon_widget)

	local margin_widget = wibox.container.margin(layout_widget)
	margin_widget.margins = o.margins
	local background_widget = wibox.container.background(margin_widget, beautiful.groups_bg, gears.shape.circle)
	-- adding icon margins and bg
	o.wibox_widget = background_widget

	-- buttons
	o.wibox_widget:buttons(gears.table.join(awful.button({}, 1, nil, function()
		o:toggle(false)
	end)))

	if watch_script then
		o:register_watch_script()
	end

	return { o.wibox_widget, o.status_widget }
end
---@param silent boolean
function circular_toggle:toggle(silent)
	local wibox_widget = self.wibox_widget
	if not self.toggle_on then
		self.icon_widget:set_image(self.toggled_on_icon)
		wibox_widget.bg = beautiful.accent
		self.status_widget.name:set_text("On")
		if not silent then
			self.toggle_on_callback()
		end
	else
		self.icon_widget:set_image(self.toggled_off_icon)
		wibox_widget.bg = beautiful.groups_bg
		self.status_widget.name:set_text("Off")
		if not silent then
			self.toggle_off_callback()
		end
	end
	self.toggle_on = not self.toggle_on
end
function circular_toggle:register_watch_script()
	awful.widget.watch(self.watch_script, 60, function(_, stdout)
		-- 🔧 TODO: improve this
		if stdout:match("true") then
			-- so it toggles to true
			self.toggle_on = false
		elseif stdout:match("false") then
			-- so it toggles to false
			self.toggle_on = true
		else
			pcall(function()
				error("Invalid watch script output: must be true or false")
			end)
			return
		end
		self:toggle(true)
	end)
end
return circular_toggle
