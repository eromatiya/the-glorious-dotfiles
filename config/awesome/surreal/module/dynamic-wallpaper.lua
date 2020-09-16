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
local config = require('configuration.config')


--  ========================================
-- 				Configuration
--	     Change your preference here
--  ========================================

local wall_config = {
	-- Wallpaper directory. The default is:
	-- local wall_config.wall_dir = os.getenv('HOME') .. 'Pictures/Wallpapers/'
	wall_dir = filesystem.get_configuration_dir() .. (config.module.dynamic_wallpaper.wall_dir or 'theme/wallpapers/'),

	-- If there's a picture format that awesome accepts and i missed
	-- (which i probably did) feel free to add it right here
	valid_picture_formats = config.module.dynamic_wallpaper.valid_picture_formats or {"jpg", "png", "jpeg"},

	-- Table mapping schedule to wallpaper filename
	wallpaper_schedule = config.module.dynamic_wallpaper.wallpaper_schedule or {
		['00:00:00'] = 'midnight-wallpaper.jpg',
		['06:22:00'] = 'morning-wallpaper.jpg',
		['12:00:00'] = 'noon-wallpaper.jpg',
		['17:58:00'] = 'night-wallpaper.jpg'
	},

	-- Don't stretch wallpaper on multihead setups if true
	stretch = config.module.dynamic_wallpaper.stretch or false
}

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

-- Returns a table containing all file paths in a directory
local function get_dir_contents(dir)
	-- Command to give list of files in directory
	local dir_explore = 'find ' .. dir .. ' -printf "%f\\n"'
	local lines = io.popen(dir_explore):lines() --Done synchronously because we literally can't continue without files
	local files = {}
	for line in lines do
		table.insert(files, line)
	end
	return files
end

-- Returns a table of all the files that were one of the valid file formats
local function filter_files_by_format(files, valid_file_formats)
	local valid_files = {}
	for _, file in ipairs(files) do
		for _, format in ipairs(valid_file_formats) do
			if string.match(file, ".+%." .. format) ~= nil then
				table.insert(valid_files, file)
				break --No need to check other formats
			end
		end
	end

	return valid_files
end

-- Returns a table of files that contained any of the keywords, in the same order as the words themselves
local function find_files_containing_keywords(files, keywords)
	local found_files = {}

	for _, word in ipairs(keywords) do --Preserves keyword order inherently, conveniently
		for _, file in ipairs(files) do
			-- Check if file is word, contains word at beginning or contains word between 2 non-alphanumeric characters
			if file == word or string.find(file, "^" .. word .. "[^%a]") or string.find(file, "[^%a]" .. word .. "[^%a]") then
				found_files[word] = file
				break --Only return 1 file per word
			end
		end
	end

	return found_files
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
if #wall_config.wallpaper_schedule == 0 then
	local count = 0
	-- Determine if empty or if manual schedule
	for k, v in pairs(wall_config.wallpaper_schedule) do
		count = count + 1
	end

	if count == 0 then --Schedule is actually empty
		-- Get all pictures
		local pictures = filter_files_by_format(get_dir_contents(wall_config.wall_dir), wall_config.valid_picture_formats)

		--Sort pictures as sanely as possible
		local function order_pictures(a, b) --Attempts to mimic default sort but numbers aren't compared as strings
			if tonumber(a) ~= nil and tonumber(b) ~= nil then
				return tonumber(a) < tonumber(b)
			else
				return a < b
			end
		end
		table.sort(pictures, order_pictures)

		wall_config.wallpaper_schedule = auto_schedule(pictures)

	else --Schedule is manually timed
		-- Get times as list
		local ordered_times = {}
		for time, _ in pairs(wall_config.wallpaper_schedule) do
			table.insert(ordered_times, time)
		end

		-- Sort times using seconds as comparison
		local function order_time_asc(a, b)
			return parse_to_seconds(a) < parse_to_seconds(b)
		end
		table.sort(ordered_times, order_time_asc)

		-- Get ordered list of keywords from ordered times
		local keywords = {}
		for index, time in ipairs(ordered_times) do
			keywords[index] = wall_config.wallpaper_schedule[time]
		end

		-- Get any pictures that match keywords
		local pictures = filter_files_by_format(get_dir_contents(wall_config.wall_dir), wall_config.valid_picture_formats)
		pictures = find_files_containing_keywords(pictures, keywords)
		
		-- Replace keywords with files
		for index, time in ipairs(ordered_times) do
			local word = wall_config.wallpaper_schedule[time]
			if pictures[word] ~= nil then
				wall_config.wallpaper_schedule[time] = pictures[word]
			else --To avoid crashes, we'll remove entries with invalid keywords
				wall_config.wallpaper_schedule[time] = nil
			end
		end
	end
else --Schedule is list of keywords
	local keywords = wall_config.wallpaper_schedule

	-- Get any pictures that match keywords
	local pictures = filter_files_by_format(get_dir_contents(wall_config.wall_dir), wall_config.valid_picture_formats)
	pictures = find_files_containing_keywords(pictures, keywords)
	
	-- Order files by keyword (if a file was found for the keyword)
	local ordered_pictures = {}
	for _, word in ipairs(keywords) do
		local file = pictures[word]
		if file ~= nil then
			table.insert(ordered_pictures, file)
		end
	end

	wall_config.wallpaper_schedule = auto_schedule(ordered_pictures)
end

-- Set wallpaper
local set_wallpaper = function(path)
	if wall_config.stretch then
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
	local wall_dir = wall_config.wall_dir .. wall_name
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

	local first_time = '24:00:00' --First scheduled time registered (to be found)
	local last_time = '00:00:00' --Last scheduled time registered (to be found)

	-- Find previous_time
	for time, wallpaper in pairs(wall_config.wallpaper_schedule) do
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
	for time, wallpaper in pairs(wall_config.wallpaper_schedule) do
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
	update_wallpaper(wall_config.wallpaper_schedule[previous_time])
	
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
awesome.connect_signal(
	'module::change_wallpaper',
	function()
		--set_wallpaper(wall_dir .. wall_data[2])

		-- Update values for the next specified schedule
		manage_timer()

		-- Update timer timeout for the next specified schedule
		wall_updater.timeout = the_countdown

		-- Restart timer
		wall_updater:again()
	end
)
