local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local wibox = require('wibox')
local dpi = beautiful.xresources.apply_dpi

awful.titlebar.enable_tooltip = true
awful.titlebar.fallback_name  = 'Client'

local titlebar_size = beautiful.titlebar_size

local double_click_event_handler = function(double_click_event)
	if double_click_timer then
		double_click_timer:stop()
		double_click_timer = nil
		double_click_event()
		return
	end
	double_click_timer = gears.timer.start_new(
		0.20,
		function()
			double_click_timer = nil
			return false
		end
	)
end

client.connect_signal(
	'request::titlebars',
	function(c)
		local buttons = gears.table.join(
			awful.button(
				{}, 
				1, 
				function()
					double_click_event_handler(function()
						if c.floating then
							c.floating = false
							return
						end
						c.maximized = not c.maximized
						c:raise()
						return
					end)
					c:activate {context = 'titlebar', action = 'mouse_move'}
				end
			),
			awful.button(
				{}, 
				3, 
				function()
					c:activate {context = 'titlebar', action = 'mouse_resize'}
				end
			)
		)

		awful.titlebar(c, {position = 'left', bg = '#000000AA', size = titlebar_size}) : setup {
			{
				{
					awful.titlebar.widget.closebutton(c),
					awful.titlebar.widget.maximizedbutton(c),
					awful.titlebar.widget.minimizebutton(c),
					spacing = dpi(7),
					layout  = wibox.layout.fixed.vertical
				},
				margins = dpi(10),
				widget = wibox.container.margin
			},
			{
				buttons = buttons,
				layout = wibox.layout.flex.vertical
			},
			{
				{
					awful.titlebar.widget.ontopbutton(c),
					awful.titlebar.widget.floatingbutton(c),
					spacing = dpi(7),
					layout  = wibox.layout.fixed.vertical
				},
				margins = dpi(10),
				widget = wibox.container.margin
			},
			layout = wibox.layout.align.vertical
		}
	end
)

