local path_to_file = ...
local wibox = require("wibox")
local dirs = require("widget.mpd.content.directories")
local Media_button = require(path_to_file .. ".button")
---@type {play: media_button, next: media_button, prev: media_button}
local buttons = {
	play_button = Media_button:new("play", dirs.icons .. "play.svg"),
	next_button = Media_button:new("next", dirs.icons .. "next.svg"),
	prev_button = Media_button:new("prev", dirs.icons .. "prev.svg"),
}
