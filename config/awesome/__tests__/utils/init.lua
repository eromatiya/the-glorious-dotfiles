local script_path = function()
	local str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*/)")
end
local serialize = function(str)
	return string.gsub(str, "\n", "")
end
local DI = function(source, command)
	local map = string.match(command, "|(.*)")
	return source .. "|" .. map
end
return {
	script_path = script_path,
	serialize = serialize,
	DI = DI,
}
