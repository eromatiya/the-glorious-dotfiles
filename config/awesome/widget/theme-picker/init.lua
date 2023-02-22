local wibox = require("wibox")
local element_class = require("widget.theme-picker.entities.element")
local beautiful = require("beautiful")
local awful = require("awful")
-- make table with arrow keys
local hot_keys = {
	up = { Up = true, k = true },
	down = { Down = true, j = true },
	exit = { Escape = true, q = true },
	select = { Return = true },
}
local themes = {
	{ name = "Floppy", description = "Floppy was meant to be a clone of the infamous Flurry Desktop." },
	{ name = "GNawesOME", description = "Yes, GNawesOME is a weird name. GNawesOME was meant to be a GNOME clone" },
	{
		name = "Surreal",
		description = "Yes, I copied the macOS Big Sur design.",
	},
	{ name = "Linear", description = "A setup full of borders and lines. Awesome right?" },
}

local elements = {}
local selected = 1

function build(s)
	local container = wibox.layout.flex.vertical()
	for index, theme in ipairs(themes) do
		local curr_el = element_class:new(theme.name, theme.description)
		table.insert(elements, curr_el)
		container:add(curr_el.widget)
	end
	elements[1]:select()
	local popup = awful.popup({
		widget = container,
		placement = awful.placement.centered,
		screen = s,
		visible = false,
		ontop = true,
	})
	return popup
end
local key_grabber = awful.keygrabber({
	auto_start = true,
	stop_event = "release",
	keypressed_callback = function(self, mod, key, command)
		print(key)
		if hot_keys.down[key] then
			elements[selected]:deselect()
			selected = selected + 1
			if selected > #elements then
				selected = 1
			end
			elements[selected]:select()
		elseif hot_keys.up[key] then
			elements[selected]:deselect()
			selected = selected - 1
			if selected < 1 then
				selected = #elements
			end
			elements[selected]:select()
		elseif hot_keys.exit[key] then
			awful.screen.focused().theme_picker.visible = false
			awesome.emit_signal("theme-picker::closed")
		elseif hot_keys.select[key] then
			elements[selected]:confirm()
		end
	end,
})

awesome.connect_signal("theme-picker::opened", function()
	key_grabber:start()
end)
awesome.connect_signal("theme-picker::closed", function()
	key_grabber:stop()
end)

return build
