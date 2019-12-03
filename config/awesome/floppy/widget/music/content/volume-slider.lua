local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi

local slider = {}

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


local slider_volume = wibox.widget {
  vol_slider,
  vol_slider_bar,
  layout = wibox.layout.stack
}

slider.vol_slider = vol_slider
slider.vol_slider_bar = vol_slider_bar
slider.slider_volume = slider_volume

return slider

