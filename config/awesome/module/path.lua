local gtable = require("gears.table")
---sanitizing path so it doesn.t
local check_for_delimeters = function(folders)
	for _, path in ipairs(folders) do
		if path:match("/$") then
			error("Path:" .. path .. " has a trailing backslash")
		end
		-- $$$$local last_char = path:sub(-1)
		-- if last_char == "/" then
		-- 	error("Path:" .. path .. " has a trailing backslash")
		-- end
	end
	return folders
end
--- path class for easier path manipulation
--- @class Path
--- @field path table
local Path = { path = {} }
--- insert path in ( "path1", "path2", "path3" ) format
---@param ... string
---@return Path
function Path:new(...)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.path = { ... }
	pcall(check_for_delimeters(o.path))
	return o
end

function Path:__add(other)
	return Path:new(table.unpack(gtable.join(self.path, other.path)))
end
--- @param ... string
function Path:join(...)
	-- self.path = gtable.join(self.path, { ... })
	local new_table = gtable.join(self.path, { ... })
	return Path:new(table.unpack(new_table))
end

---@param delimeter "." | "/"| nil
function Path:__call(delimeter)
	delimeter = delimeter or "/"
	local path = table.concat(self.path, delimeter) .. delimeter
	return path
end

--- @return string
function Path:__tostring()
	local delimeter = "/"
	local path = table.concat(self.path, delimeter) .. delimeter
	return path
end

return Path
