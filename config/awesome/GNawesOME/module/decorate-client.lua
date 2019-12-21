local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')

local function renderClient(client, mode)
  if client.skip_decoration or (client.rendering_mode == mode) then
    return
  end

  client.rendering_mode = mode
  client.floating = false
  client.maximized = false
  client.above = false
  client.below = false
  client.ontop = false
  client.sticky = false
  client.maximized_horizontal = false
  client.maximized_vertical = false

  if client.rendering_mode == 'maximized' then
    client.border_width = 0
    client.shape = function(cr, w, h)
      gears.shape.rectangle(cr, w, h)
    end
  elseif client.rendering_mode == 'tiled' or client.rendering_mode == 'floating' or client.rendering_mode == 'dwindle' then
    client.border_width = beautiful.border_width
    client.shape = function(cr, w, h)
      gears.shape.rounded_rect(cr, w, h, beautiful.corner_radius)
    end
  end
end

local changesOnScreenCalled = false

local function changesOnScreen(currentScreen)
  local tagIsMax = currentScreen.selected_tag ~= nil and currentScreen.selected_tag.layout == awful.layout.suit.max
  local clientsToManage = {}

  for _, client in pairs(currentScreen.clients) do
    if not client.skip_decoration and not client.hidden then
      table.insert(clientsToManage, client)
    end
  end

  if (not tagIsMax or #clientsToManage == 1) then
    currentScreen.client_mode = 'dwindle'
  else
    currentScreen.client_mode = 'maximized'
  end

  for _, client in pairs(clientsToManage) do
    renderClient(client, currentScreen.client_mode)
  end
  changesOnScreenCalled = false
end


function clientCallback(client)
  if not changesOnScreenCalled then
    if not client.skip_decoration and client.screen then
      changesOnScreenCalled = true
      local screen = client.screen
      gears.timer.delayed_call(
        function()
          changesOnScreen(screen)
        end
      )
    end
  end
end

function tagCallback(tag)
  if not changesOnScreenCalled then
    if tag.screen then
      changesOnScreenCalled = true
      local screen = tag.screen
      gears.timer.delayed_call(
        function()
          changesOnScreen(screen)
        end
      )
    end
  end
end

_G.client.connect_signal('manage', clientCallback)

_G.client.connect_signal('unmanage', clientCallback)

_G.client.connect_signal('property::hidden', clientCallback)

_G.client.connect_signal('property::minimized', clientCallback)

_G.client.connect_signal(
  'property::fullscreen',
  function(c)
    if c.fullscreen then
      renderClient(c, 'maximized')
    else
      clientCallback(c)
    end
  end
)

_G.tag.connect_signal('property::selected', tagCallback)

_G.tag.connect_signal('property::layout', tagCallback)

_G.client.connect_signal('property::floating', function(c)

  if c.instance then
    if c.instance ~= 'QuakeTerminal' and not c.skip_center then
      awful.placement.centered(c)
    end
  end
end)

_G.screen.connect_signal("arrange", function(s)
for _, c in pairs(s.clients) do
    if (#s.tiled_clients > 1 or c.floating) and c.first_tag.layout.name ~= 'max' then
      if c.maximized or not c.round_corners or c.fullscreen then
        c.shape = function(cr, w, h)
          gears.shape.rectangle(cr, w, h)
        end
      else 
        c.shape = function(cr, width, height)
          gears.shape.rounded_rect(cr, width, height, beautiful.corner_radius)
        end
      end
    elseif #s.tiled_clients == 1 then
      if c.first_tag.layout.name == 'max' then
        c.shape = function(cr, w, h)
          gears.shape.rectangle(cr, w, h)
        end
      else
        c.shape = function(cr, width, height)
          gears.shape.rounded_rect(cr, width, height, beautiful.corner_radius)
        end
      end

    end
  end
end)

_G.client.connect_signal("manage", function(c)
  
  if c.floating and not c.skip_center then
    awful.placement.centered(c)
  end

end)