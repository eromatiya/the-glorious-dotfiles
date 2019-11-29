local awful = require('awful')
local naughty = require('naughty')
local wibox = require('wibox')
local clickable_container = require('widget.material.clickable-container')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local mat_list_item = require('widget.material.list-item')
local beautiful = require('beautiful')

local clear_all_button = wibox.widget {

	wibox.widget {
		text   = 'Clear all notifications',
		font   = 'SFNS Display Regular 12',
    align  = 'center',
		valign = 'center',
		widget = wibox.widget.textbox
	},
	forced_height = dpi(12),
	clickable = true,
	widget = mat_list_item
}


clear_all_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				_G.clear_all()
				_G.firstime = true
			end
			)
		)
	)


local clear_button_wrapped = wibox.widget {
	{
		clear_all_button,
		bg = beautiful.bg_modal, 
		shape = function(cr, w, h)
		gears.shape.rounded_rect(cr, w, h, beautiful.modal_radius)
	end,
	widget = wibox.container.background,
},
widget = mat_list_item,
}

return clear_button_wrapped