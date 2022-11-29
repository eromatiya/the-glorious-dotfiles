local awful = require("awful")
local path_to_file = ...

local top_panel = require(path_to_file .. ".top-panel")
local bottom_panel = require(path_to_file .. ".bottom-panel")
local control_center = require(path_to_file .. ".control-center")
local info_center = require(path_to_file .. ".info-center")
local theme_picker = require("widget.theme-picker")
-- Create a wibox panel for each screen and add it
screen.connect_signal("request::desktop_decoration", function(s)
	s.top_panel = top_panel(s)
	s.bottom_panel = bottom_panel(s)
	s.control_center = control_center(s)
	s.info_center = info_center(s)
	s.theme_picker = theme_picker(s)
	s.control_center_show_again = false
	s.info_center_show_again = false
end)

-- Hide bars when app go fullscreen
function update_bars_visibility()
	for s in screen do
		if s.selected_tag then
			local fullscreen = s.selected_tag.fullscreen_mode
			-- Order matter here for shadow
			s.top_panel.visible = not fullscreen
			s.bottom_panel.visible = not fullscreen
			if s.control_center then
				if fullscreen and s.control_center.visible then
					s.control_center:toggle()
					s.control_center_show_again = true
				elseif not fullscreen and not s.control_center.visible and s.control_center_show_again then
					s.control_center:toggle()
					s.control_center_show_again = false
				end
			end
			if s.info_center then
				if fullscreen and s.info_center.visible then
					s.info_center:toggle()
					s.info_center_show_again = true
				elseif not fullscreen and not s.info_center.visible and s.info_center_show_again then
					s.info_center:toggle()
					s.info_center_show_again = false
				end
			end
		end
	end
end

tag.connect_signal("property::selected", function(t)
	update_bars_visibility()
end)

client.connect_signal("property::fullscreen", function(c)
	if c.first_tag then
		c.first_tag.fullscreen_mode = c.fullscreen
	end
	update_bars_visibility()
end)

client.connect_signal("unmanage", function(c)
	if c.fullscreen then
		c.screen.selected_tag.fullscreen_mode = false
		update_bars_visibility()
	end
end)
