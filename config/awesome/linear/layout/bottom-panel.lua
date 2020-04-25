local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')

local icons = require('theme.icons')
local dpi = beautiful.xresources.apply_dpi

local clickable_container = require('widget.clickable-container')

local task_list = require('widget.task-list')
local tag_list = require('widget.tag-list')

local bottom_panel = function(s)

	local panel_height = 48
	local panel_y = (s.geometry.y + s.geometry.height) - panel_height

	local panel = wibox
	{
		ontop = true,
		screen = s,
		type = 'dock',
		height = dpi(panel_height),
		width = dpi(s.geometry.width),
		x = s.geometry.x,
		y = panel_y,
		bg = beautiful.background,
		fg = beautiful.fg_normal
	}
	

	panel:struts
	{
		bottom = panel_height
	}


	panel:connect_signal(
		'mouse::enter',
		function() 
			local w = mouse.current_wibox
			if w then
				w.cursor = 'left_ptr'
			end
		end

	)


	s.add_button = wibox.widget {
		{
			{
				{
					{
						image = icons.plus,
						resize = true,
						widget = wibox.widget.imagebox
					},
					margins = dpi(7),
					widget = wibox.container.margin
				},
				widget = clickable_container
			},
			bg = beautiful.transparent,
			shape = gears.shape.circle,
			widget = wibox.container.background
		},
		margins = dpi(10),
		widget = wibox.container.margin
	}

	s.add_button:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					awful.spawn(
						awful.screen.focused().selected_tag.default_app,
						{
							tag = mouse.screen.selected_tag,
							placement = awful.placement.bottom_right
						}
					)
				end
			)
		)
	)


	local layout_box = function(s)
		local layoutbox = wibox.widget {
			{
				awful.widget.layoutbox(s),
				margins = dpi(7),
				widget = wibox.container.margin
			},
			widget = clickable_container
		}
		layoutbox:buttons(
			awful.util.table.join(
				awful.button(
					{},
					1,
					function()
						awful.layout.inc(1)
					end
				),
				awful.button(
					{},
					3,
					function()
						awful.layout.inc(-1)
					end
				),
				awful.button(
					{},
					4,
					function()
						awful.layout.inc(1)
					end
				),
				awful.button(
					{},
					5,
					function()
						awful.layout.inc(-1)
					end
				)
			)
		)
		return layoutbox
	end


	s.clock_widget = wibox.widget.textclock(
		'<span font="SF Pro Text Bold 11">%l:%M %p</span>',
		1
	)

	s.clock_widget = wibox.widget {
		{
			s.clock_widget,
			margins = dpi(7),
			widget = wibox.container.margin
		},
		widget = clickable_container
	}


	s.clock_widget:connect_signal(
		'mouse::enter',
		function()
			local w = mouse.current_wibox
			if w then
				old_cursor, old_wibox = w.cursor, w
				w.cursor = 'hand1'
			end
		end
	)


	s.clock_widget:connect_signal(
		'mouse::leave',
		function()
			if old_wibox then
				old_wibox.cursor = old_cursor
				old_wibox = nil
			end
		end
	)

	s.clock_tooltip = awful.tooltip
	{
		objects = {s.clock_widget},
		mode = 'outside',
		delay_show = 1,
		preferred_positions = {'right', 'left', 'top', 'bottom'},
		preferred_alignments = {'middle'},
		margin_leftright = dpi(8),
		margin_topbottom = dpi(8),
		timer_function = function()
			local ordinal = nil

			local day = os.date('%d')
			local month = os.date('%B')

			local first_digit = string.sub(day, 0, 1) 
			local last_digit = string.sub(day, -1) 

			if first_digit == '0' then
			  day = last_digit
			end


			if last_digit == '1' and day ~= '11' then
			  ordinal = 'st'
			elseif last_digit == '2' and day ~= '12' then
			  ordinal = 'nd'
			elseif last_digit == '3' and day ~= '13' then
			  ordinal = 'rd'
			else
			  ordinal = 'th'
			end

			local date_str = 'Today is the ' ..
			'<b>' .. day .. ordinal .. 
			' of ' .. month .. '</b>.\n' ..
			'And it\'s fucking ' .. os.date('%A')

			return date_str

		end,
	}


	s.clock_widget:connect_signal(
		'button::press', 
		function(self, lx, ly, button)
			-- Hide the tooltip when you press the clock widget
			if s.clock_tooltip.visible and button == 1 then
				s.clock_tooltip.visible = false
			end
		end
	)


	s.month_calendar      = awful.widget.calendar_popup.month({
		start_sunday      = true,
		spacing           = dpi(5),
		font              = 'SF Pro Text Regular 10',
		long_weekdays     = true,
		margin            = dpi(5),
		screen            = s,
		style_month       = { 
			border_width    = dpi(0), 
			padding         = dpi(20),
			shape           = function(cr, width, height)
				gears.shape.partially_rounded_rect(
					cr, width, height, true, true, true, true, beautiful.groups_radius
				)
			end
		},  
		style_header      = { 
			border_width    = 0, 
			bg_color        = beautiful.transparent
		},
		style_weekday     = { 
			border_width    = 0, 
			bg_color        = beautiful.transparent
		},

		style_normal      = { 
			border_width    = 0, 
			bg_color        = beautiful.transparent
		},
		style_focus       = { 
			border_width    = dpi(0), 
			border_color    = beautiful.fg_normal, 
			bg_color        = beautiful.accent, 
			shape           = function(cr, width, height)
				gears.shape.partially_rounded_rect(
					cr, width, height, true, true, true, true, dpi(4))
			end,
		},
	})


	s.month_calendar:attach(
		s.clock_widget, 
		'br', 
		{ 
			on_pressed = true,
			on_hover = false 
		}
	)


	s.systray = wibox.widget {
		{
			base_size = dpi(20),
			horizontal = true,
			screen = 'primary',
			widget = wibox.widget.systray
		},
		visible = false,
		top = dpi(10),
		widget = wibox.container.margin
	}


	local build_widget = function(widget)
		return wibox.widget {
			{
				widget,
				border_width = dpi(1),
        		border_color = '#ffffff30',
				bg = beautiful.transparent,
				shape = function(cr, w, h)
					gears.shape.rounded_rect(cr, w, h, dpi(12))
				end,
				widget = wibox.container.background
			},
			top = dpi(9),
			bottom = dpi(9),
			widget = wibox.container.margin
		}
	end

	s.tray_toggler  = require('widget.tray-toggler')
	s.updater 		= require('widget.package-updater')()
	s.screen_rec 	= require('widget.screen-recorder')()
	s.music       	= require('widget.music')()
	s.bluetooth   	= require('widget.bluetooth')()
	s.network        	= require('widget.network')()
	s.battery     	= require('widget.battery')()
	s.search      	= require('widget.search-apps')()
	s.end_session   = require('widget.end-session')()
	s.side_settings = require('widget.side-settings')()
	s.r_dashboard 	= require('layout.right-panel.right-panel-opener')()


	panel : setup {
		{
			layout = wibox.layout.align.horizontal,
			expand = "none",
			{
				layout = wibox.layout.fixed.horizontal,
				{
					layout = wibox.layout.fixed.horizontal,
					spacing = dpi(5),
					build_widget(s.search),
					build_widget(s.music),
					build_widget(s.side_settings),
					build_widget(tag_list(s)),
					build_widget(task_list(s)),
				},
				s.add_button
			}, 
			nil,
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = dpi(5),
				{
					s.systray,
					margins = dpi(5),
					widget = wibox.container.margin
				},
				build_widget(s.tray_toggler),
				build_widget(s.updater),
				build_widget(s.screen_rec),
				build_widget(s.bluetooth),
				build_widget(s.network),
				build_widget(s.battery),
				build_widget(s.clock_widget),
				build_widget(s.end_session),
				build_widget(layout_box(s)),
				build_widget(s.r_dashboard),
			}
		},
		left = dpi(5),
		right = dpi(5),
		widget = wibox.container.margin
	}

	return panel
end


return bottom_panel
