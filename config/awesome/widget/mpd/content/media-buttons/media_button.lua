local wibox = require("wibox")
local dirs = require("widget.mpd.content.directories")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require("widget.clickable-container")
---@class media_button
---@

---@type media_button
local media_button = {
	{
		{
			-- button image goes here
			margins = dpi(9),
			widget = wibox.container.margin,
		},
		widget = clickable_container,
	},
	forced_width = dpi(32),
	forced_height = dpi(32),
	bg = beautiful.transparent,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
	end,
	widget = wibox.container.background,
}
---@param button_image media_button_image
---@param margins any
---@param image_side number
function media_button:new(button_image, margins, image_side)
	self[1][1].margins = margins or dpi(7)
	self.forced_width = dpi(image_side) or dpi(36)
	self.forced_height = dpi(image_side) or dpi(36)
	table.insert(self[1][1], 1, button_image)
	return wibox.widget(self)
end
return media_button
