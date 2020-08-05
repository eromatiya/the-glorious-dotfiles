local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local apps = require('configuration.apps')

local left_panel = function(screen)
	
	local action_bar_width = dpi(45)
	local panel_content_width = dpi(350)

	local panel = wibox {
		screen = screen,
		width = action_bar_width,
		type = 'dock',
		height = screen.geometry.height,
		x = screen.geometry.x,
		y = screen.geometry.y,
		ontop = true,
		shape = gears.shape.rectangle,
		bg = beautiful.background,
		fg = beautiful.fg_normal
	}

	panel.opened = false

	panel:struts {
		left = action_bar_width
	}

	local backdrop = wibox {
		ontop = true,
		screen = screen,
		bg = beautiful.transparent,
		type = 'utility',
		x = screen.geometry.x,
		y = screen.geometry.y,
		width = screen.geometry.width,
		height = screen.geometry.height
	}

	function panel:run_rofi()
		awesome.spawn(
			apps.default.rofi_global,
			false,
			false,
			false,
			false,
			function()
				panel:toggle()
			end
		)
		
		-- Hide panel content if rofi global search is opened
		panel:get_children_by_id('panel_content')[1].visible = false
	end

	-- "Punch a hole" on backdrop to show the left dashboard
	local update_backdrop = function(wibox_backdrop, wibox_panel)
		local cairo = require('lgi').cairo
		local geo = wibox_panel.screen.geometry

		wibox_backdrop.x = geo.x
		wibox_backdrop.y = geo.y
		wibox_backdrop.width = geo.width
		wibox_backdrop.height = geo.height

		-- Create an image surface that is as large as the wibox_panel screen
		local shape = cairo.ImageSurface.create(cairo.Format.A1, geo.width, geo.height)
		local cr = cairo.Context(shape)

		-- Fill with "completely opaque"
		cr.operator = 'SOURCE'
		cr:set_source_rgba(1, 1, 1, 1)
		cr:paint()

		-- Remove the shape of the client
		local c_geo = wibox_panel:geometry()
		local c_shape = gears.surface(wibox_panel.shape_bounding)
		cr:set_source_rgba(0, 0, 0, 0)
		cr:mask_surface(c_shape, c_geo.x + wibox_panel.border_width - geo.x, c_geo.y + wibox_panel.border_width - geo.y)
		c_shape:finish()

		wibox_backdrop.shape_bounding = shape._native
		shape:finish()
		wibox_backdrop:draw()
	end

	local open_panel = function(should_run_rofi)
		panel.width = action_bar_width + panel_content_width
		backdrop.visible = true
		update_backdrop(backdrop, panel)
		panel:get_children_by_id('panel_content')[1].visible = true
		if should_run_rofi then
			panel:run_rofi()
		end
		panel:emit_signal('opened')
	end

	local close_panel = function()
		panel.width = action_bar_width
		panel:get_children_by_id('panel_content')[1].visible = false
		backdrop.visible = false
		update_backdrop(backdrop, panel)
		panel:emit_signal('closed')
	end

	-- Hide this panel when app dashboard is called.
	function panel:hide_dashboard()
		close_panel()
	end

	function panel:toggle(should_run_rofi)
		self.opened = not self.opened
		if self.opened then
			open_panel(should_run_rofi)
		else
			close_panel()
		end
	end

	backdrop:buttons(
		awful.util.table.join(
			awful.button(
				{},
				1,
				function()
					panel:toggle()
				end
			)
		)
	)

	panel:setup {
		layout = wibox.layout.align.horizontal,
		nil,
		{
			id = 'panel_content',
			bg = beautiful.transparent,
			widget = wibox.container.background,
			visible = false,
			forced_width = panel_content_width,
			{
				require('layout.left-panel.dashboard')(screen, panel),
				layout = wibox.layout.stack
			}
		},
		require('layout.left-panel.action-bar')(screen, panel, action_bar_width)
	}
	return panel
end

return left_panel
