local awful = require("awful")
local path_to_file = ...
local top_panel = require(path_to_file .. ".top-panel")
local bottom_panel = require(path_to_file .. ".bottom-panel")
local central_panel = require(path_to_file .. ".central-panel")
local theme_picker = require("widget.theme-picker")

-- Create a wibox panel for each screen and add it
-- awful.screen.connect_for_each_screen(function(s)
-- 	print("decor")
-- 	-- Create the top panel
-- 	s.top_panel = top_panel(s)
-- 	-- Create the bottom panel
-- 	s.bottom_panel = bottom_panel(s)
-- 	-- Create the central panel
-- 	s.central_panel = central_panel(s)
-- end)
screen.connect_signal("request::desktop_decoration", function(s)
	s.top_panel = top_panel(s)
	s.bottom_panel = bottom_panel(s)
	s.central_panel = central_panel(s)
	s.theme_picker = theme_picker(s)
end)

-- Hide bars when app go fullscreen
function update_bars_visibility()
	for s in screen do
		if s.selected_tag then
			local fullscreen = s.selected_tag.fullscreen_mode
			-- Order matter here for shadow
			s.top_panel.visible = not fullscreen
			s.bottom_panel.visible = not fullscreen
			if s.central_panel then
				if fullscreen and s.central_panel.visible then
					s.central_panel:toggle()
					s.central_panel_show_again = true
				elseif not fullscreen and not s.central_panel.visible and s.central_panel_show_again then
					s.central_panel:toggle()
					s.central_panel_show_again = false
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
