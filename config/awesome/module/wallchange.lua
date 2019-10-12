local filesystem = require('gears.filesystem')
local wall_dir = filesystem.get_configuration_dir() .. '/theme/wallpapers/'
local gears = require('gears')
local awful = require('awful')

function timeChecker()
  time = os.date("*t")
    time = time.hour
    if tonumber(time) >= 19 then
      gears.wallpaper.maximized (wall_dir .. 'night-wallpaper.jpg', s)
    else
      gears.wallpaper.maximized (wall_dir .. 'day-wallpaper.jpg', s)
    end
end

-- Check time every 10 mins
local runCheck = gears.timer {
  timeout   = 600,
  autostart = true,
  call_now = true,
  callback  = function()
    timeChecker()
  end
}

-- Run Once When Invoked
local runOnce = gears.timer {
  timeout   = 0,
  call_now  = true,
  autostart = true,
  callback  = function()
    timeChecker()
  end,
  single_shot = true
}

--
-- run:start()
_G.timeChecker()
