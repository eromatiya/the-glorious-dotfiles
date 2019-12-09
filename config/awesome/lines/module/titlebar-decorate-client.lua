local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = require('beautiful').xresources.apply_dpi

local roundCorners = function(cr, width, height)
  gears.shape.rounded_rect(cr, width, height, beautiful.corner_radius)
end

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
    if (#s.tiled_clients > 1 or c.floating) and c.first_tag.layout.name ~= 'max' then
      if not c.hide_titlebars then
      awful.titlebar.show(c, 'left')
    else 
    awful.titlebar.hide(c, 'left')
    end
    if c.floating and not c.skip_center then
    awful.placement.centered(c)
    end
      if c.maximized or not c.round_corners then
        c.shape = function(cr, w, h)
          gears.shape.rectangle(cr, w, h)
        end
      else 
        c.shape = roundCorners
      end
    elseif #s.tiled_clients == 1 or c.first_tag.layout.name == 'max' then
      awful.titlebar.hide(c, 'left')
      c.shape = function(cr, w, h)
        gears.shape.rectangle(cr, w, h)
      end
    end
  end
end)
