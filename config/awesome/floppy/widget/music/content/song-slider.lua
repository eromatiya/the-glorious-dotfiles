local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi

vol_slider = wibox.widget {
	bar_shape           = gears.shape.rounded_rect,
	bar_height          = dpi(0),
	bar_color           = '#ffffff66',
	handle_color        = '#ffffff',
	handle_shape        = gears.shape.circle,
  handle_width        = dpi(15),
	handle_border_color = '#00000012',
	handle_border_width = dpi(1),
	maximum				      = 100,
	widget              = wibox.widget.slider,
}


vol_slider_bar = wibox.widget {
  {
    id            = 'sliderbar',
    max_value     = 100,
    shape         = gears.shape.rounded_bar,
    color         = '#ffffffAA',
    background_color  = '#ffffff20',
    forced_height = dpi(8),
    paddings      = 0,
    widget        = wibox.widget.progressbar,

  },
  top = dpi(12),
  bottom = dpi(12),
  widget =  wibox.container.margin
}

awful.spawn.easy_async_with_shell('mpc volume', function(stdout) 

  -- Get the current mpd volume
  vol_slider.value = tonumber(stdout:match('%d+'))
  vol_slider:get_children_by_id('sliderbar')[1].value = tonumber(stdout:match('%d+'))

end)

vol_slider:connect_signal(
  'property::value',
  function()
    awful.spawn('mpc volume ' .. vol_slider.value)
    vol_slider_bar:get_children_by_id('sliderbar')[1].value  = tonumber(vol_slider.value)
  end
)

local slider_volume = wibox.widget {
  vol_slider,
  vol_slider_bar,
  layout = wibox.layout.stack
}


return slider_volume

