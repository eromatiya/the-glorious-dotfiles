-- This module changes wallpaper based on declared time
-- It checks the difference between the current time and the incoming specified time
-- Then convert it to seconds to set it as a countdown value
-- Much better than my previous implementation w/c checks the time every 10 seconds

local filesystem = require('gears.filesystem')
local wall_dir = filesystem.get_configuration_dir() .. 'theme/wallpapers/'
local gears = require('gears')


-- Countdown variable
-- In seconds
change_wall_time = nil

-- Current Time
local current_time = function()
  return os.date("%H:%M:%S")
end

-- Variables to check the incoming specified hour
-- Make sure to set the varieables the  same as specified hours
local mNightTime = 0
local dayTime = 6
local noonTime = 12
local nightTime = 18

-- Specified Hours
-- Change Wall in this Hour
-- format: `HH:MM:SS`
-- 01:XX:XX - 24:XX:00
changeWallDay = '06:00:00'
changeWallNoon = '12:00:00'
changeWallNight= '18:00:00'
changeWallMNight = '24:00:00'

-- As you can see, we use 24 in midNightChange as hour
-- We did this to prevent negative numbers if we use 00:00:00


dayWallpaper = 'day-wallpaper.jpg'
noonWallpaper = 'noon-wallpaper.jpg'
nightWallpaper = 'night-wallpaper.jpg'
mNightWallpaper = 'midnight-wallpaper.jpg'


-- We will use an array for hour change and wallpaper string
-- And why the f is lua's array starts with `1`? lol
local wall_data = {}


-- Parse HH:MM:SS to seconds
local parseToSec = function(time)
  -- Convert to seconds --
  -- Convert HH in HH:MM:SS
  hourInSec = tonumber(string.sub(time, 1, 2)) * 3600

  -- Convert MM in HH:MM:SS
  minInSec = tonumber(string.sub(time, 4, 5)) * 60

  -- Get SS in HH:MM:SS
  getSec = tonumber(string.sub(time, 7, 8))

  return (hourInSec + minInSec + getSec)

end


-- We need this to load the wallpaper for the current time
-- IDK why awesome doesn't load the `gears.wallpaper.maximized (wall_dir .. wallname, s)` alone
-- So that's why we created this gears.timer function
local update_current_wall = function(wallname)
  
  gears.timer {
    timeout   = 0,
    call_now  = true,
    autostart = true,
    callback  = function()
      gears.wallpaper.maximized (wall_dir .. wallname, s)
    end,
    single_shot = true
  }

end

local update_timeout = function()
  -- returns time table
  time = os.date("*t")
  -- Get HH in time table
  time = tonumber(time.hour)

  -- Midnight
  if time >= 0 and time < dayTime then
    -- naughty.notify({text = 'MIDNIGHT'})
    -- Update current wallpaper
    update_current_wall(mNightWallpaper)

    -- Return day time and wall day to wall_data
    wall_data = {changeWallDay, dayWallpaper}

  -- Morning/Day
  elseif time >= dayTime and time < noonTime then
    -- naughty.notify({text = 'MORNING'})
    -- Update current wallpaper
    update_current_wall(dayWallpaper)

    -- Return noon time and wall noon to wall_data
    wall_data = {changeWallNoon, noonWallpaper}

  -- Noon/Afternoon
  elseif time >= noonTime and time < nightTime then
    -- naughty.notify({text = 'NOON'})
    -- Update current wallpaper
    update_current_wall(noonWallpaper)

    -- Return night time and wall night to wall_data
    wall_data = {changeWallNight, nightWallpaper}

  -- Night
  else
    -- naughty.notify({text = 'NIGHT'})
    -- Update current wallpaper
    update_current_wall(nightWallpaper)

    -- Return midnight time and wall midning to wall_data
    wall_data = {changeWallMNight, mNightWallpaper}

  end


  -- Get the difference function
  local diffSec = function(setSec, currSec)
    return (setSec - currSec)
  end

  -- Pass the time_data and the current time 
  -- To get the time difference
  change_wall_time = diffSec(parseToSec(wall_data[1]), parseToSec(current_time()))

end


-- Update timeout to be use by timer below
update_timeout()



-- Update wallpaper in specified time
local wall_updater = gears.timer {
  timeout   = change_wall_time,
  autostart = true,
  call_now = true,
  callback  = function()
    -- Emit signal to update wallpaper
    awesome.emit_signal("change_wallpaper")
  end
}


awesome.connect_signal("change_wallpaper", function(n)

  -- Update wallpaper
  gears.wallpaper.maximized (wall_dir .. wall_data[2], s)

  -- Update time for the next specified hour
  update_timeout()

  -- Update timer timeout for the next specified hour
  wall_updater.timeout = change_wall_time

  -- Restart timer
  wall_updater:again()

end)

