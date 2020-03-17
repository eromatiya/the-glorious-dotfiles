local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')

local clickable_container = require('widget.window-effects.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi

local filesystem = gears.filesystem
local config_dir = filesystem.get_configuration_dir()

local icons = require('theme.icons')

local apps = require('configuration.apps')

local frame_status = nil



local action_name = wibox.widget {
	text = 'Blur Effects',
	font = 'SF Pro Text Regular 11',
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
	if action_status then
		button_widget.icon:set_image(icons.toggled_on)
	else
		button_widget.icon:set_image(icons.toggled_off)
	end
end



local check_blur_status = function()
	awful.spawn.easy_async_with_shell(
		[[
		grep -F 'method = "none";' ]] .. config_dir .. [[/configuration/picom.conf | tr -d '[\"\;\=\ ]'
		]], 
		function(stdout)
		
			if stdout:match('methodnone') then
				action_status = false
			else
				action_status = true
			end
		 
			update_imagebox()
		end
	)
end


check_blur_status()


local toggle_blur = function(togglemode)

	local toggle_blur_script = [[
	picom_dir=$HOME/.config/awesome/configuration/picom.conf

	# Check picom if it's not running then start it
	if [ -z $(pgrep picom) ]; then
		picom -b --experimental-backends --dbus --config ]] .. config_dir .. [[/configuration/picom.conf
	fi

	case ]] .. togglemode .. [[ in
		'enable')
		sed -i -e 's/method = "none"/method = "dual_kawase"/g' "${picom_dir}"
		;;
		'disable')
		sed -i -e 's/method = "dual_kawase"/method = "none"/g' "${picom_dir}"
		;;
	esac
	]]

	-- Run the script
	awful.spawn.easy_async_with_shell(
		toggle_blur_script, 
		function(stdout, stderr)

		end
	)

end

local toggle_blur_fx = function()
	local state = nil
	if action_status then
		action_status = false
		state = 'disable'
	else
		action_status = true
		state = 'enable'
	end
	toggle_blur(state)
	update_imagebox()
end

widget_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				toggle_blur_fx()
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
	'widget::blur:toggle', 
	function() 
		toggle_blur_fx()
	end
)


return action_widget
