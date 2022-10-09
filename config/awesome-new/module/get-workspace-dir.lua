local awful = require("awful")
local filesystem = require("gears.filesystem")
local Path = require("module.path")
local relative_config_dir = filesystem.get_configuration_dir()
-- spawn a terminal and run a command
local config_dir_path = ""
awful.spawn.easy_async_with_shell("realpath " .. relative_config_dir, function(stdout)
	config_dir_path = stdout
	print("config_dir_path: " .. stdout)
end)

return Path:new(nil, { config_dir_path })
