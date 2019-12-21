local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi

-- Create a table
local time_info = {}

time_status = wibox.widget {
	id                = 'statustime',
	text 							=	'00:00',
	font              = 'SFNS Display 8',
	align             = 'center',
	valign            = 'center',
	forced_height     =  dpi(10),
	widget            =  wibox.widget.textbox
}

local time_duration = wibox.widget {
	id                = 'durationtime',
	text 							=	'00:00',
	font              = 'SFNS Display 8',
	align             = 'center',
	valign            = 'center',
	forced_height     = dpi(10),
	widget            = wibox.widget.textbox
}




time_track = wibox.widget {
	expand = 'none',

	layout = wibox.layout.align.horizontal,
	-- {
	-- 	wibox.container.margin(time_status, dpi(15), dpi(0), dpi(2)),
	-- 	layout = wibox.layout.fixed.horizontal,
	-- },
	time_status,
	nil,
	-- {
	-- 	wibox.container.margin(time_duration, dpi(0), dpi(15), dpi(2)),
	-- 	layout = wibox.layout.fixed.horizontal,
	-- },
	time_duration,
}

time_info.time_status = time_status
time_info.time_duration = time_duration
time_info.time_track = time_track

return time_info