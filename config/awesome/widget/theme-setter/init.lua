local dirs = require("module.directories")
local txt_path = dirs.widget .. "theme-setter/theme.txt"
local setter = {}
function setter:get()
	-- read theme txt and return theme name
	local file = io.open(txt_path, "r")
	local theme = assert(file):read()
	assert(file):close()
	return theme
end

---@param theme themeNames
function setter:set(theme)
	-- write theme txt
	local file = io.open(txt_path, "w")
	assert(file):write(theme)
	assert(file):close()
end
return setter
