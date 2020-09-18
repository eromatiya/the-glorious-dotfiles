local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi

local notif_header = wibox.widget {
	text   = 'Notification Center',
	font   = 'Inter Bold 14',
	align  = 'left',
	valign = 'center',
	widget = wibox.widget.textbox
}

local notif_center = function(s)

	s.clear_all = require('widget.notif-center.clear-all')
	s.notifbox_layout = require('widget.notif-center.build-notifbox').notifbox_layout

	return wibox.widget {
		{
			{
				expand = 'none',
				layout = wibox.layout.fixed.vertical,
				spacing = dpi(10),
				{
					layout = wibox.layout.align.horizontal,
					expand = 'none',
					notif_header,
					nil,
					s.clear_all
				},
				s.notifbox_layout
			},
			margins = dpi(10),
			widget = wibox.container.margin
		},
		border_width	= 	dpi(1),
		border_color 	= 	beautiful.groups_title_bg,
		bg = beautiful.groups_bg,
		shape = function(cr, w, h)
			gears.shape.rounded_rect(cr, w, h, beautiful.groups_radius)
		end,
		widget = wibox.container.background
	}
end

return notif_center