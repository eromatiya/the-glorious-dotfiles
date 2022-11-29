local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local user_profile = require("widget.user-profile")
local create_meter = require("widget.meters")
local cpu_meter = create_meter("cpu")
local ram_meter = create_meter("ram")
local temperature_meter = create_meter("temperature")
local harddrive_meter = create_meter("disk")
local mpd = require("widget.mpd")
local volume_slider = require("widget.volume-slider")
local brightness_slider = require("widget.brightness-slider")
local blur_slider = require("widget.blur-slider")
-- local airplane_mode = require("widget.airplane-mode")
-- local bluetooth_toggle = require("widget.bluetooth-toggle")
-- local blue_light = require("widget.blue-light")
local toggle_widgets = require("widget.toggles")
local end_session = require("widget.end-session")
local control_center_switch = require("widget.control-center-switch")

panel_visible = false

local format_item = function(widget)
	return wibox.widget({
		{
			{
				layout = wibox.layout.align.vertical,
				expand = "none",
				nil,
				widget,
				nil,
			},
			margins = dpi(10),
			widget = wibox.container.margin,
		},
		forced_height = dpi(88),
		bg = beautiful.groups_bg,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
		end,
		widget = wibox.container.background,
	})
end

local format_item_no_fix_height = function(widget)
	return wibox.widget({
		{
			{
				layout = wibox.layout.align.vertical,
				expand = "none",
				nil,
				widget,
				nil,
			},
			margins = dpi(10),
			widget = wibox.container.margin,
		},
		bg = beautiful.groups_bg,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
		end,
		widget = wibox.container.background,
	})
end

local vertical_separator = wibox.widget({
	orientation = "vertical",
	forced_height = dpi(1),
	forced_width = dpi(1),
	span_ratio = 0.55,
	widget = wibox.widget.separator,
})

local control_center_row_one = wibox.widget({
	layout = wibox.layout.align.horizontal,
	forced_height = dpi(48),
	nil,
	format_item(user_profile()),
	{
		format_item({
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(10),
			control_center_switch(),
			vertical_separator,
			end_session(),
		}),
		left = dpi(10),
		widget = wibox.container.margin,
	},
})

local main_control_row_two = wibox.widget({
	layout = wibox.layout.flex.horizontal,
	spacing = dpi(10),
	format_item_no_fix_height({
		layout = wibox.layout.fixed.vertical,
		spacing = dpi(5),
		toggle_widgets.airplane_mode.circular,
		toggle_widgets.bluetooth.circular,
		toggle_widgets.blue_light.circular,
	}),
	{
		layout = wibox.layout.flex.vertical,
		spacing = dpi(10),
		format_item_no_fix_height({
			layout = wibox.layout.align.vertical,
			expand = "none",
			nil,
			require("widget.dont-disturb"),
			nil,
		}),
		format_item_no_fix_height({
			layout = wibox.layout.align.vertical,
			expand = "none",
			nil,
			toggle_widgets.blur_effects.circular,
			nil,
		}),
	},
})

local main_control_row_sliders = wibox.widget({
	layout = wibox.layout.fixed.vertical,
	spacing = dpi(10),
	format_item({
		blur_slider,
		margins = dpi(10),
		widget = wibox.container.margin,
	}),
	format_item({
		brightness_slider,
		margins = dpi(10),
		widget = wibox.container.margin,
	}),
	format_item({
		volume_slider,
		margins = dpi(10),
		widget = wibox.container.margin,
	}),
})

local main_control_music_box = wibox.widget({
	layout = wibox.layout.fixed.vertical,
	format_item({
		mpd,
		margins = dpi(10),
		widget = wibox.container.margin,
	}),
})

local monitor_control_row_progressbars = wibox.widget({
	layout = wibox.layout.fixed.vertical,
	spacing = dpi(10),
	format_item(cpu_meter),
	format_item(ram_meter),
	format_item(temperature_meter),
	format_item(harddrive_meter),
})

local control_center = function(s)
	-- Set the control center geometry
	local panel_width = dpi(400)
	local panel_margins = dpi(5)

	local panel = awful.popup({
		widget = {
			{
				{
					layout = wibox.layout.fixed.vertical,
					spacing = dpi(10),
					control_center_row_one,
					{
						layout = wibox.layout.stack,
						{
							id = "main_control",
							visible = true,
							layout = wibox.layout.fixed.vertical,
							spacing = dpi(10),
							main_control_row_two,
							main_control_row_sliders,
							-- 🔧 TODO: format mpd
							format_item(mpd),
						},
						{
							id = "monitor_control",
							visible = false,
							layout = wibox.layout.fixed.vertical,
							spacing = dpi(10),
							monitor_control_row_progressbars,
						},
					},
				},
				margins = dpi(16),
				widget = wibox.container.margin,
			},
			id = "control_center",
			bg = beautiful.background,
			shape = function(cr, w, h)
				gears.shape.rounded_rect(cr, w, h, beautiful.groups_radius)
			end,
			widget = wibox.container.background,
		},
		screen = s,
		type = "dock",
		visible = false,
		ontop = true,
		width = dpi(panel_width),
		maximum_width = dpi(panel_width),
		maximum_height = dpi(s.geometry.height),
		bg = beautiful.transparent,
		fg = beautiful.fg_normal,
		shape = gears.shape.rectangle,
	})

	awful.placement.top_right(panel, {
		honor_workarea = true,
		parent = s,
		margins = {
			top = dpi(33),
			right = dpi(5),
		},
	})

	panel.opened = false

	s.backdrop_control_center = wibox({
		ontop = true,
		screen = s,
		bg = beautiful.transparent,
		type = "utility",
		x = s.geometry.x,
		y = s.geometry.y,
		width = s.geometry.width,
		height = s.geometry.height,
	})

	local open_panel = function()
		local focused = awful.screen.focused()
		panel_visible = true

		focused.backdrop_control_center.visible = true
		focused.control_center.visible = true

		panel:emit_signal("opened")
	end

	local close_panel = function()
		local focused = awful.screen.focused()
		panel_visible = false

		focused.control_center.visible = false
		focused.backdrop_control_center.visible = false

		panel:emit_signal("closed")
	end

	-- Hide this panel when app dashboard is called.
	function panel:hide_dashboard()
		close_panel()
	end

	function panel:toggle()
		self.opened = not self.opened
		if self.opened then
			open_panel()
		else
			close_panel()
		end
	end

	s.backdrop_control_center:buttons(awful.util.table.join(awful.button({}, 1, nil, function()
		panel:toggle()
	end)))

	return panel
end

return control_center
