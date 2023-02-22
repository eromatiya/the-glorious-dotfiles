local awful = require("awful")
local focused_screen = awful.screen.focused()
---@type {floppy:string , default: string}
local settings = {
	floppy = "right_panel",
	default = "info_center",
}
local mt = {
	__index = function()
		return settings.default
	end,
}
setmetatable(settings, mt)
return settings
