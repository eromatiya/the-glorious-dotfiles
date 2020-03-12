local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local apps = require('configuration.apps')
local dpi = require('beautiful').xresources.apply_dpi

local left_panel = function(screen)
	
	local action_bar_width = dpi(45)
	local panel_content_width = dpi(350)

	local panel =
		wibox {
		screen = screen,
		width = action_bar_width,
		type = 'dock',
		height = screen.geometry.height,
		x = screen.geometry.x,
		y = screen.geometry.y,
		ontop = true,
		bg = beautiful.background,
		fg = beautiful.fg_normal
	}

	panel.opened = false

	panel:struts(
		{
			left = action_bar_width
		}
	)

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
		_G.awesome.spawn(
			apps.default.rofiweb,
			false,
			false,
			false,
			false,
			function()
				panel:toggle()
			end
		)
		
		-- Hide panel content if rofi web search is opened
		panel:get_children_by_id('panel_content')[1].visible = false
	end

	local openPanel = function(should_run_rofi)
		panel.width = action_bar_width + panel_content_width
		backdrop.visible = true
		panel.visible = false
		panel.visible = true
		panel:get_children_by_id('panel_content')[1].visible = true
		if should_run_rofi then
			panel:run_rofi()
		end
		panel:emit_signal('opened')
	end

	local closePanel = function()
		panel.width = action_bar_width
		panel:get_children_by_id('panel_content')[1].visible = false
		backdrop.visible = false
		panel:emit_signal('closed')
	end

	-- Hide this panel when app dashboard is called.
	function panel:HideDashboard()
		closePanel()
	end

	function panel:toggle(should_run_rofi)
		self.opened = not self.opened
		if self.opened then
			openPanel(should_run_rofi)
		else
			closePanel()
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
