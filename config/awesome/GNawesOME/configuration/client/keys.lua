local awful = require('awful')
local gears = require('gears')
require('awful.autofocus')
local modkey = require('configuration.keys.mod').modKey
local altkey = require('configuration.keys.mod').altKey

local clientKeys =
  awful.util.table.join(
  awful.key(
    {modkey},
    'f',
    function(c)
      -- Toggle fullscreen
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    {description = 'toggle fullscreen', group = 'client'}
  ),
  awful.key(
    {modkey},
    'q',
    function(c)
      -- Close client
      c:kill()
    end,
    {description = 'close', group = 'client'}
  ),
  awful.key(
    {modkey},
    'c',
    function(c)
      -- The client just stretch when switching to floating while in maximized/fullscreen mode
      -- So tell to client to stop being a dick err I mean fullscreen/maximized to switch to floating without the said stretching
      c.fullscreen = false
      c.maximized = false
      -- Toggle floating
      c.floating = not c.floating
      c:raise()
    end,
    {description = 'toggle floating', group = 'client'}
  )
)

return clientKeys
