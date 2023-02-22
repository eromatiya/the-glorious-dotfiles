local gears = require("gears")
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. "widget/xdg-folders/icons/"
---@type table<folder_names, string>
local icons = {
	home = widget_icon_dir .. "user-home.svg",
	documents = widget_icon_dir .. "folder-documents.svg",
	downloads = widget_icon_dir .. "folder-download.svg",
	pictures = widget_icon_dir .. "folder-pictures.svg",
	videos = widget_icon_dir .. "folder-videos.svg",
	trash_empty = widget_icon_dir .. "user-trash-empty.svg",
	trash_full = widget_icon_dir .. "user-trash-full.svg",
}
return icons
