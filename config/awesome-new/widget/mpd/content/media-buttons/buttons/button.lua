local wibox = require("wibox")
local dirs = require("widget.mpd.content.directories")
-- return wibox.widget({
-- 	{
-- 		id = "play",
-- 		image = dirs.icons .. "play.svg",
-- 		resize = true,
-- 		opacity = 0.8,
-- 		widget = wibox.widget.imagebox,
-- 	},
-- 	layout = wibox.layout.align.horizontal,
-- })
---@class media_button
---@field id string
---@field image string
---@field layout string

---@type media_button
local media_button = { resize = true, opacity = 0.8, widget = wibox.widget.imagebox }
function media_button:new(id, image, layout)
	self.id = id or ""
	self.image = image or ""
	self.layout = layout or wibox.layout.align.horizontal
	return self
end
return media_button
