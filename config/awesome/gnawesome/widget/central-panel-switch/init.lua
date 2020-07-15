local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widget.clickable-container')

-- Variable used for switching panel modes
local central_panel_mode = 'today_mode'

local active_button    = beautiful.groups_title_bg
local inactive_button  = beautiful.transparent

local settings_text = wibox.widget
{
	text 	= 	'Settings',
	font   	= 	'Inter Bold 11',
	align  	= 	'center',
	valign 	= 	'center',
	widget 	= 	wibox.widget.textbox
}

local settings_button = clickable_container(
	wibox.container.margin(
		settings_text, dpi(0), dpi(0), dpi(7), dpi(7)
	)
)

local wrap_settings = wibox.widget {
	settings_button,
	forced_width 	= 	dpi(93),
	bg 				= 	inactive_button,
	border_width	= 	dpi(1),
	border_color 	= 	beautiful.groups_title_bg,
	shape 			= 	function(cr, width, height) 
							gears.shape.partially_rounded_rect(
								cr, width, height, false, true, true, false, dpi(6)
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
	forced_width 	=	dpi(93),
	bg 				= 	active_button,
	border_width 	= 	dpi(1),
	border_color 	= 	beautiful.groups_title_bg,
	shape 			=	function(cr, width, height) 
							gears.shape.partially_rounded_rect(
								cr, width, height, true, false, false, true, dpi(6)
							) 
						end,
	widget 			= wibox.container.background
}

local switcher = wibox.widget {
	expand		=	'none',
	layout 		=	wibox.layout.fixed.horizontal,
	wrap_today,
	wrap_settings
}

function switch_rdb_pane(central_panel_mode)

	local focused = awful.screen.focused()
	
	if central_panel_mode == 'today_mode' then
	
		-- Update button color
		wrap_today.bg = active_button
		wrap_settings.bg = inactive_button
	
		-- Change panel content of floating-panel.lua
		focused.central_panel:switch_pane(central_panel_mode)

	elseif central_panel_mode == 'settings_mode' then
	
		-- Update button color
		wrap_today.bg = inactive_button
		wrap_settings.bg = active_button
	
		-- Change panel content of floating-panel.lua
		focused.central_panel:switch_pane(central_panel_mode)
	end
end

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

settings_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				switch_rdb_pane('settings_mode')
			end
		)
	)
)

return switcher
