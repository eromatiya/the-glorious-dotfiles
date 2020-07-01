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
-- It checks the difference between the current time and the next scheduled time
-- Then convert it to seconds to set it as a timeout value

-- Limitations: 
-- Timeout paused when laptop/pc is suspended or in sleep mode, and there's probably some bugs too so whatever

local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local filesystem = gears.filesystem

--  ========================================
-- 				Configuration
--	     Change your preference here
--  ========================================

-- Wallpaper directory. The default is:
local wall_dir = filesystem.get_configuration_dir() .. 'theme/wallpapers/'
-- local wall_dir = os.getenv('HOME') .. 'Pictures/Wallpapers/'

-- Table mapping schedule to wallpaper filename
-- Note:
-- Default image format is jpg
local wallpaper_schedule = {
	['00:00:00'] = 'midnight-wallpaper.jpg',
	['06:22:00'] = 'morning-wallpaper.jpg',
	['12:00:00'] = 'noon-wallpaper.jpg',
	['17:58:00'] = 'night-wallpaper.jpg',
}

-- Don't stretch wallpaper on multihead setups if true
local dont_stretch_wallpaper = false

--  ========================================
-- 				   Processes
--	    Don't touch it if it's working
--  ========================================

-- Get current time
local current_time = function()
  	return os.date('%H:%M:%S')
end

-- Countdown variable
-- In seconds
local the_countdown = nil

-- We will use a table for hour change and wallpaper string
-- Element 0 errm 1 will store the incoming/next scheduled time
-- Geez why the f is lua's array starts with `1`? lol
-- Element 2 will have the wallpaper file name
local wall_data = {}
-- > Why array, you say? 
-- Because why not? I'm new to lua and I'm experimenting with it

-- Parse HH:MM:SS to seconds
local parse_to_seconds = function(time)

  	-- Convert HH in HH:MM:SS
  	local hour_sec = tonumber(string.sub(time, 1, 2)) * 3600

  	-- Convert MM in HH:MM:SS
  	local min_sec = tonumber(string.sub(time, 4, 5)) * 60

	-- Get SS in HH:MM:SS
	local get_sec = tonumber(string.sub(time, 7, 8))

	-- Return computed seconds
    return (hour_sec + min_sec + get_sec)
end

-- Get time difference
local time_diff = function(current, schedule)
	local diff = parse_to_seconds(current) - parse_to_seconds(schedule)
	return diff
end

-- Set wallpaper
local set_wallpaper = function(path)
	if dont_stretch_wallpaper then
		for s in screen do
			-- Update wallpaper based on the data in the array
			gears.wallpaper.maximized (path, s)
		end
	else
		-- Update wallpaper based on the data in the array
		gears.wallpaper.maximized (path)
	end
end

-- Update wallpaper (used by the manage_timer function)
-- I think the gears.wallpaper.maximized is too fast or being ran asynchronously
-- So the wallpaper is not being updated on awesome (re)start without this timer
-- We need some delay.
-- Hey it's working, so whatever
local update_wallpaper = function(wall_name)
	local wall_dir = wall_dir .. wall_name
	set_wallpaper(wall_dir)

	-- Overwrite the default wallpaper
	-- This is important in case we add an extra monitor
	beautiful.wallpaper = wall_dir
end

-- Updates variables
local manage_timer = function()
	-- Get current time
	local time_now = parse_to_seconds(current_time())

	local previous_time = '' --Scheduled time that should activate now
	local next_time = '' --Time that should activate next
	-- Warning: This may rely on the wallpaper schedules being in order (of time)
	for time, wallpaper in pairs(wallpaper_schedule) do
		-- This finds the closest schedule time that is before the current time
		if time_now < parse_to_seconds(time) then
			next_time = time
			break
		else
			previous_time = time
		end
	end

	-- If next time is blank, that must mean that all of the times are before
	-- the current time. Therefore, the clock needs to wrap around
	if next_time == '' then
		-- As far as I can tell, this is the only way to get the first table element :/
		for time, wallpaper in pairs(wallpaper_schedule) do
			next_time = time
			break
		end
	end

	-- Update Wallpaper
	update_wallpaper(wallpaper_schedule[previous_time])

	-- Set the data for the next scheduled time
	wall_data = {next_time, wallpaper_schedule[next_time]}
	
	-- Get the time difference to set as timeout for the wall_updater timer below
	the_countdown = time_diff(wall_data[1], current_time())
end

-- Update values at startup
manage_timer()

local wall_updater = gears.timer {
	-- The timeout is the difference of current time and the scheduled time we set above.
	timeout   = the_countdown,
	autostart = true,
	call_now = true,
	callback  = function()
		-- Emit signal to update wallpaper
    	awesome.emit_signal('module::change_wallpaper')
  	end
}

-- Update wallpaper here and update the timeout for the next schedule
awesome.connect_signal(
	'module::change_wallpaper',
	function()
		set_wallpaper(wall_dir .. wall_data[2])

		-- Update values for the next specified schedule
		manage_timer()

		-- Update timer timeout for the next specified schedule
		wall_updater.timeout = the_countdown

		-- Restart timer
		wall_updater:again()
	end
)
