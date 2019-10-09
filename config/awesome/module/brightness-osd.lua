-- Load these libraries (if you haven't already)
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local watch = require('awful.widget.watch')
local beautiful = require('beautiful')
local dpi = require('beautiful').xresources.apply_dpi


local vol_osd = require('widget.brightness.brightness-slider')


awful.screen.connect_for_each_screen(
  function(s)
    -- Create the box

    local offsetx = dpi(56)
    local offsety = dpi(300)
    brightnessOverlay = wibox(
      {
        visible = nil,
        ontop = true,
        type = "normal",
        height = offsety,
        width = 48,
        x = s.geometry.width - offsetx,
        y = (s.geometry.height / 2) - (offsety / 2),
      }
    )
  end
)



-- Place it at the center of the screen
--awful.placement.centered(brightnessOverlay)

-- Set transparent bg
brightnessOverlay.bg = "#00000000"

-- Put its items in a shaped container
brightnessOverlay:setup {
    -- Container
    {
        -- Items go here
        --wibox.widget.textbox("Hello!"),
        wibox.container.rotate(vol_osd,'east'),
        -- ...
        layout = wibox.layout.fixed.vertical
    },
    -- The real background color
    bg = "#000000".. "66",
    -- The real, anti-aliased shape
    shape = gears.shape.rounded_rect,
    widget = wibox.container.background()
}


local hideOSD = gears.timer {
    timeout = 3,
    autostart = true,
    callback  = function()
      brightnessOverlay.visible = false
    end
  }


function toggleBriOSD(bool)
  brightnessOverlay.visible = bool
  if bool then
    hideOSD:again()
    toggleVolOSD(false)
  else
    hideOSD:stop()
  end
end


-- awful.widget.watch('', 5),

return brightnessOverlay
