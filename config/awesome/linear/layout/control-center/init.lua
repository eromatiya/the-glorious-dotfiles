local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
panel_visible = false

local format_item = function(widget)
	return wibox.widget {
		{
			{
				layout = wibox.layout.align.vertical,
				expand = 'none',
				nil,
				widget,
				nil
			},
			margins = dpi(10),
			widget = wibox.container.margin
		},
		forced_height = dpi(88),
		border_width	= 	dpi(1),
		border_color 	= 	beautiful.groups_title_bg,
		bg = beautiful.groups_bg,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
		end,
		widget = wibox.container.background
	}
end

local format_item_no_fix_height = function(widget)
	return wibox.widget {
		{
			{
				layout = wibox.layout.align.vertical,
				expand = 'none',
				nil,
				widget,
				nil
			},
			margins = dpi(10),
			widget = wibox.container.margin
		},
		border_width	= 	dpi(1),
		border_color 	= 	beautiful.groups_title_bg,
		bg = beautiful.groups_bg,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
		end,
		widget = wibox.container.background
	}
end

local vertical_separator =  wibox.widget {
	orientation = 'vertical',
	forced_height = dpi(1),
	forced_width = dpi(1),
	span_ratio = 0.55,
	widget = wibox.widget.separator
}

local control_center_row_last = wibox.widget {
	layout = wibox.layout.align.horizontal,
	forced_height = dpi(48),
	format_item(
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(10),
			require('widget.end-session')(),
			vertical_separator,
			require('widget.control-center-switch')()
		}
	),
	{
		format_item(
			require('widget.user-profile')()
		),
		left = dpi(10),
		widget = wibox.container.margin
	},
	nil
}

local main_control_row_two = wibox.widget {
	layout = wibox.layout.flex.horizontal,
	spacing = dpi(10),
	format_item_no_fix_height(
		{
			layout = wibox.layout.fixed.vertical,
			spacing = dpi(5),
			require('widget.airplane-mode'),
			require('widget.bluetooth-toggle'),
			require('widget.blue-light')
		}
	),
	{
		layout = wibox.layout.flex.vertical,
		spacing = dpi(10),
		format_item_no_fix_height(
			{
				layout = wibox.layout.align.vertical,
				expand = 'none',
				nil,
				require('widget.dont-disturb'),
				nil
			}
		),
		format_item_no_fix_height(
			{
				layout = wibox.layout.align.vertical,
				expand = 'none',
				nil,
				require('widget.blur-toggle'),
				nil
			}
		)
	}
}

local main_control_row_sliders = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	spacing = dpi(10),
	format_item(
		{
			require('widget.blur-slider'),
			margins = dpi(10),
			widget = wibox.container.margin
		}
	),
	format_item(
		{
			require('widget.brightness-slider'),
			margins = dpi(10),
			widget = wibox.container.margin
		}
	),
	format_item(
		{
			require('widget.volume-slider'),
			margins = dpi(10),
			widget = wibox.container.margin
		}
	)
}

local main_control_music_box = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	format_item(
		{
			require('widget.mpd'),
			margins = dpi(10),
			widget = wibox.container.margin
		}
	)
}

local monitor_control_row_progressbars = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	spacing = dpi(10),
	format_item(
		require('widget.cpu-meter')
	),
	format_item(
		require('widget.ram-meter')
	),
	format_item(
		require('widget.temperature-meter')
	),
	format_item(
		require('widget.harddrive-meter')
	)
}

local control_center = function(s)
	-- Set the control center geometry
	local panel_width = dpi(400)
	local panel_margins = dpi(5)

	local panel = awful.popup {
		widget = {
			{
				{
					layout = wibox.layout.fixed.vertical,
					spacing = dpi(10),
					{
						layout = wibox.layout.stack,
						{
							id = 'main_control',
							visible = true,
							layout = wibox.layout.fixed.vertical,
							spacing = dpi(10),
							main_control_row_two,
							main_control_row_sliders,
							main_control_music_box
						},
						{
							id = 'monitor_control',
							visible = false,
							layout = wibox.layout.fixed.vertical,
							spacing = dpi(10),
							monitor_control_row_progressbars
						}
					},
					control_center_row_last
				},
				margins = dpi(16),
				widget = wibox.container.margin
			},
			id = 'control_center',
			border_width	= 	dpi(1),
			border_color 	= 	beautiful.groups_title_bg,
			bg = beautiful.background,
			shape =function(cr, w, h)
				gears.shape.rounded_rect(cr, w, h, beautiful.groups_radius)
			end,
			widget = wibox.container.background
		},
		screen = s,
		type = 'dock',
		visible = false,
		ontop = true,
		width = dpi(panel_width),
		maximum_width = dpi(panel_width),
		maximum_height = dpi(s.geometry.height - 58),
		bg = beautiful.transparent,
		fg = beautiful.fg_normal,
		shape = gears.shape.rectangle
	}

	panel:connect_signal(
		'property::height',
		function()
			awful.placement.bottom_left(
				panel,
				{
					honor_workarea = true,
					margins = {
						bottom = dpi(5),
						left = dpi(5)
					}
				}
			)
		end
	)

	panel.opened = false

	s.backdrop_control_center = wibox {
		ontop = true,
		screen = s,
		bg = beautiful.transparent,
		type = 'utility',
		x = s.geometry.x,
		y = s.geometry.y,
		width = s.geometry.width,
		height = s.geometry.height
	}
	
	local open_panel = function()
		local focused = awful.screen.focused()
		panel_visible = true

		focused.backdrop_control_center.visible = true
		focused.control_center.visible = true

		panel:emit_signal('opened')
	end

	local close_panel = function()
		local focused = awful.screen.focused()
		panel_visible = false

		focused.control_center.visible = false
		focused.backdrop_control_center.visible = false
		
		panel:emit_signal('closed')
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

	s.backdrop_control_center:buttons(
		awful.util.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					panel:toggle()
				end
			)
		)
	)

	return panel
end

return control_center
