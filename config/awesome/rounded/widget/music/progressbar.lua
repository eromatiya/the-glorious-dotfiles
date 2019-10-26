local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi


local progressbar = wibox.widget {
    {
      id            = 'bar',
      max_value     = 100,
      forced_height = dpi(3),
      forced_width  = dpi(100),
      shape         = gears.shape.rounded_bar,
      color         = '#fdfdfd',
      widget        = wibox.widget.progressbar,
      background_color  = '#ffffff20'
    },
    layout = wibox.layout.stack
}

local timeStatus = wibox.widget {
    id                = 'statustime',
    font              = 'SFNS Display 10',
    align             = 'center',
    valign            = 'center',
    forced_height     = dpi(10),
    widget            =  wibox.widget.textbox
}

local timeDuration = wibox.widget {
    id                = 'durationtime',
    font              = 'SFNS Display 10',
    align             = 'center',
    valign            = 'center',
    forced_height     = dpi(10),
    widget            = wibox.widget.textbox
}

-- Update time progress every 5 seconds
local updateTime = gears.timer {
    timeout = 5,
    autostart = true,
    callback  = function()
      local cmd = "echo $(mpc status " .. " | " .. " awk 'NR==2 { split($3, a," .. ' "/"' .. "); " .. " print a[1]}') " .. " | " .. " tr -d '[\\%\\(\\)]'"
      awful.spawn.easy_async_with_shell(cmd, function( stdout )
         if stdout ~= nil then
           timeStatus.text = tostring(stdout)
         else
           timeStatus.text = tostring("00:00")
         end
         collectgarbage('collect')
      end)
    end
}

-- Update time duration on song change
local updateTimeDuration = gears.timer {
    timeout = 5,
    autostart = true,
    callback  = function()
      local cmd = "mpc --format %time% current"
      awful.spawn.easy_async_with_shell(cmd, function( stdout )
         if stdout ~= nil then
           timeDuration.text = tostring(stdout)
         else
           timeDuration.text = tostring("00:00")
         end
         collectgarbage('collect')
      end)
    end
}

-- Get the progress percentage of music
local updateBar = gears.timer {
    timeout = 5,
    autostart = true,
    callback  = function()
      local cmd = "echo $(mpc status " .. " | " .. " awk 'NR==2 { split($4, a); " .. " print a[1]}') " .. " | " .. " tr -d '[\\%\\(\\)]'"
      awful.spawn.easy_async_with_shell(cmd, function( stdout )
         if stdout ~= nil then
           progressbar.bar:set_value(tonumber(stdout))
         else
           progressbar.bar:set_value(0)
         end
      end)
    end
}

local musicBar =
  wibox.widget {
    wibox.container.margin(progressbar, dpi(15), dpi(15), dpi(10), dpi(0)),
    layout = wibox.layout.align.vertical,
    {
      layout = wibox.layout.align.horizontal,
      {
        wibox.container.margin(timeStatus, dpi(15), dpi(0), dpi(2)),
        layout = wibox.layout.fixed.horizontal,
      },
      nil,
      {
        wibox.container.margin(timeDuration, dpi(0), dpi(15), dpi(2)),
        layout = wibox.layout.fixed.horizontal,
      },
    },
  }

return musicBar
