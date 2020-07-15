local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi

local notif_header = wibox.widget {
	text   = 'Notification Center',
	font   = 'Inter Bold 16',
	align  = 'left',
	valign = 'bottom',
	widget = wibox.widget.textbox
}

local notif_center = function(s)

	s.dont_disturb = require('widget.notif-center.dont-disturb')
	s.clear_all = require('widget.notif-center.clear-all')
	s.notifbox_layout = require('widget.notif-center.build-notifbox').notifbox_layout

	return wibox.widget {
		expand = 'none',
		layout = wibox.layout.fixed.vertical,
		spacing = dpi(10),
		{
			expand = 'none',
			layout = wibox.layout.align.horizontal,
			notif_header,
			nil,
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = dpi(5),
				s.dont_disturb,
				s.clear_all
			},
		},
		s.notifbox_layout
	}
end

return notif_center