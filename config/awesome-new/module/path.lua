local gtable = require("gears.table")

---sanitizing path so it doesn.t
local check_for_delimeters = function(folders)
	for i, path in ipairs(folders) do
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
--- insert path in {"path1", "path2", "path3"} format
---@param o any
---@param path table
---@return Path
function Path:new(o, path)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	pcall(check_for_delimeters(path))
	o.path = path or {}
	return o
end

function Path:__add(other)
	return Path:new(nil, gtable.join(self.path, other.path))
end
--- @operator add: Path
--- @param path Path
function Path:add(path)
	self.path = gtable.join(self.path, path)
end
function Path:__call()
	local path = table.concat(self.path, "/"):gsub("//", "/") .. "/"
	return path
end

return Path
