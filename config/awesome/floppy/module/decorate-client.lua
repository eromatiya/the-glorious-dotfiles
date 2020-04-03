local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')

local function render_client(client, mode)
	
	if client.skip_decoration or (client.rendering_mode == mode) then
		return
	end

	client.rendering_mode = mode
	client.floating = false
	client.maximized = false
	client.above = false
	client.below = false
	client.ontop = false
	client.sticky = false
	client.maximized_horizontal = false
	client.maximized_vertical = false

	if client.rendering_mode == 'maximized' then
		client.border_width = 0
		client.shape = function(cr, w, h)
			gears.shape.rectangle(cr, w, h)
		end
	elseif client.rendering_mode ~= 'maximized' then
		client.border_width = beautiful.border_width
		client.shape = function(cr, w, h)
			gears.shape.rounded_rect(cr, w, h, beautiful.client_radius)
		end
	end

end

local changes_on_screen_called = false

local function changes_on_screen(current_screen)

	local tag_is_max = current_screen.selected_tag ~= nil and 
		current_screen.selected_tag.layout == awful.layout.suit.max

	local clients_to_manage = {}

	for _, client in pairs(current_screen.clients) do
		if not client.skip_decoration and not client.hidden then
			table.insert(clients_to_manage, client)
		end
	end

	if (tag_is_max or #clients_to_manage == 1) then
		current_screen.client_mode = 'maximized'
	else
		current_screen.client_mode = 'dwindle'
	end

	for _, client in pairs(clients_to_manage) do
		render_client(client, current_screen.client_mode)
	end
	changes_on_screen_called = false
end


function client_callback(client)
	if not changes_on_screen_called then
		if not client.skip_decoration and client.screen then
			changes_on_screen_called = true
			local screen = client.screen
			gears.timer.delayed_call(
				function()
					changes_on_screen(screen)
				end
			)
		end
	end
end

function tag_callback(tag)
	if not changes_on_screen_called then
		if tag.screen then
			changes_on_screen_called = true
			local screen = tag.screen
			gears.timer.delayed_call(
				function()
					changes_on_screen(screen)
				end
			)
		end
	end
end

client.connect_signal('manage', client_callback)

client.connect_signal('unmanage', client_callback)

client.connect_signal('property::hidden', client_callback)

client.connect_signal('property::minimized', client_callback)

client.connect_signal(
	'property::fullscreen',
	function(c)
		if c.fullscreen then
			render_client(c, 'maximized')
		else
			client_callback(c)
		end
	end
)

tag.connect_signal('property::selected', tag_callback)

tag.connect_signal('property::layout', tag_callback)
