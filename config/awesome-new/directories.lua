local filesystem = require("gears.filesystem")
local Path = require("module.path")

local cfg, _ = filesystem.get_configuration_dir():gsub("/$", "")
local c = Path:new(cfg)
-- print("PATH", c)
--- @type {["config_dir"] : string }
return {
	["config_dir"] = c,
}
