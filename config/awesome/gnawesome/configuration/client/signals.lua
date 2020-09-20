local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')

-- Signal function to execute when a new client appears.
client.connect_signal(
	'manage',
	function(c)
		-- Focus, raise and activate
		c:emit_signal(
			'request::activate',
			'mouse_enter',
			{
				raise = true
			}
		)

		-- Set the windows at the slave,
		-- i.e. put it at the end of others instead of setting it master.
		if not awesome.startup then
			awful.client.setslave(c)
		end

		if awesome.startup and not c.size_hints.user_position and
			not c.size_hints.program_position then
			
			-- Prevent clients from being unreachable after screen count changes.
			awful.placement.no_offscreen(c)
		end

		-- Spawn client with rounded corners (of course it will follow the theme.client_radius)
		-- if selected_tag is not maximized and round_corners = false
		local current_layout = awful.tag.getproperty(awful.screen.focused().selected_tag, 'layout')
		if not c.round_corners or (current_layout == awful.layout.suit.max and not c.floating) then return end
		c.shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, beautiful.client_radius or 6)
		end
	end
)

-- Enable sloppy focus, so that focus follows mouse then raises it.
client.connect_signal(
	'mouse::enter',
	function(c)
		c:emit_signal(
			'request::activate',
			'mouse_enter',
			{
				raise = true
			}
		)
	end
)

client.connect_signal(
	'focus',
	function(c)
		c.border_color = beautiful.border_focus
	end
)

client.connect_signal(
	'unfocus',
	function(c)
		c.border_color = beautiful.border_normal
	end
)

-- Manipulate client shape on fullscreen/non-fullscreen
client.connect_signal(
	'property::fullscreen',
	function(c)
		if c.fullscreen then
			c.shape = function(cr, width, height)
				gears.shape.rectangle(cr, width, height)
			end
		else
			local current_layout = awful.tag.getproperty(awful.screen.focused().selected_tag, 'layout')
			if (current_layout == awful.layout.suit.max) then
				c.shape = function(cr, width, height)
					gears.shape.rectangle(cr, width, height)
				end
			else
				c.shape = function(cr, width, height)
					gears.shape.rounded_rect(cr, width, height, beautiful.client_radius or 6)
				end
			end
		end
	end
)

-- Manipulate client shape on maximized
client.connect_signal(
	'property::maximized',
	function(c)
		local current_layout = awful.tag.getproperty(awful.screen.focused().selected_tag, 'layout')
		if c.maximized then
			c.shape = function(cr, width, height)
				gears.shape.rectangle(cr, width, height)
			end
		else
			if current_layout == awful.layout.suit.max then return end
			c.shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, beautiful.client_radius or 6)
			end
		end
	end
)

-- Manipulate client shape on floating
client.connect_signal(
	'property::floating',
	function(c)
		local current_layout = awful.tag.getproperty(awful.screen.focused().selected_tag, 'layout')
		if c.floating and not c.maximized then
			c.shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, beautiful.client_radius or 6)
			end
		else
			if current_layout == awful.layout.suit.max then
				c.shape = function(cr, width, height)
					gears.shape.rectangle(cr, width, height)
				end
			end
		end
	end
)
