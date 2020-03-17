local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi


local time_info = {}


time_status = wibox.widget {
	id                = 'statustime',
	text 			  =	'00:00',
	font              = 'SF Pro Text 8',
	align             = 'center',
	valign            = 'center',
	forced_height     =  dpi(10),
	widget            =  wibox.widget.textbox
}


local time_duration = wibox.widget {
	id                = 'durationtime',
	text 			  =	'00:00',
	font              = 'SF Pro Text 8',
	align             = 'center',
	valign            = 'center',
	forced_height     = dpi(10),
	widget            = wibox.widget.textbox
}


time_track = wibox.widget {
	expand = 'none',
	layout = wibox.layout.align.horizontal,
	time_status,
	nil,
	time_duration,
}


time_info.time_status = time_status
time_info.time_duration = time_duration
time_info.time_track = time_track

return time_info