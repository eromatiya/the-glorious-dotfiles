-- This module changes wallpaper based on declared time
-- Note that this module will not change the wallpaper accurately
-- Because it only checks the time every 10 minutes/600 seconds
-- So the wallpaper will change only within the first 10 mins of the hour

local filesystem = require('gears.filesystem')
local wall_dir = filesystem.get_configuration_dir() .. '/theme/wallpapers/'
local gears = require('gears')
local awful = require('awful')


-- Change hour from 00-23
local hour = 19
local checkTimePer = 600 -- seconds

function timeChecker()
  time = os.date("*t")
    time = time.hour
    -- Change to night-wallpaper when it's 7PM.
    if tonumber(time) >= hour then
      gears.wallpaper.maximized (wall_dir .. 'night-wallpaper.jpg', s)
    else
      gears.wallpaper.maximized (wall_dir .. 'day-wallpaper.jpg', s)
    end
end

-- Check time every 10 mins
local runCheck = gears.timer {
  timeout   = checkTimePer,
  autostart = true,
  call_now = true,
  callback  = function()
    timeChecker()
  end
}

-- Run Once On Start-up
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
