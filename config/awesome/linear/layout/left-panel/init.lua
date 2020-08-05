local wibox = require('wibox')
local awful = require('awful')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local apps = require('configuration.apps')

local left_panel = function(screen)
	
	local panel_content_width = dpi(345)

	local panel = wibox {
		screen = screen,
		width = panel_content_width,
		type = 'dock',
		height = screen.geometry.height,
		x = screen.geometry.x,
		y = screen.geometry.y,
		ontop = true,
		bg = beautiful.background,
		fg = beautiful.fg_normal
	}

	panel.opened = false

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

	local open_panel = function(should_run_rofi)
		backdrop.visible = true
		panel.visible = true
		panel:get_children_by_id('panel_content')[1].visible = true
		if should_run_rofi then
			panel:run_rofi()
		end
		panel:emit_signal('opened')
	end

	local close_panel = function()
		panel:get_children_by_id('panel_content')[1].visible = false
		panel.visible = false
		backdrop.visible = false
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
		nil
	}
	return panel
end

return left_panel
