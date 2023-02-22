local capi = { awesome = awesome }
local keyboardlayout = require("awful.widget.keyboardlayout")
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

Layouts_dto = {}
Curr_layout_index = 1
local w_keyboard_layout = wibox.widget({
	widget = wibox.widget.textbox,
	align = "center",
	valign = "center",
	font = "SF Pro Text Regular 10",
	text = "",
})
local initialize_layouts = function()
	awful.spawn.easy_async_with_shell("awesome-client 'return awesome.xkb_get_group_names()'", function(stdout)
		if stdout == nil or stdout == "" then
			gears.debug.print_error("no layouts detected")
			return
		end
		local layout_table = keyboardlayout.get_groups_from_group_names(stdout)
		for i, layout in ipairs(layout_table) do
			Layouts_dto[i] = layout["file"]
		end
	w_keyboard_layout:set_text(Layouts_dto[Curr_layout_index])
	end)
	return Layouts_dto
end
initialize_layouts()


local return_widget = function()
	local update_layout = function()
		if Curr_layout_index == #Layouts_dto then
			Curr_layout_index = 0
		end
		Curr_layout_index = Curr_layout_index + 1
		w_keyboard_layout:set_text(Layouts_dto[Curr_layout_index])

	end

	capi.awesome.connect_signal("xkb::group_changed", function()
		update_layout()
	end)
	return w_keyboard_layout
end

return return_widget
