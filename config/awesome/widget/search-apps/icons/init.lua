--- @type {linear:  string, default: string}
local icons = { default = "app-launcher-floppy", linear = "app-launcher-def" }
local mt = {
	__index = function()
		return icons.default
	end,
}
setmetatable(icons, mt)
return icons
