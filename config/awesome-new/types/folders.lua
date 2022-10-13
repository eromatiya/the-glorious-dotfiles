local filesystem = require("gears.filesystem")
local Path = require("module.path")
local root = Path:new(nil, { filesystem.get_configuration_dir() })
local layout = root + Path:new(nil, { "layout" })
local configuration = root + Path:new(nil, { "configuration" })
local layout = root + Path:new(nil, { "layout" })
local library = root + Path:new(nil, { "library" })
local module = root + Path:new(nil, { "module" })
local folders = {
	["root"] = root(),
	["configuration"] = root + Path:new(nil, { "configuration" }),
	["layout"] = root + Path:new(nil, { "layout" }),
	["library"] = library(),
	["module"] = module(),
}
--- @type number
local k = 4
