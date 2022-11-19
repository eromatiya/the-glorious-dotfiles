local script_path = function()
	local str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*/)")
end
local serialize = function(str)
	return string.gsub(str, "\n", "")
end
return {
	script_path = script_path,
	serialize = serialize,
}
