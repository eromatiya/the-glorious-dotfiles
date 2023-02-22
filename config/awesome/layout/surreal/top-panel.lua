local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local icons = require("theme.icons")
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require("widget.clickable-container")
local task_list = require("widget.task-list")
local tray_toggler = require("widget.tray-toggle")
local updater = require("widget.package-updater")
local screen_rec = require("widget.screen-recorder")
local keyboard_layout = require("widget.keyboard-layout")
local bluetooth = require("widget.bluetooth")
local battery = require("widget.battery")
local network = require("widget.network")
local theme_picker_toggle = require("widget.theme-picker-toggle")
local control_center_toggle = require("widget.control-center-toggle")
local global_search = require("widget.global-search")
local info_center_toggle = require("widget.info-center-toggle")

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

	s.systray = wibox.widget({
		visible = false,
		base_size = dpi(20),
		horizontal = true,
		screen = "primary",
		widget = wibox.widget.systray,
	})

	local clock = require("widget.clock")(s)
	local layout_box = require("widget.layoutbox")(s)
	local add_button = require("widget.open-default-app")(s)
	s.tray_toggler = tray_toggler
	s.updater = updater()
	s.screen_rec = screen_rec()
	s.bluetooth = bluetooth()
	s.keyboard_layout = keyboard_layout()
	s.battery = battery()
	s.network = network()
	s.control_center_toggle = control_center_toggle()
	s.global_search = global_search()
	s.info_center_toggle = info_center_toggle()
	s.theme_picker_toggle = theme_picker_toggle()

	panel:setup({
		layout = wibox.layout.align.horizontal,
		expand = "none",
		{
			layout = wibox.layout.fixed.horizontal,
			task_list(s),
			add_button,
		},
		clock,
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(5),
			{
				s.systray,
				margins = dpi(5),
				widget = wibox.container.margin,
			},
			s.tray_toggler,
			s.updater,
			s.screen_rec,
			s.network,
			s.bluetooth,
			s.battery,
			s.control_center_toggle,
			s.global_search,
			s.keyboard_layout,
			s.theme_picker_toggle,
			layout_box,
			s.info_center_toggle,
		},
	})

	return panel
end

return top_panel
