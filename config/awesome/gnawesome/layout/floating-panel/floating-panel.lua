local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi

panel_visible = false


-- Calendar theme
local styles = {}
local function rounded_shape(size, partial)
	if partial then
		return function(cr, width, height)
		gears.shape.partially_rounded_rect(cr, width, height,
			false, true, false, true, 5)
		end
	else
		return function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, size)
		end
	end
end

styles.month   = { 
	padding = 5,
	bg_color = '#00000000',
}
styles.normal  = {
	fg_color = '#f2f2f2',
	bg_color = '#00000000'
}
styles.focus   = {
	fg_color = '#f2f2f2',
	bg_color = beautiful.accent,
	markup   = function(t) return '<b>' .. t .. '</b>' end
}
styles.header  = {
	fg_color = '#f2f2f2',
	bg_color = '#00000000',
	markup   = function(t) return '<b>' .. t .. '</b>' end
}
styles.weekday = { 
	fg_color = '#ffffff',
	bg_color = '#00000000',
	markup   = function(t) return '<b>' .. t .. '</b>' end
}

local decorate_cell = function(widget, flag, date)

	if flag=='monthheader' and not styles.monthheader then
		flag = 'header'
	end
	local props = styles[flag] or {}
	if props.markup and widget.get_text and widget.set_markup then
		widget:set_markup(props.markup(widget:get_text()))
	end
	-- Change bg color for weekends
	local d = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
	local weekday = tonumber(os.date('%w', os.time(d)))
	local default_bg = (weekday==0 or weekday==6) and '#232323' or '#383838'
	local ret = wibox.widget {
		{
			widget,
			margins = (props.padding or 2) + (props.border_width or 0),
			widget  = wibox.container.margin
		},
		shape              = props.shape,
		shape_border_color = props.border_color or '#b9214f',
		shape_border_width = props.border_width or 0,
		fg                 = props.fg_color or '#999999',
		bg                 = props.bg_color or default_bg,
		widget             = wibox.container.background
	}
	return ret
end


local calendar = wibox.widget {
	{

		{
			font = 'SF Pro Text Regular 12',
			date = os.date('*t'),
			spacing = dpi(10),
			start_sunday = true,
			long_weekdays = false,
			fn_embed = decorate_cell,
			widget = wibox.widget.calendar.month
		},
		top = dpi(15),
		right = dpi(10),
		left = dpi(10),
		widget = wibox.container.margin
	},
	bg = beautiful.groups_title_bg,
	shape = function(cr, w, h)
		gears.shape.rounded_rect(cr, w ,h, beautiful.groups_radius)
	end,
	widget = wibox.container.background
}


local right_panel = function(s)

	-- Set right panel geometry
	local panel_width = dpi(700)
	local panel_height = s.geometry.height - dpi(38)
	local panel_margins = dpi(5)

	local separator = wibox.widget {
		orientation = 'horizontal',
		opacity = 0.0,
		forced_height = 15,
		widget = wibox.widget.separator,
	}

	local panel = awful.popup {
		widget = {
			{
				{
					expand = 'none',
					layout = wibox.layout.fixed.vertical,
					{
						layout = wibox.layout.align.horizontal,
						expand = 'none',
						nil,
						require('layout.floating-panel.panel-mode-switcher'),
						nil
					},
					separator,
					{
						layout = wibox.layout.stack,
						-- Today Pane
						{
							id = 'pane_id',
							visible = true,
							layout = wibox.layout.fixed.vertical,
							{
								layout = wibox.layout.flex.horizontal,
								spacing = dpi(7),
								require('widget.notif-center'),
								{
									layout = wibox.layout.fixed.vertical,
									spacing = dpi(7),
									require('widget.user-profile'),
									require('widget.weather'),
									require('widget.email'),
									calendar						
								}
							},

						},

						{
							id = 'settings_id',
							visible = false,
							require('layout.floating-panel.settings')(s),
							layout = wibox.layout.fixed.vertical
						}

					},
				},
				margins = dpi(16),
				widget = wibox.container.margin
			},
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
		width = panel_width,
		maximum_height = panel_height,
		maximum_width = panel_width,
		height = s.geometry.height,
		bg = beautiful.transparent,
		fg = beautiful.fg_normal,
		shape = gears.shape.rectangle
	}

	awful.placement.centered(panel, {margins = {
		-- right = panel_margins,
		top = s.geometry.y + dpi(65)
		}, parent = s
	})

	panel.opened = false

	s.backdrop_rdb = wibox
	{
		ontop = true,
		screen = s,
		bg = beautiful.transparent,
		type = 'utility',
		x = s.geometry.x,
		y = s.geometry.y,
		width = s.geometry.width,
		height = s.geometry.height
	}

	panel:struts
	{
		right = 0
	}
	
	open_panel = function()
		local focused = awful.screen.focused()
		panel_visible = true

		focused.backdrop_rdb.visible = true
		focused.right_panel.visible = true

		panel:emit_signal('opened')
	end

	close_panel = function()
		local focused = awful.screen.focused()
		panel_visible = false

		focused.right_panel.visible = false
		focused.backdrop_rdb.visible = false
		
		panel:emit_signal('closed')
	end

	-- Hide this panel when app dashboard is called.
	function panel:HideDashboard()
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


	function panel:switch_pane(mode)
		if mode == 'today_mode' then
			-- Update Content
			panel.widget:get_children_by_id('settings_id')[1].visible = false
			panel.widget:get_children_by_id('pane_id')[1].visible = true
		elseif mode == 'settings_mode' then
			-- Update Content
			panel.widget:get_children_by_id('pane_id')[1].visible = false
			panel.widget:get_children_by_id('settings_id')[1].visible = true
		end
	end

	s.backdrop_rdb:buttons(
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


return right_panel


