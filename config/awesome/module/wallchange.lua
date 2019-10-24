-- This module changes wallpaper based on declared time
-- Note that this module will not change the wallpaper at the exact time
-- Because it only checks the time every 10 minutes/600 seconds
-- So the wallpaper will change only within the first 10 mins of the hour

local filesystem = require('gears.filesystem')
local wall_dir = filesystem.get_configuration_dir() .. '/theme/wallpapers/'
local gears = require('gears')
local awful = require('awful')


-- Change hour from 00-23
local dayTime = 6
local noonTime = 12
local nightTime = 18
local midNight = 00
local checkTimePer = 600 -- seconds

function timeChecker()
  time = os.date("*t")
    time = time.hour
    -- Morning
    if tonumber(time) >= dayTime and tonumber(time) < noonTime then
      gears.wallpaper.maximized (wall_dir .. 'day-wallpaper.jpg', s)
    -- Noon
    elseif tonumber(time) >= noonTime and tonumber(time) < nightTime then
      gears.wallpaper.maximized (wall_dir .. 'noon-wallpaper.jpg', s)
    -- Evening
    elseif tonumber(time) >= nightTime then
      gears.wallpaper.maximized (wall_dir .. 'night-wallpaper.jpg', s)
    -- Midnight
    else
      gears.wallpaper.maximized (wall_dir .. 'midnight-wallpaper.jpg', s)
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
