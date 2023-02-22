local path_to_file = ...
local wibox = require("wibox")
local dirs = require("widget.mpd.content.directories")
local Media_button_image = require(path_to_file .. ".button-image")

---@type {play_button_image: media_button_image, next_button_image: media_button_image, prev_button_image: media_button_image, rep_button_image: media_button_image, rand_button_image: media_button_image }
local button_images = {
	play_button_image = Media_button_image:new("play", dirs.icons .. "play.svg"),
	next_button_image = Media_button_image:new("next", dirs.icons .. "next.svg"),
	prev_button_image = Media_button_image:new("prev", dirs.icons .. "prev.svg"),
	rep_button_image = Media_button_image:new("rep", dirs.icons .. "repeat-on.svg"),
	rand_button_image = Media_button_image:new("rand", dirs.icons .. "random-on.svg"),
}
return button_images
