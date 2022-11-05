local awful = require("awful")
local filesystem = require("gears.filesystem")
local Path = require("module.path")
local relative_config_dir = filesystem.get_configuration_dir()
-- spawn a terminal and run a command
local config_dir_path = ""
function coroutinize(f, ...)
	local co = coroutine.create(f)
	local function exec(...)
		local ok, data = coroutine.resume(co, ...)
		if not ok then
			error(debug.traceback(co, data))
		end
		if coroutine.status(co) ~= "dead" then
			data(exec)
		end
	end
	exec(...)
end
function set_WS_dir()
	local res = coroutine.yield(function(resolve)
		awful.spawn.easy_async_with_shell("realpath " .. relative_config_dir, resolve)
	end)
	print("config_dir_path: " .. res)
end
coroutinize(set_WS_dir)
print("cc", config_dir_path)
-- return Path:new(nil, { config_dir_path })
