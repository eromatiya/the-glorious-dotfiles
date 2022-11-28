local wibox = require("wibox")
local element_class = require("widget.theme-picker.entities.element")
local awful = require("awful")
local themes = {
	{ name = "Floppy", description = "Floppy was meant to be a clone of the infamous Flurry Desktop." },
	{ name = "GNawesOME", description = "Yes, GNawesOME is a weird name. GNawesOME was meant to be a GNOME clone" },
	{
		name = "Surreal",
		description = "Yes, I copied the macOS Big Sur design.",
	},
	{ name = "Linear", description = "A setup full of borders and lines. Awesome right?" },
}

-- 🔧 TODO: fix this
return function(s)
	local container = wibox.layout.flex.vertical()
	for index, theme in ipairs(themes) do
		local curr_el = element_class:new(theme.name, theme.description)
		container:add(curr_el)
	end
	return awful.popup({ widget = container, placement = awful.placement.centered, screen = s })
end
