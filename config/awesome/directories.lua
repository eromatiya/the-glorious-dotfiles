local filesystem = require("gears.filesystem")
local Path = require("module.path")
local gears = require("gears")

local cfg, _ = filesystem.get_configuration_dir():gsub("/$", "")
local c = Path:new(cfg)
-- print("PATH", c)
local config_dir = gears.filesystem.get_configuration_dir()
local widget_dir = config_dir .. "widget/"

--- @type {["config_dir"] : string }
local dirs = {
	config_dir = config_dir,
	widget_dir = widget_dir,
}
return dirs
