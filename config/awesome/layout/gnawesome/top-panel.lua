local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local icons = require("theme.icons")
local clickable_container = require("widget.clickable-container")
local task_list = require("widget.task-list")
local clock = require("widget.clock")
local updater = require("widget.package-updater")
local screen_recorder = require("widget.screen-recorder")
local mpd = require("widget.mpd")
local end_session = require("widget.end-session")
local global_search = require("widget.global-search")
local keyboard_layout = require("widget.keyboard-layout")
local theme_picker_toggle = require("widget.theme-picker-toggle")

local top_panel = function(s)
	local panel = wibox({
		ontop = true,
		screen = s,
		type = "dock",
		height = dpi(28),
		width = s.geometry.width,
		x = s.geometry.x,
		y = s.geometry.y,
		stretch = false,
		bg = beautiful.background,
		fg = beautiful.fg_normal,
	})

	panel:struts({
		top = dpi(28),
	})

	panel:connect_signal("mouse::enter", function()
		local w = mouse.current_wibox
		if w then
			w.cursor = "left_ptr"
		end
	end)

	local add_button = require("widget.open-default-app")(s)
	s.updater = updater()
	s.screen_rec = screen_recorder()
	s.mpd = mpd
	s.keyboard_layout = keyboard_layout()
	s.end_session = end_session()
	s.global_search = global_search()
	s.theme_picker_toggle = theme_picker_toggle()

	panel:setup({
		layout = wibox.layout.align.horizontal,
		expand = "none",
		{
			layout = wibox.layout.fixed.horizontal,
			task_list(s),
			add_button,
		},
		clock(s),
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(5),
			s.updater,
			s.screen_rec,
			s.global_search,
			s.keyboard_layout,
			s.theme_picker_toggle,
			s.mpd,
			s.end_session,
		},
	})

	return panel
end

return top_panel
