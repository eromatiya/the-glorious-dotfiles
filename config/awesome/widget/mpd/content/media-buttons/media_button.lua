local wibox = require("wibox")
local dirs = require("widget.mpd.content.directories")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require("widget.clickable-container")
---@class media_button

local button_image = {
	{
		-- button image goes here
		margins = dpi(9),
		widget = wibox.container.margin,
	},
	halign = "center",
	widget = wibox.container.place,
	forced_width = dpi(32),
	forced_height = dpi(32),
}
---@type media_button
local media_button = {
	{
		button_image,
		widget = clickable_container,
	},
	bg = beautiful.transparent,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
	end,
	widget = wibox.container.background,
}
---@param icon media_button_image
---@param margins any
function media_button:new(icon, margins)
	self[1][1][1].margins = margins or dpi(7)
	table.insert(self[1][1][1], 1, icon)
	return wibox.widget(self)
end
return media_button
