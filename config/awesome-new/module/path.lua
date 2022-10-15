local gtable = require("gears.table")

---sanitizing path so it doesn.t
local check_for_delimeters = function(folders)
	for _, path in ipairs(folders) do
		if path:sub(-1) == "/" then
			error("Path:" .. path .. " has a trailing slash")
		end
	end
	return folders
end
--- path class for easier path manipulation
--- @class Path
--- @field path table
local Path = {}
--- insert path in ( "path1", "path2", "path3" ) format
---@param ... string
---@return Path
function Path:new(...)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	pcall(check_for_delimeters({ ... }))
	o.path = { ... }
	return o
end

function Path:__add(other)
	return Path:new(table.unpack(gtable.join(self.path, other.path)))
end
--- @param ... string
function Path:join(...)
	self.path = gtable.join(self.path, { ... })
	return self
end
function Path:__call()
	local path = table.concat(self.path, "/") .. "/"
	return path
end

return Path
