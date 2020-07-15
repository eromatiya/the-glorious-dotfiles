local wibox = require('wibox')
local gears = require('gears')
local awful = require('awful')
local beautiful = require('beautiful')
local spawn = awful.spawn
local dpi = beautiful.xresources.apply_dpi
local icons = require('theme.icons')
local clickable_container = require('widget.clickable-container')

local icon = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		image = icons.volume,
		resize = true,
		widget = wibox.widget.imagebox
	},
	nil
}

local action_level = wibox.widget {
	{
		icon,
		widget = clickable_container,
	},
	bg = beautiful.transparent,
	shape = gears.shape.circle,
	widget = wibox.container.background
}

local slider = wibox.widget {
	nil,
	{
		id 					= 'volume_slider',
		bar_shape           = gears.shape.rounded_rect,
		bar_height          = dpi(2),
		bar_color           = '#ffffff20',
		bar_active_color	= '#f2f2f2EE',
		handle_color        = '#ffffff',
		handle_shape        = gears.shape.circle,
		handle_width        = dpi(15),
		handle_border_color = '#00000012',
		handle_border_width = dpi(1),
		maximum				= 100,
		widget              = wibox.widget.slider,
	},
	nil,
	forced_height = dpi(24),
	expand = 'none',
	layout = wibox.layout.align.vertical
}


local volume_slider = slider.volume_slider

volume_slider:connect_signal(
	'property::value',
	function()
		local volume_level = volume_slider:get_value()
		
		spawn('amixer -D pulse sset Master ' .. 
			volume_level .. '%',
			false
		)

		-- Update volume osd
		awesome.emit_signal(
			'module::volume_osd',
			volume_level
		)
	end
)

volume_slider:buttons(
	gears.table.join(
		awful.button(
			{},
			4,
			nil,
			function()
				if volume_slider:get_value() > 100 then
					volume_slider:set_value(100)
					return
				end
				volume_slider:set_value(volume_slider:get_value() + 5)
			end
		),
		awful.button(
			{},
			5,
			nil,
			function()
				if volume_slider:get_value() < 0 then
					volume_slider:set_value(0)
					return
				end
				volume_slider:set_value(volume_slider:get_value() - 5)
			end
		)
	)
)


local update_slider = function()
	awful.spawn.easy_async_with_shell(
		[[bash -c "amixer -D pulse sget Master"]],
		function(stdout)
			local volume = string.match(stdout, '(%d?%d?%d)%%')
			volume_slider:set_value(tonumber(volume))
		end
	)
end

-- Update on startup
update_slider()

local action_jump = function()
	local sli_value = volume_slider:get_value()
	local new_value = 0

	if sli_value >= 0 and sli_value < 50 then
		new_value = 50
	elseif sli_value >= 50 and sli_value < 100 then
		new_value = 100
	else
		new_value = 0
	end
	volume_slider:set_value(new_value)
end

action_level:buttons(
	awful.util.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				action_jump()
			end
		)
	)
)

-- The emit will come from the global keybind
awesome.connect_signal(
	'widget::volume',
	function()
		update_slider()
	end
)

-- The emit will come from the OSD
awesome.connect_signal(
	'widget::volume:update',
	function(value)
		volume_slider:set_value(tonumber(value))
	end
)

local volume_setting = wibox.widget {
	{
		{
			action_level,
			top = dpi(12),
			bottom = dpi(12),
			widget = wibox.container.margin
		},
		slider,
		spacing = dpi(24),
		layout = wibox.layout.fixed.horizontal

	},
	left = dpi(24),
	right = dpi(24),
	forced_height = dpi(48),
	widget = wibox.container.margin
}

return volume_setting
