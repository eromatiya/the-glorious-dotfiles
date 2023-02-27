local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local naughty = require('naughty')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widget.clickable-container')
local config_dir = gears.filesystem.get_configuration_dir()
local widget_dir = config_dir .. 'widget/dont-disturb/'
local widget_icon_dir = widget_dir .. 'icons/'
local icons = require('theme.icons')

_G.dont_disturb_state = false

local action_name = wibox.widget {
	text = 'Don\'t Disturb' ,
	font = 'Inter Bold 10',
	align = 'left',
	widget = wibox.widget.textbox
}

local action_status = wibox.widget {
	text = 'Off',
	font = 'Inter Regular 10',
	align = 'left',
	widget = wibox.widget.textbox
}

local action_info = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	action_name,
	action_status
}

local button_widget = wibox.widget {
	{
		id = 'icon',
		image = widget_icon_dir .. 'notify.svg',
		widget = wibox.widget.imagebox,
		resize = true
	},
	layout = wibox.layout.align.horizontal
}

local widget_button = wibox.widget {
	{
		{
			button_widget,
			margins = dpi(15),
			forced_height = dpi(48),
			forced_width = dpi(48),
			widget = wibox.container.margin
		},
		widget = clickable_container
	},
	bg = beautiful.groups_bg,
	shape = gears.shape.circle,
	widget = wibox.container.background
}

local update_widget = function()
	if dont_disturb_state then
		action_status:set_text('On')
		widget_button.bg = beautiful.system_cyan_dark
		button_widget.icon:set_image(widget_icon_dir .. 'dont-disturb.svg')
	else
		action_status:set_text('Off')
		widget_button.bg = beautiful.groups_bg
		button_widget.icon:set_image(widget_icon_dir .. 'notify.svg')
	end
end

local check_disturb_status = function()
	awful.spawn.easy_async_with_shell(
		'cat ' .. widget_dir .. 'disturb_status', 
		function(stdout)
			
			local status = stdout
			
			if status:match('true') then
				dont_disturb_state = true
			elseif status:match('false') then
				dont_disturb_state = false
			else
				dont_disturb_state = false
				awful.spawn.with_shell('echo \'false\' > ' .. widget_dir .. 'disturb_status')
			end

			update_widget()
		end
	)
end

check_disturb_status()

local toggle_action = function()
	if dont_disturb_state then
		dont_disturb_state = false
	else
		dont_disturb_state = true
	end
	awful.spawn.easy_async_with_shell(
		'echo ' .. tostring(dont_disturb_state) .. ' > ' .. widget_dir .. 'disturb_status',
		function()
			update_widget()
		end
	)
end

widget_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				toggle_action()
			end
		)
	)
)

action_info:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				toggle_action()
			end
		)
	)
)

local action_widget =  wibox.widget {
	layout = wibox.layout.fixed.horizontal,	
	spacing = dpi(10),
	widget_button,
	{
		layout = wibox.layout.align.vertical,
		expand = 'none',
		nil,
		action_info,
		nil
	}
}

-- Create a notification sound
naughty.connect_signal(
	'request::display', 
	function(n)
		if not dont_disturb_state then
			awful.spawn.with_shell('canberra-gtk-play -i message')
		end
	end
)

return action_widget
