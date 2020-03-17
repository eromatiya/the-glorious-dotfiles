local wibox = require('wibox')
local gears = require('gears')
local awful = require('awful')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi

local icons = require('theme.icons')

local slider = wibox.widget {
	nil,
	{
		id 					= 'blur_strength_slider',
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

local blur_slider = slider.blur_strength_slider


local update_slider_value = function()

	awful.spawn.easy_async_with_shell(
		[[
		grep -F 'strength =' .config/awesome/configuration/picom.conf | awk 'NR==1 {printf $3}' | tr -d ';'
		]],
		function(stdout)
			blur_strength = tonumber(stdout) / 20 * 100
			blur_slider:set_value(tonumber(blur_strength))
		end
	)
end

-- Update slider value
update_slider_value()

local adjust_blur = function(power)

	awful.spawn.easy_async_with_shell(
		[[
		picom_dir=/home/gerome/.config/awesome/configuration/picom.conf 
		sed -i 's/.*strength = .*/    strength = ]] .. power .. [[;/g' "${picom_dir}"
		]],
		function(stdout, stderr)
		end
	)
end


blur_slider:connect_signal(
	'property::value',
	function()
		strength = blur_slider:get_value() / 50 * 10
		adjust_blur(strength)
	end
)

-- Adjust slider value to change blur strength
awesome.connect_signal('widget::blur:increase', function() 

	-- On startup, the slider.value returns nil so...
	if blur_slider:get_value() == nil then
		return
	end
 
	local blur_value = blur_slider:get_value() + 10

	-- No more than 100!
	if blur_value > 100 then
		blur_slider:set_value(100)
		return
	end

	blur_slider:set_value(blur_value)
end)

-- Decrease blur
awesome.connect_signal('widget::blur:decrease', function() 
	
	-- On startup, the slider.value returns nil so...
	if blur_slider:get_value() == nil then
		return
	end

	local blur_value = blur_slider:get_value() - 10

	-- No negatives!
	if blur_value < 0 then
		blur_slider:set_value(0)
		return
	end

	blur_slider:set_value(blur_value)
end)

local blur_slider_setting = wibox.widget {
	{
		{
			{
				image = icons.effects,
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


return blur_slider_setting
