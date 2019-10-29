-- Addition to decorate-client.lua due to the addition of titlebars.
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
--

-- Show the titlebar if it's not maximized layout
_G.tag.connect_signal("property::layout", function(t)
    local clients = t:clients()
    for k,c in pairs(clients) do
        if c.first_tag.layout.name ~= "max" then
            awful.titlebar.show(c, 'left')
        else
            awful.titlebar.hide(c, 'left')
        end
    end
end)

-- On Spawn
_G.client.connect_signal("manage", function(c)
    if not c.max then
        awful.titlebar.show(c, 'left')
    else
        awful.titlebar.hide(c, 'left')
    end
end)

 _G.screen.connect_signal("arrange", function(s)
   for _, c in pairs(s.clients) do
     if c.floating then
       awful.titlebar.show(c, 'left')
       c.shape = roundCorners
     elseif #s.tiled_clients == 1 or #s.tiled_clients == 0 then
       awful.titlebar.hide(c, 'left')
       c.shape = gears.shape.rectangle
     elseif #s.tiled_clients >= 1 and c.max then
       awful.titlebar.hide(c, 'left')
       c.shape = gears.shape.rectangle
     elseif #s.tiled_clients >= 2 and not c.max then
       awful.titlebar.show(c, 'left')
       c.shape = roundCorners
    end
   end
 end)

 _G.client.connect_signal("property::floating", function(c)
     if c.floating then
       awful.titlebar.show(c, 'left')
       awful.placement.centered(c)
     end
 end)
