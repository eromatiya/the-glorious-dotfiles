local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widget.blue-light.clickable-container')
local icons = require('theme.icons')
local blue_light_state = nil

local action_name = wibox.widget {
	text = 'Blue Light',
	font = 'Inter Regular 11',
	align = 'left',
	widget = wibox.widget.textbox
}

local button_widget = wibox.widget {
	{
		id = 'icon',
		image = icons.toggled_off,
		widget = wibox.widget.imagebox,
		resize = true
	},
	layout = wibox.layout.align.horizontal
}

local widget_button = wibox.widget {
	{
		button_widget,
		top = dpi(7),
		bottom = dpi(7),
		widget = wibox.container.margin
	},
	widget = clickable_container
}


local update_imagebox = function()
	local button_icon = button_widget.icon
	if blue_light_state then
		button_icon:set_image(icons.toggled_on)
	else
		button_icon:set_image(icons.toggled_off)
	end
end

local kill_state = function()
	awful.spawn.easy_async_with_shell(
		[[
		redshift -x
		kill -9 $(pgrep redshift)
		]],
		function(stdout)
			stdout = tonumber(stdout)
			if stdout then
				blue_light_state = false
				update_imagebox()
			end
		end
	)
end

kill_state()

local toggle_action = function()
	awful.spawn.easy_async_with_shell(
		[[
		if [ ! -z $(pgrep redshift) ];
		then
			redshift -x && pkill redshift && killall redshift
			echo 'OFF'
		else
			redshift -l 0:0 -t 4500:4500 -r &>/dev/null &
			echo 'ON'
		fi
		]],
		function(stdout)
			if stdout:match('ON') then
				blue_light_state = true
			else
				blue_light_state = false
			end
			update_imagebox()
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

local action_widget =  wibox.widget {
	{
		action_name,
		nil,
		{
			widget_button,
			layout = wibox.layout.fixed.horizontal,
		},
		layout = wibox.layout.align.horizontal,
	},
	left = dpi(24),
	right = dpi(24),
	forced_height = dpi(48),
	widget = wibox.container.margin
}

awesome.connect_signal(
	'widget::blue_light:toggle',
	function() 
		toggle_action()
	end
)

return action_widget
