local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widget.clickable-container')
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/tray-toggle/icons/'

local widget = wibox.widget {
	{
		id = 'icon',
		image = widget_icon_dir .. 'right-arrow' .. '.svg',
		widget = wibox.widget.imagebox,
		resize = true
	},
	layout = wibox.layout.align.horizontal
}

local widget_button = wibox.widget {
	{
		widget,
		margins = dpi(7),
		widget = wibox.container.margin
	},
	widget = clickable_container
}

widget_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				awesome.emit_signal('widget::systray:toggle')
			end
		)
	)
)

-- Listen to signal
awesome.connect_signal(
	'widget::systray:toggle',
	function()
		if screen.primary.systray then

			if not screen.primary.systray.visible then

				widget.icon:set_image(gears.surface.load_uncached(widget_icon_dir .. 'left-arrow.svg'))
			else

				widget.icon:set_image(gears.surface.load_uncached(widget_icon_dir .. 'right-arrow.svg'))
			end

			screen.primary.systray.visible = not screen.primary.systray.visible
		end
	end
)

-- Update icon on start-up
if screen.primary.systray then
	if screen.primary.systray.visible then
		widget.icon:set_image(widget_icon_dir .. 'right-arrow' .. '.svg')
	end
end

-- Show only the tray button in the primary screen
return awful.widget.only_on_screen(widget_button, 'primary')
