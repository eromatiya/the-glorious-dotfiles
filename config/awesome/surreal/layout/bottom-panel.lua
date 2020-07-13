local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widget.clickable-container')

local tag_list = require('widget.tag-list')

local bottom_panel = function(s)

	local build_widget = function(widget)
		return wibox.widget {
			{
				widget,
				bg = beautiful.groups_title_bg,
				shape = function(cr, w, h)
					gears.shape.rounded_rect(cr, w, h, dpi(6))
				end,
				widget = wibox.container.background
			},
			top = dpi(10),
			bottom = dpi(10),
			widget = wibox.container.margin
		}
	end

	s.search = require('widget.search-apps')()
	
	local separator =  wibox.widget {
		orientation = 'vertical',
		forced_height = dpi(1),
		forced_width = dpi(1),
		span_ratio = 0.55,
		widget = wibox.widget.separator
	}

	local bottom_panel_height = dpi(56)
	local bottom_panel_margins = dpi(5)

	local panel = awful.popup {
		widget = {
			{
				layout = wibox.layout.fixed.horizontal,
				s.search,
				separator,
				tag_list(s),
				require('widget.xdg-folders')()
			},
			bg = beautiful.background,
			shape = function(cr, w, h)
				gears.shape.rounded_rect(cr, w, h, beautiful.groups_radius)
			end,
			widget = wibox.container.background
		},
		type = 'dock',
		screen = s,
		ontop = true,
		visible = true,
		height = bottom_panel_height,
		maximum_height = bottom_panel_height,
		placement = awful.placement.bottom,
		shape = gears.shape.rectangle,
		bg = beautiful.transparent
	}

	panel:struts
	{
		bottom = bottom_panel_height
	}

	return panel
end


return bottom_panel