-- Added extension of decorate-client.lua due to the addition of titlebars.
-- Set your own rules here. This is a created for my workflow.
-- You are free to alter the codes or completely delete this

local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local theme_name = "stoplight"
local titlebar_icon_path = os.getenv("HOME") .. "/.config/awesome/theme/icons/titlebar/" .. theme_name .. '/'
local tip = titlebar_icon_path --alias to save time/space
local titlebars = {}
local theme = {}
local dpi = require('beautiful').xresources.apply_dpi


local roundCorners = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, beautiful.corner_radius)
end

_G.screen.connect_signal("arrange", function(s)

  for _, c in pairs(s.clients) do
    if (#s.tiled_clients > 1 or c.floating) and c.first_tag.layout.name ~= 'max' then
      awful.titlebar.show(c, 'left')
      if c.maximized then
	 c.shape = function(cr, w, h)
	   gears.shape.rectangle(cr, w, h)
	 end
      else 
	 c.shape = roundCorners
      end
      if c.floating then
         awful.placement.centered(c)
      end
    else if #s.tiled_clients == 1 or c.first_tag.layout.name == 'max' then
      awful.titlebar.hide(c, 'left')
      c.shape = function(cr, w, h)
        gears.shape.rectangle(cr, w, h)
      end
    end
  end
end
end)
