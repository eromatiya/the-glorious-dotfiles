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

	local panel = wibox {
		ontop = true,
		screen = s,
		type = 'dock',
		height = dpi(48),
		width = s.geometry.width,
		x = s.geometry.x,
		y = dpi(s.geometry.height - 48),
		stretch = true,
		bg = beautiful.background,
		fg = beautiful.fg_normal
	}

	panel:struts {
		bottom = dpi(48)
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

	local build_widget = function(widget)
		return wibox.widget {
			{
				widget,
				border_width = dpi(1),
        		border_color = beautiful.groups_title_bg,
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

	local add_button 		= build_widget(require('widget.open-default-app')(s))
	s.search_apps			= build_widget(require('widget.search-apps')())
	s.control_center_toggle = build_widget(require('widget.control-center-toggle')())
	s.global_search			= build_widget(require('widget.global-search')())
	s.info_center_toggle 	= build_widget(require('widget.info-center-toggle')())
	s.tray_toggler  		= build_widget(require('widget.tray-toggle'))
	s.updater 				= build_widget(require('widget.package-updater')())
	s.screen_rec 			= build_widget(require('widget.screen-recorder')())
	s.bluetooth   			= build_widget(require('widget.bluetooth')())
	s.network       		= build_widget(require('widget.network')())
	local clock 			= build_widget(require('widget.clock')(s))
	local layout_box 		= build_widget(require('widget.layoutbox')(s))
	s.battery     			= build_widget(require('widget.battery')())
	s.info_center_toggle	= build_widget(require('widget.info-center-toggle')())

	panel : setup {
		{
			layout = wibox.layout.align.horizontal,
			expand = 'none',
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = dpi(5),
				s.search_apps,
				s.control_center_toggle,
				s.global_search,
				build_widget(tag_list(s)),
				build_widget(task_list(s)),
				add_button
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
				s.tray_toggler,
				s.updater,
				s.screen_rec,
				s.network,
				s.bluetooth,
				s.battery,
				clock,
				layout_box,
				s.info_center_toggle
			}
		},
		left = dpi(5),
		right = dpi(5),
		widget = wibox.container.margin
	}

	return panel
end


return bottom_panel
