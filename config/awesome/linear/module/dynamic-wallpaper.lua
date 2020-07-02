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
local naughty = require('naughty')


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
--[[
	['00:00:00'] = 'midnight-wallpaper.jpg',
	['06:22:00'] = 'morning-wallpaper.jpg',
	['12:00:00'] = 'noon-wallpaper.jpg',
	['17:58:00'] = 'night-wallpaper.jpg'
--]]
----[[
	'midnight',
	'morning',
	'noon',
	'afternoon',
	'evening',
	'night'
--]]
}

-- Update lockscreen background
local update_ls_bg = false

-- Update lockscreen background command
local update_ls_cmd = 'mantablockscreen --image'



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

-- Parse seconds to HH:MM:SS
local function parse_to_time(seconds)
	-- DST ruined me :(
	--return os.date("%H:%M:%S", seconds)

	local function format(str)
		while #str < 2 do
			str = '0' .. str
		end

		return str
	end

	local function convert(num)
		return format(tostring(num))
	end

	local hours = convert(math.floor(seconds / 3600))
	seconds = seconds - (hours * 3600)

	local minutes = convert(math.floor(seconds / 60))
	seconds = seconds - (minutes * 60)

	local seconds = convert(math.floor(seconds))

	return (hours .. ':' .. minutes .. ':' .. seconds)

end

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
local time_diff = function(future, past)
	local diff = parse_to_seconds(future) - parse_to_seconds(past)
	if diff < 0 then
		diff = diff + (24 * 3600) --If time difference is negative, the future is meant for tomorrow
	end
	return diff
end

-- Split string based on pattern
local function split(str, pat)
	local t = {}
	local i = 0
	local j = string.find(str, pat)
	while j ~= nil do
		table.insert(t, string.sub(str, i + 1, j - 1))

		i = j
		j = string.find(str, pat, i + 1)
	end
	table.insert(t, string.sub(str, i + 1, #str))

	return t
end

local function find_wallpapers(dir, keywords)
	naughty.notify({title = "FIND_WALLPAPERS", timeout = 0})

	local wallpaper_files = {}

	-- Command to give list of files in directory
	local dir_explore = 'find ' .. dir .. ' -printf "%f\\n"'
	local out = io.popen(dir_explore):read("a") --Done synchronously because we literally can't continue without files
	-- Split command output by line
	local lines = split(out, "\n")
	
	-- Looks for words (in order)
	for index, word in ipairs(keywords) do
		for _, line in ipairs(lines) do
			-- Split into non-letter parts here to prevent things like
			-- midnight and night both matching night
			for _, part in ipairs(split(line, "[^%a]")) do
				if line == word or part == word then
					--table.insert(wallpaper_files, line)
					wallpaper_files[word] = line
					break
				end
			end
		end
	end

	return wallpaper_files
end

-- Turn an ordered list of files into a scheduled list of files
local function auto_schedule(wall_list)
	local sched = {}
	for index, file in ipairs(wall_list) do
		local auto_time = parse_to_time(parse_to_seconds("24:00:00") * (index - 1) / #wall_list)
		sched[auto_time] = file
	end

	return sched
end

-- Reformat whatever schedule was specified into an actual schedule
if #wallpaper_schedule == 0 then
	local count = 0
	-- Determine if empty or if manual schedule
	for k, v in pairs(wallpaper_schedule) do
		count = count + 1
	end
	if count == 0 then --Schedule is actually empty
		--Find wallpapers without keywords and auto-schedule
	else --Schedule is manually timed
		-- Find files then remake schedule
		naughty.notify({title = "MANUAL", timeout = 0})
		local ordered_times = {}
		-- This is made just in case the schedule is specified out of order
		-- because of some sociopath
		for time, _ in pairs(wallpaper_schedule) do
			local pos = 1
			-- Add 1 to insert position for each time before "time"
			for time2, _ in pairs(wallpaper_schedule) do
				if parse_to_seconds(time2) < parse_to_seconds(time) then
					pos = pos + 1
				end
			end
			ordered_times[pos] = time
		end

		-- Get ordered list of keywords from ordered times
		local keywords = {}
		for index, time in ipairs(ordered_times) do
			keywords[index] = wallpaper_schedule[time]
		end

		-- Search for files using keywords
		local files = find_wallpapers(wall_dir, keywords)
		-- Replace keywords with files (or do nothing if it was already a filename)
		for index, time in ipairs(ordered_times) do
			local word = wallpaper_schedule[time]
			wallpaper_schedule[time] = files[word]
		end
	end
else --Schedule is list of keywords, find times and files
	naughty.notify({title = "KEYWORD-ONLY", timeout = 0})
	local ordered_files = {}
	local name_to_file = find_wallpapers(wall_dir, wallpaper_schedule)
	for index, word in ipairs(wallpaper_schedule) do
		local file = name_to_file[word]
		if file ~= nil then
			table.insert(ordered_files, file)
		end
	end

	wallpaper_schedule = auto_schedule(ordered_files)
end


-- Update wallpaper (used by the manage_timer function)
-- I think the gears.wallpaper.maximized is too fast or being ran asynchronously
-- So the wallpaper is not being updated on awesome (re)start without this timer
-- We need some delay.
-- Hey it's working, so whatever
local update_wallpaper = function(wall_name)
	local wall_dir = wall_dir .. wall_name
	set_wallpaper(wall_dir)

		local wall_full_path = wall_dir .. wall_name

		gears.wallpaper.maximized (wall_full_path, s)

		-- Overwrite the default wallpaper
		-- This is important in case we add an extra monitor
		beautiful.wallpaper = wall_full_path

		if update_ls_bg then
			awful.spawn.easy_async_with_shell(update_ls_cmd .. ' ' .. wall_full_path, function() 
				--
			end)
		end
	end)
end

-- Updates variables
local manage_timer = function()
	-- Get current time
	local time_now = parse_to_seconds(current_time())

	local previous_time = '' --Scheduled time that should activate now
	local next_time = '' --Time that should activate next

	local first_time = '24:00:00' --First scheduled time registered (to be found)
	local last_time = '00:00:00' --Last scheduled time registered (to be found)

	-- Find previous_time
	for time, wallpaper in pairs(wallpaper_schedule) do
		local parsed_time = parse_to_seconds(time)
		if previous_time == '' or parsed_time > parse_to_seconds(previous_time) then
			if parsed_time <= time_now then
				previous_time = time
			end
		end

		if parsed_time > parse_to_seconds(last_time) then
			last_time = time
		end
	end

	-- Previous time being blank = no scheduled time today. Therefore
	-- the last time was yesterday's latest time
	if previous_time == '' then
		previous_time = last_time
	end

	--Find next_time
	for time, wallpaper in pairs(wallpaper_schedule) do
		local parsed_time = parse_to_seconds(time)
		if next_time == '' or parsed_time < parse_to_seconds(next_time) then
			if parsed_time > time_now then
				next_time = time
			end
		end

		if parsed_time < parse_to_seconds(first_time) then
			first_time = time
		end
	end

	-- Next time being blank means that there is no scheduled times left for
	-- the current day. So next scheduled time is tomorrow's first time
	if next_time == '' then
		next_time = first_time
	end

	-- Update Wallpaper
	update_wallpaper(wallpaper_schedule[previous_time])
	
	-- Get the time difference to set as timeout for the wall_updater timer below
	the_countdown = time_diff(next_time, current_time())

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
awesome.connect_signal("module::change_wallpaper", function()
	
	-- Update values for the next specified schedule
	manage_timer()

	-- Update timer timeout for the next specified schedule
	wall_updater.timeout = the_countdown

	-- Restart timer
	wall_updater:again()

end)
