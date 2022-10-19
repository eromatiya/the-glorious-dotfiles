local filesystem = require("gears.filesystem")
local Path = require("module.path")

--- @type {["config_dir"] : Path }
return {
	["config_dir"] = Path:new(filesystem.get_configuration_dir():gsub("/$", "")),
}
