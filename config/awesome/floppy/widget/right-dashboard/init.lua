local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widget.clickable-container')

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/right-dashboard/icons/'



--    ▄▄▄▄    ▀                         ▀▀█          
--   █▀   ▀ ▄▄▄     ▄▄▄▄  ▄ ▄▄    ▄▄▄     █     ▄▄▄  
--   ▀█▄▄▄    █    █▀ ▀█  █▀  █  ▀   █    █    █   ▀ 
--       ▀█   █    █   █  █   █  ▄▀▀▀█    █     ▀▀▀▄ 
--   ▀▄▄▄█▀ ▄▄█▄▄  ▀█▄▀█  █   █  ▀▄▄▀█    ▀▄▄  ▀▄▄▄▀ 
--                  ▄  █                             
--                   ▀▀  

-- Create right panel and create also its behaviour

local right_panel = require('widget.right-dashboard.right-panel')

-- Create a wibox for each screen connected
screen.connect_signal("request::desktop_decoration", function(s)
	-- Create the right panel
	s.right_panel = right_panel(s)
	
	-- Create a show_again var for every screen
	s.show_again = false
end)

-- Hide panel when clients go fullscreen
function update_rightbar_visibility()
	for s in screen do
		focused = awful.screen.focused()
		if focused.selected_tag then
			local fullscreen = focused.selected_tag.fullscreenMode
			if s.right_panel then
				if fullscreen and focused.right_panel.visible then
					focused.right_panel:toggle()
					focused.show_again = true
				elseif not fullscreen and not focused.right_panel.visible and focused.show_again then
					focused.right_panel:toggle()
					focused.show_again = false
				end
			end
		end
	end
end


tag.connect_signal(
	'property::selected',
	function(t)
		update_rightbar_visibility()
	end
)

client.connect_signal(
	'property::fullscreen',
	function(c)
		if c.first_tag then
			c.first_tag.fullscreenMode = c.fullscreen
		end
		update_rightbar_visibility()
	end
)

client.connect_signal(
	'unmanage',
	function(c)
		if c.fullscreen then
			c.screen.selected_tag.fullscreenMode = false
			update_rightbar_visibility()
		end
	end
)


--   ▄▄▄▄▄           ▄      ▄                 
--   █    █ ▄   ▄  ▄▄█▄▄  ▄▄█▄▄   ▄▄▄   ▄ ▄▄  
--   █▄▄▄▄▀ █   █    █      █    █▀ ▀█  █▀  █ 
--   █    █ █   █    █      █    █   █  █   █ 
--   █▄▄▄▄▀ ▀▄▄▀█    ▀▄▄    ▀▄▄  ▀█▄█▀  █   █ 


-- The button in top panel

local return_button = function()

	local widget =
		wibox.widget {
		{
			id = 'icon',
			image = widget_icon_dir .. 'notification' .. '.svg',
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
					awful.screen.focused().right_panel:toggle()
				end
			)
		)
	)

	return widget_button

end


return return_button