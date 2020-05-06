local awful = require('awful')
local top_panel = require('layout.top-panel')
local bottom_panel = require('layout.bottom-panel')
local floating_panel = require('layout.floating-panel')


-- Create a wibox panel for each screen and add it
screen.connect_signal("request::desktop_decoration", function(s)
	s.top_panel = top_panel(s, false)
	s.bottom_panel = bottom_panel(s)
	s.floating_panel = floating_panel(s)
	s.floating_panel_show_again = false
end)


-- Hide bars when app go fullscreen
function updateBarsVisibility()
	for s in screen do
		focused = awful.screen.focused()
		if s.selected_tag then
			local fullscreen = s.selected_tag.fullscreenMode
			-- Order matter here for shadow
			s.top_panel.visible = not fullscreen
			s.bottom_panel.visible = not fullscreen
			if s.floating_panel then
				if fullscreen and focused.floating_panel.visible then
					focused.floating_panel:toggle()
					focused.floating_panel_show_again = true
				elseif not fullscreen and not focused.floating_panel.visible and focused.floating_panel_show_again then
					focused.floating_panel:toggle()
					focused.floating_panel_show_again = false
				end
			end
		end
	end
end

tag.connect_signal(
	'property::selected',
	function(t)
		updateBarsVisibility()
	end
)

client.connect_signal(
	'property::fullscreen',
	function(c)
		if c.first_tag then
			c.first_tag.fullscreenMode = c.fullscreen
		end
		updateBarsVisibility()
	end
)

client.connect_signal(
	'unmanage',
	function(c)
		if c.fullscreen then
			c.screen.selected_tag.fullscreenMode = false
			updateBarsVisibility()
		end
	end
)
