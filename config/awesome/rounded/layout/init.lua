local awful = require('awful')
local bottom_panel = require('layout.bottom-panel')

-- Create a wibox for each screen and add it
screen.connect_signal("request::desktop_decoration", function(s)
  if s.index == 1 then
      -- Create the Bottom bar
      s.bottom_panel = bottom_panel(s, true)
    else
      -- Create the Bottom bar
      s.bottom_panel = bottom_panel(s, false)
    end
end)


-- Hide bars when app go fullscreen
function updateBarsVisibility()
  for s in screen do
    if s.selected_tag then
      local fullscreen = s.selected_tag.fullscreenMode
      -- Order matter here for shadow
      s.bottom_panel.visible = not fullscreen
    end
  end
end

_G.tag.connect_signal(
  'property::selected',
  function(t)
    updateBarsVisibility()
  end
)

_G.client.connect_signal(
  'property::fullscreen',
  function(c)
    if c.first_tag then
      c.first_tag.fullscreenMode = c.fullscreen
    end
    updateBarsVisibility()
  end
)

_G.client.connect_signal(
  'unmanage',
  function(c)
    if c.fullscreen then
      c.screen.selected_tag.fullscreenMode = false
      updateBarsVisibility()
    end
  end
)
