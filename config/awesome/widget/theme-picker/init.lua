local wibox = require("wibox")
local element_class = require("widget.theme-picker.entities.element")
local beautiful = require("beautiful")
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
local capi = { button = button, mouse = mouse }

local function click_to_hide(widget, hide_fct, only_outside)
	only_outside = only_outside or false

	hide_fct = hide_fct or function()
		widget.visible = false
	end

	-- when the widget is visible, we hide it on button press
	widget:connect_signal("property::visible", function(w)
		if not w.visible then
			capi.button.disconnect_signal("press", hide_fct)
		else
			-- the mouse button is pressed here, we have to wait for the release
			local function connect_to_press()
				capi.button.disconnect_signal("release", connect_to_press)
				capi.button.connect_signal("press", hide_fct)
			end
			capi.button.connect_signal("release", connect_to_press)
		end
	end)

	if only_outside then
		-- disable hide on click when the mouse is inside the widget
		widget:connect_signal("mouse::enter", function()
			capi.button.disconnect_signal("press", hide_fct)
		end)

		widget:connect_signal("mouse::leave", function()
			capi.button.connect_signal("press", hide_fct)
		end)
	end
end

local elements = {}
local selected = 1
return function(s)
	local container = wibox.layout.flex.vertical()
	for index, theme in ipairs(themes) do
		local curr_el = element_class:new(theme.name, theme.description)
		table.insert(elements, curr_el)
		-- curr_el.bg = "#000000"
		container:add(curr_el.widget)
	end
	local popup = awful.popup({
		widget = container,
		placement = awful.placement.centered,
		screen = s,
		visible = false,
		ontop = true,
	})
	click_to_hide(popup, nil, false)
	return popup
end
