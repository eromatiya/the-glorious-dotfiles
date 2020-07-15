local awful = require('awful')
local bottom_panel = require('layout.bottom-panel')
local right_panel = require('layout.right-panel')
local left_panel = require('layout.left-panel')

-- Create a wibox panel for each screen and add it
screen.connect_signal(
	'request::desktop_decoration',
	function(s)
		s.bottom_panel = bottom_panel(s)
		s.right_panel = right_panel(s)
		s.left_panel = left_panel(s)
		s.right_panel_show_again = false
		s.left_panel_show_again = false
	end
)

-- Hide bars when app go fullscreen
function update_bars_visibility()
	for s in screen do
		focused = awful.screen.focused()
		if s.selected_tag then
			local fullscreen = s.selected_tag.fullscreen_mode
			-- Order matter here for shadow
			s.bottom_panel.visible = not fullscreen
			if s.right_panel then
				if fullscreen and focused.right_panel.visible then
					focused.right_panel:toggle()
					focused.right_panel_show_again = true
				elseif not fullscreen and
					not focused.right_panel.visible and
					focused.right_panel_show_again then
					
					focused.right_panel:toggle()
					focused.right_panel_show_again = false
				end
			end
			if s.left_panel then
				if fullscreen and focused.left_panel.visible then
					focused.left_panel:toggle()
					focused.left_panel_show_again = true
				elseif not fullscreen and
					not focused.left_panel.visible and
					focused.left_panel_show_again then
					
					focused.left_panel:toggle()
					focused.left_panel_show_again = false
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
