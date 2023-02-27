local wibox = require("wibox")

local meter_name = {
	text = "",
	font = "Inter Bold 10",
	align = "left",
	widget = wibox.widget.textbox,
}
---@param text string
---@param font string
---@param align unknown
function meter_name:new(text, font, align)
	local o = {}
	o.text = text or self.text
	o.font = font or self.font
	o.align = align or self.align
	setmetatable(o, self)
	self.__index = self
	return wibox.widget(o)
end

return meter_name
