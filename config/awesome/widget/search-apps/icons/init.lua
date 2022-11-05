--- @type {floppy:  string, default: string}
local icons = { floppy = "app-launcher-floppy", default = "app-launcher-def" }
local mt = {
	__index = function()
		return icons.default
	end,
}
setmetatable(icons, mt)
return icons
