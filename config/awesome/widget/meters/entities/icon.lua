local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local watch = awful.widget.watch
local dpi = beautiful.xresources.apply_dpi

local clickable_container = require("widget.clickable-container")
local icon = {
	layout = wibox.layout.align.vertical,
	expand = "none",
	nil,
	{
		image = _,
		resize = true,
		widget = wibox.widget.imagebox,
	},
	nil,
}
local themes_without_icon_bg = {
	floppy = true,
}

---@param image_path string
---@param margins unknown
---@param clickable boolean
---@param bg boolean
function icon:new(image_path, margins, clickable, bg)
	self[2].image = image_path
	if themes_without_icon_bg[THEME] then
		return wibox.widget(self)
	end
	local image_with_margins = {
		self,
		margins = margins or dpi(5),
		widget = wibox.container.margin,
	}
	if clickable then
		image_with_margins = { image_with_margins, widget = clickable_container }
	end
	local image_with_bkg = {
		image_with_margins,
		bg = beautiful.groups_bg,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
		end,
		widget = wibox.container.background,
	}
	return wibox.widget(image_with_bkg)
end

return icon
