local awful = require('awful')
local top_panel = require('layout.top-panel')
local bottom_panel = require('layout.bottom-panel')
local control_center = require('layout.control-center')
local info_center = require('layout.info-center')

-- Create a wibox panel for each screen and add it
screen.connect_signal(
	'request::desktop_decoration',
		function(s)

		s.top_panel = top_panel(s)
		s.bottom_panel = bottom_panel(s)
		s.control_center = control_center(s)
		s.info_center = info_center(s)
		s.control_center_show_again = false
		s.info_center_show_again = false
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
			if s.control_center then
				if fullscreen and focused.control_center.visible then
					focused.control_center:toggle()
					focused.control_center_show_again = true

				elseif not fullscreen and
					not focused.control_center.visible and
					focused.control_center_show_again then
					
					focused.control_center:toggle()
					focused.control_center_show_again = false
				end
			end
			if s.info_center then
				if fullscreen and focused.info_center.visible then
					focused.info_center:toggle()
					focused.info_center_show_again = true

				elseif not fullscreen and
					not focused.info_center.visible and
					focused.info_center_show_again then
					
					focused.info_center:toggle()
					focused.info_center_show_again = false
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
