local wibox = require('wibox')
local gears = require('gears')
local awful = require('awful')
local beautiful = require('beautiful')

local spawn = awful.spawn

local dpi = beautiful.xresources.apply_dpi

local icons = require('theme.icons')

local slider = wibox.widget {
	nil,
	{
		id 					= 'brightness_slider',
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
	expand = 'none',
	layout = wibox.layout.align.vertical
}


local brightness_slider = slider.brightness_slider

brightness_slider:connect_signal(
	'property::value',
	function()

		local brightness_level = brightness_slider:get_value()
		
		spawn('xbacklight -set ' .. 
			math.max(brightness_level, 5),
			false
		)

		-- Update brightness osd
		awesome.emit_signal(
			'module::brightness_osd',
			brightness_level
		)
	end
)

brightness_slider:buttons(
	gears.table.join(
		awful.button(
			{},
			4,
			nil,
			function()
				if brightness_slider:get_value() > 100 then
					brightness_slider:set_value(100)
					return
				end
				brightness_slider:set_value(brightness_slider:get_value() + 5)
			end
		),
		awful.button(
			{},
			5,
			nil,
			function()
				if brightness_slider:get_value() < 0 then
					brightness_slider:set_value(0)
					return
				end
				brightness_slider:set_value(brightness_slider:get_value() - 5)
			end
		)
	)
)


local update_slider = function()
	awful.spawn.easy_async_with_shell(
		"xbacklight -get", 
		function(stdout)

			local brightness = string.match(stdout, '(%d+)')
			
			brightness_slider:set_value(tonumber(brightness))
		end
	)
end

-- Update on startup
update_slider()

-- The emit will come from the global keybind
awesome.connect_signal(
	'widget::brightness',
	function()
		update_slider()
	end
)

-- The emit will come from the OSD
awesome.connect_signal(
	'widget::brightness:update',
	function(value)
		 brightness_slider:set_value(tonumber(value))
	end
)


local brightness_setting = wibox.widget {
	{
		{
			{
				image = icons.brightness,
				resize = true,
				widget = wibox.widget.imagebox
			},
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

return brightness_setting
