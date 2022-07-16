local capi = { awesome = awesome }
local keyboardlayout = require("awful.widget.keyboardlayout")
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
-- local recorder_table = require('widget.keyboard-layout.ui')
require("widget.screen-recorder.screen-recorder-ui-backend")

Layouts_dto = {}
Curr_layout_index = 1
local w_keyboard_layout = wibox.widget({
	widget = wibox.widget.textbox,
	align = "center",
	valign = "center",
	font = "SF Pro Text Regular 10",
	text = "us",
})
local initialize_layouts = function()
	awful.spawn.easy_async_with_shell("awesome-client 'return awesome.xkb_get_group_names()'", function(stdout)
		if stdout == nil or stdout == "" then
			gears.debug.print_error("no layouts detected")
			return
		end
		local layout_table = keyboardlayout.get_groups_from_group_names(stdout)
		-- local table = gears.debug.dump_return(layout_table)
		-- gears.debug.print_warning(table)
		for i, layout in ipairs(layout_table) do
			Layouts_dto[i] = layout["file"]
		end
	end)
	return Layouts_dto
end
initialize_layouts()

-- gears.debug.print_warning(Layouts_dto[2])

local return_widget = function()
	-- local group_names = awful.awesome.xkb_get_group_names()
	-- local group_name = group_names[awesome.xkb_get_group_state()]
	local update_layout = function()
		if Curr_layout_index == #Layouts_dto then
			Curr_layout_index = 0
		end
		Curr_layout_index = Curr_layout_index + 1
		w_keyboard_layout:set_text(Layouts_dto[Curr_layout_index])
		gears.debug.print_warning(Layouts_dto[1])
	end

	-- local group_names = awesome.xkb_get_group_names()
	capi.awesome.connect_signal("xkb::group_changed", function()
		update_layout()
	end)
	-- w_keyboard_layout:set_text(group_names)
	return w_keyboard_layout
end

return return_widget
