local awful = require('awful')
local top_panel = require('layout.top-panel')
local bottom_panel = require('layout.bottom-panel')
local central_panel =  require('layout.central-panel')

-- Create a wibox panel for each screen and add it
screen.connect_signal(
	'request::desktop_decoration',
	function(s)
		s.top_panel = top_panel(s)
		s.bottom_panel = bottom_panel(s)
		s.central_panel = central_panel(s)
	end
)

-- Hide bars when app go fullscreen
function update_bars_visibility()
	for s in screen do
		focused = awful.screen.focused()
		if s.selected_tag then
			local fullscreen = s.selected_tag.fullscreen_mode
			-- Order matter here for shadow
			s.top_panel.visible = not fullscreen
			s.bottom_panel.visible = not fullscreen
			if s.central_panel then
				if fullscreen and focused.central_panel.visible then
					focused.central_panel:toggle()
					focused.central_panel_show_again = true
				elseif not fullscreen and
					not focused.central_panel.visible and
					focused.central_panel_show_again then
					
					focused.central_panel:toggle()
					focused.central_panel_show_again = false
				end
			end
		end
	end
end

tag.connect_signal(
	'property::selected',
	function(t)
		update_bars_visibility()
	end
)

client.connect_signal(
	'property::fullscreen',
	function(c)
		if c.first_tag then
			c.first_tag.fullscreen_mode = c.fullscreen
		end
		update_bars_visibility()
	end
)

client.connect_signal(
	'unmanage',
	function(c)
		if c.fullscreen then
			c.screen.selected_tag.fullscreen_mode = false
			update_bars_visibility()
		end
	end
)
