local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widget.clickable-container')
local icons = require('theme.icons')
local spawn = require('awful.spawn')

screen.connect_signal('request::desktop_decoration', function(s)

	s.show_bri_osd = false

	local osd_header = wibox.widget {
		text = 'Brightness',
		font = 'Inter Bold 12',
		align = 'left',
		valign = 'center',
		widget = wibox.widget.textbox
	}

	local osd_value = wibox.widget {
		text = '0%',
		font = 'Inter Bold 12',
		align = 'center',
		valign = 'center',
		widget = wibox.widget.textbox
	}

	local slider_osd = wibox.widget {
		nil,
		{
			id 					= 'bri_osd_slider',
			bar_shape           = gears.shape.rounded_rect,
			bar_height          = dpi(24),
			bar_color           = '#ffffff20',
			bar_active_color	= '#f2f2f2EE',
			handle_color        = '#ffffff',
			handle_shape        = gears.shape.circle,
			handle_width        = dpi(24),
			handle_border_color = '#00000012',
			handle_border_width = dpi(1),
			maximum				= 100,
			widget              = wibox.widget.slider
		},
		nil,
		expand = 'none',
		layout = wibox.layout.align.vertical
	}

	local bri_osd_slider = slider_osd.bri_osd_slider

	-- Update brightness level using slider value
	bri_osd_slider:connect_signal(
		'property::value',
		function()
			local brightness_level = bri_osd_slider:get_value()
			spawn('light -S ' .. math.max(brightness_level, 5), false)

			-- Update textbox widget text
			osd_value.text = brightness_level .. '%'

			-- Update the brightness slider if values here change
			awesome.emit_signal('widget::brightness:update', brightness_level)

			if s.show_bri_osd then
				awesome.emit_signal(
					'module::brightness_osd:show', 
					true
				)
			end
		end
	)

	bri_osd_slider:connect_signal(
		'button::press',
		function()
			s.show_bri_osd = true
		end
	)

	bri_osd_slider:connect_signal(
		'mouse::enter',
		function()
			s.show_bri_osd = true
		end
	)

	-- The emit will come from brightness slider
	awesome.connect_signal(
		'module::brightness_osd',
		function(brightness)
			bri_osd_slider:set_value(brightness)
		end
	)

	local icon = wibox.widget {
		{
			image = icons.brightness,
			resize = true,
			widget = wibox.widget.imagebox
		},
		forced_height = dpi(150),
		top = dpi(12),
		bottom = dpi(12),
		widget = wibox.container.margin
	}

	-- Create the box
	local osd_height = dpi(250)
	local osd_width = dpi(250)

	local osd_margin = dpi(10)

	s.brightness_osd_overlay = awful.popup {
		widget = {
		  -- Removing this block will cause an error...
		},
		ontop = true,
		visible = false,
		type = 'notification',
		screen = s,
		height = osd_height,
		width = osd_width,
		maximum_height = osd_height,
		maximum_width = osd_width,
		offset = dpi(5),
		shape = gears.shape.rectangle,
		bg = beautiful.transparent,
		preferred_anchors = 'middle',
		preferred_positions = {'left', 'right', 'top', 'bottom'}
	}

	s.brightness_osd_overlay : setup {
		{
			{
				layout = wibox.layout.fixed.vertical,
				{
					{
						layout = wibox.layout.align.horizontal,
						expand = 'none',
						nil,
						icon,
						nil
					},
					{
						layout = wibox.layout.fixed.vertical,
						spacing = dpi(5),
						{
							layout = wibox.layout.align.horizontal,
							expand = 'none',
							osd_header,
							nil,
							osd_value
						},
						slider_osd
					},
					spacing = dpi(10),
					layout = wibox.layout.fixed.vertical
				},
			},
			left = dpi(24),
			right = dpi(24),
			widget = wibox.container.margin
		},
		bg = beautiful.background,
		shape = gears.shape.rounded_rect,
		widget = wibox.container.background()
	}

	local hide_osd = gears.timer {
		timeout = 2,
		autostart = true,
		callback  = function()
			awful.screen.focused().brightness_osd_overlay.visible = false
			s.show_bri_osd = false
		end
	}

	local timer_rerun = function()
		if hide_osd.started then
			hide_osd:again()
		else
			hide_osd:start()
		end
	end

	-- Reset timer on mouse hover
	s.brightness_osd_overlay:connect_signal(
		'mouse::enter', 
		function()
			s.show_bri_osd = true
			timer_rerun()
		end
	)

	local placement_placer = function()
		local focused = awful.screen.focused()
		local brightness_osd = focused.brightness_osd_overlay
		awful.placement.next_to(
            brightness_osd,
            {
                preferred_positions = 'top',
                preferred_anchors   = 'middle',
                geometry            = focused.bottom_panel or s,
                offset				= { x = 0, y = dpi(-20)}
            }
        )
	end

	awesome.connect_signal(
		'module::brightness_osd:show', 
		function(bool)
			placement_placer()
			awful.screen.focused().brightness_osd_overlay.visible = bool
			if bool then
				timer_rerun()
				awesome.emit_signal(
					'module::volume_osd:show',
					false
				)
			else
				if hide_osd.started then
					hide_osd:stop()
				end
			end
		end
	)

end)
