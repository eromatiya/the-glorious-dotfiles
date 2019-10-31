local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = require('beautiful').xresources.apply_dpi

local roundCorners = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, beautiful.corner_radius)
end

-- Show the titlebar if it's not maximized layout
_G.tag.connect_signal("property::layout", function(t)
    local clients = t:clients()
    for k,c in pairs(clients) do
        if c.first_tag.layout.name ~= "max" then
            awful.titlebar.show(c, 'top')
        else
            awful.titlebar.hide(c, 'top')
        end
    end
end)

-- On Spawn
_G.client.connect_signal("manage", function(c)
    if c.first_tag.layout.name ~= "max" then
        awful.titlebar.show(c, 'top')
    else
        awful.titlebar.hide(c, 'top')
    end
end)


-- This is a messy script on manipulating titlebars and window shape.
-- If you can fixed it please send a PR HAHAHA
-- Plan: If first_tag.layout.name is not max and tiled_clients >1 : Show Titlebars and make client shape rounded ? Hide and make the c.shape rectangle
_G.screen.connect_signal("arrange", function(s)

  for _, c in pairs(s.clients) do
    if #s.tiled_clients >= 0 and (c.floating or c.first_tag.layout.name == 'floating') then
      awful.titlebar.show(c, 'top')
      c.shape = roundCorners
    elseif #s.tiled_clients == 1 and c.fullscreen == true then
      awful.titlebar.show(c, 'top')
      c.shape = function(cr, w, h)
        gears.shape.rectangle(cr, w, h)
      end
    elseif #s.tiled_clients >= 1 and c.fullscreen == true then
      awful.titlebar.show(c, 'top')
      c.shape = function(cr, w, h)
        gears.shape.rectangle(cr, w, h)
      end
    elseif #s.tiled_clients >= 1 and c.maximized == true then
      if c.maximized then
      awful.titlebar.show(c, 'top')
      c.shape = function(cr, w, h)
        gears.shape.rectangle(cr, w, h)
      end
    end
    elseif #s.tiled_clients == 1 and c.first_tag.layout.name == 'dwindle' then
      awful.titlebar.hide(c, 'top')
      c.shape = function(cr, w, h)
        gears.shape.rectangle(cr, w, h)
      end
    elseif #s.tiled_clients > 1 and c.first_tag.layout.name == 'dwindle' then
      awful.titlebar.show(c, 'top')
      c.shape = roundCorners
    elseif #s.tiled_clients == 1 and c.first_tag.layout.name == 'tile' then
      awful.titlebar.hide(c, 'top')
      c.shape = function(cr, w, h)
        gears.shape.rectangle(cr, w, h)
      end
    elseif #s.tiled_clients > 1 and c.first_tag.layout.name == 'tile' then
      awful.titlebar.show(c, 'top')
      c.shape = roundCorners
    end
  end
end)

_G.client.connect_signal("property::floating", function(c)
    if c.floating then
      awful.titlebar.show(c, 'top')
      awful.placement.centered(c)

    else
      awful.titlebar.hide(c, 'top')
    end
end)
