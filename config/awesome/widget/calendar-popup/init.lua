local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require("widget.clickable-container")
local config = require("configuration.config")
local military_mode = config.widget.clock.military_mode or false

function calendar_popup(s)
	s.month_calendar = awful.widget.calendar_popup.month({
		start_sunday = true,
		spacing = dpi(5),
		font = "Inter Regular 10",
		long_weekdays = true,
		margin = dpi(5),
		screen = s,
		style_month = {
			border_width = dpi(0),
			bg_color = beautiful.background,
			padding = dpi(20),
			shape = function(cr, width, height)
				gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, beautiful.groups_radius)
			end,
		},
		style_header = {
			border_width = 0,
			bg_color = beautiful.transparent,
		},
		style_weekday = {
			border_width = 0,
			bg_color = beautiful.transparent,
		},
		style_normal = {
			border_width = 0,
			bg_color = beautiful.transparent,
		},
		style_focus = {
			border_width = dpi(0),
			border_color = beautiful.fg_normal,
			bg_color = beautiful.accent,
			shape = function(cr, width, height)
				gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, dpi(4))
			end,
		},
	})

	s.month_calendar:attach(s.clock_widget, "tc", {
		on_pressed = true,
		on_hover = false,
	})
end
return calendar_popup
