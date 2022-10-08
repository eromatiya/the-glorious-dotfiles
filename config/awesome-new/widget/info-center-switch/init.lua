local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widget.clickable-container')

-- Variable used for switching panel modes
right_panel_mode = 'today_mode'

local active_button    = beautiful.groups_title_bg
local inactive_button  = beautiful.transparent

local notif_text = wibox.widget
{
	text 	= 	'Notifications',
	font   	= 	'Inter Bold 11',
	align  	= 	'center',
	valign 	= 	'center',
	widget 	= 	wibox.widget.textbox
}

local notif_button = clickable_container(
	wibox.container.margin(
		notif_text, dpi(0), dpi(0), dpi(7), dpi(7)
	)
)

local wrap_notif = wibox.widget {
	notif_button,
	forced_width 	= 	dpi(140),
	bg 				= 	inactive_button,
	border_width	= 	dpi(1),
	border_color 	= 	beautiful.groups_title_bg,
	shape 			= 	function(cr, width, height) 
							gears.shape.partially_rounded_rect(
								cr, width, height, false, true, true, false, beautiful.groups_radius
							)
						end,
	widget 			= 	wibox.container.background
}

local today_text = wibox.widget {
	text 	= 	'Today',
	font   	= 	'Inter Bold 11',
	align  	= 	'center',
	valign 	= 	'center',
	widget 	=	wibox.widget.textbox
}

local today_button = clickable_container(
	wibox.container.margin(
		today_text, dpi(0), dpi(0), dpi(7), dpi(7)
	)
)

local wrap_today = wibox.widget {
	today_button,
	forced_width 	=	dpi(140),
	bg 				= 	active_button,
	border_width 	= 	dpi(1),
	border_color 	= 	beautiful.groups_title_bg,
	shape 			=	function(cr, width, height) 
							gears.shape.partially_rounded_rect(
								cr, width, height, true, false, false, true, beautiful.groups_radius
							) 
						end,
	widget 			= wibox.container.background
}

local switcher = wibox.widget {
	expand		=	'none',
	layout 		=	wibox.layout.fixed.horizontal,
	wrap_today,
	wrap_notif
}

function switch_rdb_pane(right_panel_mode)

	local focused = awful.screen.focused()
	
	if right_panel_mode == 'notif_mode' then
	
		-- Update button color
		wrap_notif.bg = active_button
		wrap_today.bg = inactive_button
	
		-- Change panel content of right-panel.lua
		focused.right_panel:switch_pane(right_panel_mode)
	
	elseif right_panel_mode == 'today_mode' then
	
		-- Update button color
		wrap_notif.bg = inactive_button
		wrap_today.bg = active_button
	
		-- Change panel content of right-panel.lua
		focused.right_panel:switch_pane(right_panel_mode)
	end
end

notif_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				switch_rdb_pane('notif_mode')
			end
		)
	)
)

today_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				switch_rdb_pane('today_mode')
			end
		)
	)
)

return switcher
