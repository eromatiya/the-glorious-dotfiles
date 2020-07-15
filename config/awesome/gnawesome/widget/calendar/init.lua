local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi

-- Calendar theme
local styles = {}

local rounded_shape = function(size, partial)
	if partial then
		return function(cr, width, height)
		gears.shape.partially_rounded_rect(cr, width, height,
			false, true, false, true, 5)
		end
	else
		return function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, size)
		end
	end
end

styles.month   = { 
	padding = 5,
	bg_color = '#00000000'
}

styles.normal  = {
	fg_color = '#f2f2f2',
	bg_color = '#00000000'
}

styles.focus   = {
	fg_color = '#f2f2f2',
	bg_color = beautiful.accent,
	markup   = function(t) return '<b>' .. t .. '</b>' end,
	shape 	 = function(cr, width, height)
					gears.shape.partially_rounded_rect(
						cr, width, height, true, true, true, true, dpi(4))
				end
}

styles.header  = {
	fg_color = '#f2f2f2',
	bg_color = '#00000000',
	markup   = function(t) return '<b>' .. t .. '</b>' end
}

styles.weekday = { 
	fg_color = '#ffffff',
	bg_color = '#00000000',
	markup   = function(t) return '<b>' .. t .. '</b>' end
}

local decorate_cell = function(widget, flag, date)

	if flag=='monthheader' and not styles.monthheader then
		flag = 'header'
	end
	local props = styles[flag] or {}
	if props.markup and widget.get_text and widget.set_markup then
		widget:set_markup(props.markup(widget:get_text()))
	end
	-- Change bg color for weekends
	local d = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
	local weekday = tonumber(os.date('%w', os.time(d)))
	local default_bg = (weekday==0 or weekday==6) and '#232323' or '#383838'
	local ret = wibox.widget {
		{
			widget,
			margins = (props.padding or 2) + (props.border_width or 0),
			widget  = wibox.container.margin
		},
		shape              = props.shape,
		shape_border_color = props.border_color or '#b9214f',
		shape_border_width = props.border_width or 0,
		fg                 = props.fg_color or '#999999',
		bg                 = props.bg_color or default_bg,
		widget             = wibox.container.background
	}
	return ret
end

local calendar = wibox.widget {
	{

		{
			font = 'Inter Regular 12',
			date = os.date('*t'),
			spacing = dpi(10),
			start_sunday = true,
			long_weekdays = false,
			fn_embed = decorate_cell,
			widget = wibox.widget.calendar.month
		},
		top = dpi(15),
		right = dpi(10),
		left = dpi(10),
		widget = wibox.container.margin
	},
	bg = beautiful.groups_title_bg,
	shape = function(cr, w, h)
		gears.shape.rounded_rect(cr, w ,h, beautiful.groups_radius)
	end,
	widget = wibox.container.background
}

return calendar
