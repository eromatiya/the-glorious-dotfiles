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
---@class media_button_image
---@field id string
---@field image string
---@field layout string

---@type media_button_image
local media_button_image = { { resize = true, opacity = 0.8, widget = wibox.widget.imagebox } }
function media_button_image:new(id, image, layout)
	self[1].id = id or ""
	self[1].image = image or ""
	self.layout = layout or wibox.layout.align.horizontal
	return wibox.widget(self)
end
return media_button_image
