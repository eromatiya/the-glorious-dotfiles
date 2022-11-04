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
			margins = dpi(7),
			widget = wibox.container.margin,
		},
		widget = clickable_container,
	},
	forced_width = dpi(36),
	forced_height = dpi(36),
	bg = beautiful.transparent,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
	end,
	widget = wibox.container.background,
}
---@parameter button_image media_button_image
---@parameter margins any
function media_button:new(button_image, margins)
	self[1][1].margins = margins or dpi(7)
	table.insert(self[1][1], 1, button_image)
	return wibox.widget(self)
end
return media_button
