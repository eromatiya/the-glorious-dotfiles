local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = require('beautiful').xresources.apply_dpi

-- Client's shape
local round_corner_client = function(cr, width, height)
  gears.shape.rounded_rect(cr, width, height, beautiful.corner_radius)
end

-- Catch the Signal when a client is created
_G.client.connect_signal("manage", function(c)
  
  -- Center all clients with skip_center property on spawn
  if c.floating and not c.skip_center then
    awful.placement.centered(c)
  end

  -- Hide bars when client and layout is maximized
  if not c.max then
    awful.titlebar.show(c, 'left')
  else
    awful.titlebar.hide(c, 'left')
  end

end)

-- Catch the signal when a client's layout is changed
_G.screen.connect_signal("arrange", function(s)
  for _, c in pairs(s.clients) do
    if (#s.tiled_clients > 1 or c.floating) and c.first_tag.layout.name ~= 'max' then
      if not c.hide_titlebars then
        awful.titlebar.show(c, 'left')
      else 
        awful.titlebar.hide(c, 'left')
      end
      if c.maximized or not c.round_corners or c.fullscreen then
        c.shape = function(cr, w, h)
          gears.shape.rectangle(cr, w, h)
        end
      else 
        c.shape = round_corner_client
      end
    elseif (#s.tiled_clients == 1 or c.first_tag.layout.name == 'max') and not c.fullscreen then
      awful.titlebar.hide(c, 'left')
      c.shape = function(cr, w, h)
        gears.shape.rectangle(cr, w, h)
      end
    end
  end
end)

-- Catch the signal when client is maximized
_G.client.connect_signal("property::maximized", function(c)
  
  -- Make the client rectangle
  c.shape = function(cr, w, h)
    gears.shape.rectangle(cr, w, h)
  end

  if not c.maximized then
    -- Return rounded corners on unmaximized
    c.shape = round_corner_client
  end
end)


-- Catch the signal when client is floating
_G.client.connect_signal("property::floating", function(c)

  -- Make sure to have an instance name
  -- It is here to prevent errors on startup or every after awesome.restart()
  if c.instance then
    -- Center all clients except QuakeTerminal and the clients with skip_center property
    if c.instance ~= 'QuakeTerminal' and not c.skip_center then
      awful.placement.centered(c)
    end
  end
end)
