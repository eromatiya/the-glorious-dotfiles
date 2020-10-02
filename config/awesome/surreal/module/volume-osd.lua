local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widget.clickable-container')
local icons = require('theme.icons')
local spawn = require('awful.spawn')

local osd_header = wibox.widget {
	text = 'Volume',
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
		id 					= 'vol_osd_slider',
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

local vol_osd_slider = slider_osd.vol_osd_slider

vol_osd_slider:connect_signal(
	'property::value',
	function()
		local volume_level = vol_osd_slider:get_value()
		spawn('amixer -D pulse sset Master ' .. volume_level .. '%', false)

		-- Update textbox widget text
		osd_value.text = volume_level .. '%'

		-- Update the volume slider if values here change
		awesome.emit_signal('widget::volume:update', volume_level)

		if awful.screen.focused().show_vol_osd then
			awesome.emit_signal(
				'module::volume_osd:show', 
				true
			)
		end
	end
)

vol_osd_slider:connect_signal(
	'button::press',
	function()
		awful.screen.focused().show_vol_osd = true
	end
)

vol_osd_slider:connect_signal(
	'mouse::enter',
	function()
		awful.screen.focused().show_vol_osd = true
	end
)

-- The emit will come from volume slider
awesome.connect_signal(
	'module::volume_osd',
	function(volume)
		vol_osd_slider:set_value(volume)
	end
)

local icon = wibox.widget {
	{
		image = icons.volume,
		resize = true,
		widget = wibox.widget.imagebox
	},
	forced_height = dpi(150),
	top = dpi(12),
	bottom = dpi(12),
	widget = wibox.container.margin
}

local osd_height = dpi(250)
local osd_width = dpi(250)
local osd_margin = dpi(10)

screen.connect_signal(
	'request::desktop_decoration',
	function(s)
		local s = s or {}
		s.show_vol_osd = false

		s.volume_osd_overlay = awful.popup {
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

		s.volume_osd_overlay : setup {
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

		-- Reset timer on mouse hover
		s.volume_osd_overlay:connect_signal(
			'mouse::enter', 
			function()
				s.show_vol_osd = true
				awesome.emit_signal('module::volume_osd:rerun')
			end
		)
	end
)

local hide_osd = gears.timer {
	timeout = 2,
	autostart = true,
	callback  = function()
		local focused = awful.screen.focused()
		focused.volume_osd_overlay.visible = false
		focused.show_vol_osd = false
	end
}

awesome.connect_signal(
	'module::volume_osd:rerun',
	function()
		if hide_osd.started then
			hide_osd:again()
		else
			hide_osd:start()
		end
	end
)

local placement_placer = function()
	local focused = awful.screen.focused()
	local volume_osd = focused.volume_osd_overlay
	awful.placement.next_to(
		volume_osd,
		{
			preferred_positions = 'top',
			preferred_anchors = 'middle',
			geometry = focused.bottom_panel or s,
			offset = { x = 0, y = dpi(-20)}
		   }
	   )
end

awesome.connect_signal(
	'module::volume_osd:show', 
	function(bool)
		placement_placer()
		awful.screen.focused().volume_osd_overlay.visible = bool
		if bool then
			awesome.emit_signal('module::volume_osd:rerun')
			awesome.emit_signal(
				'module::brightness_osd:show',
				false
			)
		else
			if hide_osd.started then
				hide_osd:stop()
			end
		end
	end
)
