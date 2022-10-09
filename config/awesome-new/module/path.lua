local gtable = require("gears.table")

local Path = {}
function Path:new(o, path)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	self.path = path
	return o
end

function Path:__add(other)
	return Path:new(nil, gtable.join(self.path, other.path))
end
function Path:add(path)
	self.path = gtable.join(self.path, path)
end
function Path:__call()
	return table.concat(self.path, "/"):gsub("//", "/")
end

return Path
