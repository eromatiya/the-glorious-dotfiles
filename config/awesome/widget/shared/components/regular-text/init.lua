local wibox = require("wibox")

local regular_text = {
	id = "",
	text = "",
	font = "Inter Regular 10",
	align = "left",
	widget = wibox.widget.textbox,
}
---@param text string
---@param font string
---@param align unknown
function regular_text:new(text, font, align)
	local o = {}
	o.id = self.id
	o.text = text or self.text
	o.font = font or self.font
	o.align = align or self.align
	setmetatable(o, self)
	self.__index = self
	return wibox.widget(o)
end

return regular_text
