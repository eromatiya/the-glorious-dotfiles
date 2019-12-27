--[[
    _                                       __        ____  __ 
   / \__      _____  ___  ___  _ __ ___   __\ \      / /  \/  |
  / _ \ \ /\ / / _ \/ __|/ _ \| '_ ` _ \ / _ \ \ /\ / /| |\/| |
 / ___ \ V  V /  __/\__ \ (_) | | | | | |  __/\ V  V / | |  | |
/_/   \_\_/\_/ \___||___/\___/|_| |_| |_|\___| \_/\_/  |_|  |_|

--]]



local gears = require('gears')
local awful = require('awful')
local beautiful = require('beautiful')
require('awful.autofocus')

-- Theme
beautiful.init(require('theme'))

-- Layout
require('layout')

-- Init all modules
require('module.notifications')
require('module.auto-start')
require('module.decorate-client')
-- require('module.backdrop')
require('module.exit-screen')
require('module.quake-terminal')
require('module.titlebar')
-- require('module.menu')
require('module.volume-osd')
require('module.brightness-osd')
require('module.wallchange')
require('module.battery')

-- Setup all configurations
require('configuration.client')
require('configuration.tags')
_G.root.keys(require('configuration.keys.global'))


screen.connect_signal("request::wallpaper", function(s)
    -- If wallpaper is a function, call it with the screen
    if beautiful.wallpaper then
        if type(beautiful.wallpaper) == "string" then
            if beautiful.wallpaper:sub(1, #"#") == "#" then
                gears.wallpaper.set(beautiful.wallpaper)
            elseif beautiful.wallpaper:sub(1, #"/") == "/" then
                gears.wallpaper.maximized(beautiful.wallpaper, s)
            end
        else
            beautiful.wallpaper(s)
        end
    end
end)

-- Signal function to execute when a new client appears.
_G.client.connect_signal(
  'manage',
  function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not _G.awesome.startup then
      awful.client.setslave(c)
    end

    if _G.awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
    end
  end
)

-- Enable sloppy focus, so that focus follows mouse.

_G.client.connect_signal(
  'mouse::enter',
  function(c)
    c:emit_signal('request::activate', 'mouse_enter', {raise = true})
  end
)

_G.client.connect_signal(
  'focus',
  function(c)
    c.border_color = beautiful.border_focus
  end
)
_G.client.connect_signal(
  'unfocus',
  function(c)
    c.border_color = beautiful.border_normal
  end
)
