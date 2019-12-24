----------------------------------------------------------------------------
--- Wallpaper changer module
--
-- @author Gerome Matilla &lt;gerome.matilla07@gmail.com&gt;
-- @copyright 2019 Gerome Matilla
-- @module wallchange
--
--- Nevermind this. Do what you want.
----------------------------------------------------------------------------


-- This module changes wallpaper based on declared time
-- It checks the difference between the current time and the incoming specified time
-- Then convert it to seconds to set it as a timeout value
-- Limitation: Timeout paused when laptop/pc is suspended or in sleep mode, and there's probably some bugs so whatever

local filesystem = require('gears.filesystem')
local gears = require('gears')

-------------------------------------------------------
-- Configuration
-- Edit your preferences here
-------------------------------------------------------

--
-- Wallpaper  directory
-- filesystem.get_configuration_dir() is `$HOME/.config/awesome`
--
local wall_dir = filesystem.get_configuration_dir() .. 'theme/wallpapers/'
-- local wall_dir = os.getenv('HOME') .. 'Pictures/Wallpapers/'

-- Wallpapers filename
wallpaper_Day = 'day-wallpaper.jpg'
wallpaper_Noon = 'noon-wallpaper.jpg'
wallpaper_Night = 'night-wallpaper.jpg'
wallpaper_Midnight = 'midnight-wallpaper.jpg'

--
-- Time event: midnight, day time, noon time, night time
--

-- We just use this to check the incoming schedule to change wallpaper
-- Most likely, there's no reason to change this
local day_Time = 6
local noon_Time = 12
local night_Time = 17
local mid_night_Time = 0


-- This is the time/schedule where we change the wallpaper
-- Format: `HH:MM:SS`
-- 01:XX:XX - 24:XX:XX
-- Just don't F the time up, I don't have a data validation to check if you put an invalid time!
-- Make sure that the time event is always lower to the time/schedule
-- For example if you want to change the time for noon from `12:00:00` to `11:31:33`
-- Change its time event counter part `noon_Time`, to `11`
day_Schedule = '06:30:00'
noon_Schedule = '12:00:00'
night_Schedule = '17:30:00'
midnight_Schedule = '24:00:00'

-- Do not use 00:00:00 as midnight schedule as it will result in negative seconds lol
-- Use 24:00:00 instead


---------------------------------------------------------
-- Processes
-- Don't touch it if you don't know what you're doing
---------------------------------------------------------

-- Countdown variable
-- In seconds
change_wall_time = nil

-- Get the current Time
local current_time = function()
  return os.date("%H:%M:%S")
end


-- We will use an array for hour change and wallpaper string
-- And why the f is lua's array starts with `1`? lol
local wall_data = {}


-- Parse HH:MM:SS to seconds
local parse_To_Seconds = function(time)
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


-- Update timeout and wallpaper name here
local update_timeout = function()

  -- returns time table
  time = os.date("*t")
  -- Get HH in time table
  time = tonumber(time.hour)

  -- Midnight
  if time >= mid_night_Time and time < day_Time then
    -- Update current wallpaper
    update_current_wall(wallpaper_Midnight)

    -- Return day time and wall day to wall_data
    wall_data = {day_Schedule, wallpaper_Day}

  -- Morning/Day
  elseif time >= day_Time and time < noon_Time then
    -- Update current wallpaper
    update_current_wall(wallpaper_Day)

    -- Return noon time and wall noon to wall_data
    wall_data = {noon_Schedule, wallpaper_Noon}

  -- Noon/Afternoon
  elseif time >= noon_Time and time < night_Time then
    -- Update current wallpaper
    update_current_wall(wallpaper_Noon)

    -- Return night time and wall night to wall_data
    wall_data = {night_Schedule , wallpaper_Night}

  -- Night
  else
    -- Update current wallpaper
    update_current_wall(wallpaper_Night)

    -- Return midnight time and wall midning to wall_data
    wall_data = {midnight_Schedule, wallpaper_Midnight}

  end

  -- Get the difference function
  local diffSec = function(setSec, currSec)
    return (setSec - currSec)
  end

  -- Let's pass the time/schedule and the current time that we get from update_timeout
  -- And parse it to seconds to get the difference between time and use it as timeout of wall_updater timer below
  change_wall_time = diffSec(parse_To_Seconds(wall_data[1]), parse_To_Seconds(current_time()))

end

-- Update timeout to be use by timer below
update_timeout()

-- Update wallpaper in specified time
local wall_updater = gears.timer {
  -- The timeout is the difference of current time and the scheduled time we set above.
  timeout   = change_wall_time,
  autostart = true,
  call_now = true,
  callback  = function()
    -- Emit signal to update wallpaper
    awesome.emit_signal("module::change_wallpaper")
  end
}

-- Update wallpaper here and update the timeout for the next schedule
awesome.connect_signal("module::change_wallpaper", function()

  -- Update wallpaper
  gears.wallpaper.maximized (wall_dir .. wall_data[2], s)

  -- Update time for the next specified hour
  update_timeout()

  -- Update timer timeout for the next specified hour
  wall_updater.timeout = change_wall_time

  -- Restart timer
  wall_updater:again()

end)