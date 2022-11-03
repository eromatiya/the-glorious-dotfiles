local gears = require("gears")
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. "widget/mpd/icons/"
return {
	icons = widget_icon_dir,
}
