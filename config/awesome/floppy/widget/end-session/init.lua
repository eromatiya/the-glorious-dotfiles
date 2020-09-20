local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widget.clickable-container')
local icons = require('theme.icons')

local create_widget = function()
	local exit_widget = {
		{
			{
				{
					image = icons.logout,
					resize = true,
					widget = wibox.widget.imagebox
				},
				top = dpi(12),
				bottom = dpi(12),
				widget = wibox.container.margin
			},
			{
				text = 'End work session',
				font = 'Inter Regular 12',
				align = 'left',
				valign = 'center',
				widget = wibox.widget.textbox
			},
			spacing = dpi(24),
			layout = wibox.layout.fixed.horizontal
		},
		left = dpi(24),
		right = dpi(24),
		forced_height = dpi(48),
		widget = wibox.container.margin
	}

	local exit_button = wibox.widget {
		{
			exit_widget,
			widget = clickable_container

		},
		bg = beautiful.groups_bg,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius) 
		end,
		widget = wibox.container.background
	}

	exit_button:buttons(
		awful.util.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					screen.primary.left_panel:toggle()
					awesome.emit_signal('module::exit_screen:show')
				end
			)
		)
	)

	return exit_button
end

return create_widget
