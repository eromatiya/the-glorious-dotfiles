local wibox = require('wibox')
local beautiful = require('beautiful')

function build(widget)
	local container =
		wibox.widget {
		widget,
		widget = wibox.container.background
	}
	local old_cursor, old_wibox

	container:connect_signal(
		'mouse::enter',
		function()
			container.bg = beautiful.groups_bg
			-- Hm, no idea how to get the wibox from this signal's arguments...
			local w = mouse.current_wibox
			if w then
				old_cursor, old_wibox = w.cursor, w
				w.cursor = 'hand1'
			end
		end
	)

	container:connect_signal(
		'mouse::leave',
		function()
			container.bg = beautiful.transparent
			if old_wibox then
				old_wibox.cursor = old_cursor
				old_wibox = nil
			end
		end
	)

	container:connect_signal(
		'button::press',
		function()
			container.bg = beautiful.groups_title_bg
		end
	)

	container:connect_signal(
		'button::release',
		function()
			container.bg = beautiful.groups_bg
		end
	)

	return container
end

return build
