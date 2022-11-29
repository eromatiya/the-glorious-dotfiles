local filesystem = require("gears.filesystem")
local Path = require("module.path")
local gears = require("gears")

local cfg, _ = filesystem.get_configuration_dir():gsub("/$", "")
local c = Path:new(cfg)
local config_dir = gears.filesystem.get_configuration_dir()
local widget_dir = config_dir .. "widget/"

---@alias folders  "widget" | "config"
---@type table<folders, string>
local dirs = {
	config = config_dir,
	widget = widget_dir,
}
return dirs
