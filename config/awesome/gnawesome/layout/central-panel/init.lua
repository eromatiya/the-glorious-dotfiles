local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi

local panel_visible = false

local central_panel = function(s)

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
						require('widget.central-panel-switch'),
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
								{
									layout = wibox.layout.fixed.vertical,
									spacing = dpi(7),
									require('widget.user-profile'),
									require('widget.weather'),
									require('widget.email'),
									require('widget.calendar')
								},
								require('widget.notif-center')(s)
							},

						},
						{
							id = 'settings_id',
							visible = false,
							layout = wibox.layout.fixed.vertical,
							require('layout.central-panel.settings')()
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

	awful.placement.centered(
		panel, 
		{
			margins = {
				-- right = panel_margins,
				top = s.geometry.y + dpi(65)
			},
			parent = s
		}
	)

	panel.opened = false

	s.backdrop_central = wibox
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

	panel:struts {
		top = 0
	}
	
	open_panel = function()
		local focused = awful.screen.focused()
		panel_visible = true

		focused.backdrop_central.visible = true
		focused.central_panel.visible = true

		panel:emit_signal('opened')
	end

	close_panel = function()
		local focused = awful.screen.focused()
		panel_visible = false

		focused.central_panel.visible = false
		focused.backdrop_central.visible = false
		
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

	s.backdrop_central:buttons(
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

return central_panel