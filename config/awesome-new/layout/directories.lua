-- local Path = require("module.path")
-- local filesystem = require("gears.filesystem")
-- ---@return {["root"]: string,["icons"]: string , ["titlebar_icons"]: string}

-- local config_dir = Path:new(nil, { filesystem.get_configuration_dir() })
-- local layout_root_dir = config_dir + Path:new(nil, { "layout" })
-- local theme_layout_dir = layout_root_dir + Path:new(nil, { THEME })
-- local wallpaper_dir = theme_layout_dir + Path:new(nil, { "wallpapers" })
-- local icons = layout_root_dir + Path:new(nil, { "icons" })
-- -- local titlebar = icons + Path:new(nil, { "titlebar", titlebar_themes[THEME] })

-- --- @type {["root"]: string,["curr_theme"]: string,["icons"]: string, ["titlebar_icons"]: string, ["wallpapers"]: string}
-- local directories = {
-- 	["root"] = layout_root_dir(),
-- 	["curr_theme"] = layout_root_dir(),
-- 	["icons"] = icons(),
-- 	-- ["titlebar_icons"] = titlebar(),
-- 	["wallpaper"] = wallpaper_dir(),
-- }
-- return directories
