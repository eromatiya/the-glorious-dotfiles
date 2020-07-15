local awful = require('awful')
local naughty = require('naughty')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widget.clickable-container')

local config_dir = gears.filesystem.get_configuration_dir()

local widget_dir = config_dir .. 'widget/notif-center/dont-disturb/'
local widget_icon_dir = config_dir .. 'widget/notif-center/icons/'

_G.dont_disturb = false

local dont_disturb_imagebox = wibox.widget {
	{
		id = 'icon',
		image = widget_icon_dir .. 'dont-disturb-mode.svg',
		resize = true,
		forced_height = dpi(20),
		forced_width = dpi(20),
		widget = wibox.widget.imagebox,
	},
	layout = wibox.layout.fixed.horizontal
}

local function update_icon()

	local widget_icon_name = nil
	local dd_icon = dont_disturb_imagebox.icon

	if dont_disturb then
		widget_icon_name = 'toggled-on'
		dd_icon:set_image(widget_icon_dir .. 'dont-disturb-mode.svg')
	else
		widget_icon_name = 'toggled-off'
		dd_icon:set_image(widget_icon_dir .. 'notify-mode.svg')
	end
end

local check_disturb_status = function()
	
	awful.spawn.easy_async_with_shell(
		'cat ' .. widget_dir .. 'disturb_status', 
		function(stdout)
			
			local status = stdout
			
			if status:match('true') then
				dont_disturb = true
			elseif status:match('false') then
				dont_disturb = false
			else
				dont_disturb = false
				awful.spawn.with_shell('echo "false" > ' .. widget_dir .. 'disturb_status')
			end

			update_icon()
		end
	)
end

check_disturb_status()

local toggle_disturb = function()
	if dont_disturb then
		dont_disturb = false
	else
		dont_disturb = true
	end
	awful.spawn.with_shell('echo "' .. tostring(dont_disturb) .. '" > ' .. widget_dir .. 'disturb_status')
	update_icon()
end

local dont_disturb_button = wibox.widget {
	{
		dont_disturb_imagebox,
		margins = dpi(7),
		widget = wibox.container.margin
	},
	widget = clickable_container
}

dont_disturb_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				toggle_disturb()
			end
		)
	)
)

local dont_disturb_wrapped = wibox.widget {
	nil,
	{
		dont_disturb_button,
		bg = beautiful.groups_bg,
		border_width = dpi(1),
		border_color = beautiful.groups_title_bg,
		shape = gears.shape.circle,
		widget = wibox.container.background
	},
	nil,
	expand = 'none',
	layout = wibox.layout.align.vertical
}

-- Create a notification sound
naughty.connect_signal(
	'request::display', 
	function(n)
		if not dont_disturb then
			awful.spawn.with_shell('canberra-gtk-play -i message')
		end
	end
)

return dont_disturb_wrapped