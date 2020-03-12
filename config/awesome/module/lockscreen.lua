local wibox = require('wibox')
local gears = require('gears')
local awful = require('awful')
local naughty = require('naughty')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi

local apps = require('configuration.apps')

local filesystem = require('gears.filesystem')
local config_dir = filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. '/widget/user-profile/icons/'

-- Useful variables (DO NOT TOUCH)

local input_password = nil
local lock_again = nil
local validate_again = nil

-- Get pass

local pass = function()
	local secrets = require('configuration.secrets')
	local password = secrets.lockscreen.password
	return password
end

-- Configuration

local capture_intruder = true  							-- Capture a picture using webcam 
local background_mode = 'blur' 							-- Available background mode: `blur`, `root`, `background`
local face_capture_dir = '${HOME}/Pictures/Intruders/'  -- Save location, auto creates




local locker = function(s)

	local lockscreen = wibox {
		visible = false,
		ontop = true,
		type = "splash",
		width = s.geometry.width,
		height = s.geometry.height,
		bg = beautiful.background,
		fg = beautiful.fg_normal
	}

	local uname_text = wibox.widget {
		id = 'uname_text',
		markup = '$USER',
		font = 'SF Pro Display Bold 17',
		align = 'center',
		valign = 'center',
		widget = wibox.widget.textbox
	}

	local uname_text_shadow = wibox.widget {
		id = 'uname_text_shadow',
		markup = '<span foreground="#00000066">' .. '$USER' .. "</span>",
		font = 'SF Pro Display Bold 17',
		align = 'center',
		valign = 'center',
		widget = wibox.widget.textbox
	}

	local caps_text = wibox.widget {
		id = 'uname_text',
		markup = 'Caps Lock is off',
		font = 'SF Pro Display Italic 10',
		align = 'center',
		valign = 'center',
		opacity = 0.0,
		widget = wibox.widget.textbox
	}
	local caps_text_shadow = wibox.widget {
		id = 'uname_text',
		markup = '<span foreground="#00000066">' .. 'Caps Lock is off' .. "</span>",
		font = 'SF Pro Display Italic 10',
		align = 'center',
		valign = 'center',
		opacity = 0.0,
		widget = wibox.widget.textbox
	}

	-- Update username textbox
	awful.spawn.easy_async_with_shell('whoami | tr -d "\\n"', function(stdout) 
		uname_text.markup = stdout
		uname_text_shadow.markup = '<span foreground="#00000066">' .. stdout .. "</span>"
	end)


	local profile_imagebox = wibox.widget {
		id = 'user_icon',
		image = widget_icon_dir .. 'user.svg',
		forced_height = dpi(100),
		forced_width = dpi(100),
		clip_shape = gears.shape.circle,
		widget = wibox.widget.imagebox,
		resize = true
	}

	local update_profile_pic = function()

		local user_jpg_checker = [[
		if test -f ]] .. widget_icon_dir .. 'user.jpg' .. [[; then print 'yes'; fi
		]]

		awful.spawn.easy_async_with_shell(user_jpg_checker, function(stdout)

			if stdout:match('yes') then
				profile_imagebox:set_image(widget_icon_dir .. 'user' .. '.jpg')
			else
				profile_imagebox:set_image(widget_icon_dir .. 'user' .. '.svg')
			end
			
			profile_imagebox:emit_signal('widget::redraw_needed')
		end)
	end

	-- Update image
	gears.timer.start_new(5, function() 
		update_profile_pic()
	end)

	local time = wibox.widget.textclock(
		'<span font="SF Pro Display Bold 56">%H:%M</span>',
		1
	)

	local time_shadow = wibox.widget.textclock(
		'<span foreground="#00000066" font="SF Pro Display Bold 56">%H:%M</span>',
		1
	)

	local wanted_text = wibox.widget {
		markup = 'INTRUDER ALERT',
		font   = 'SFNS Pro Text Bold 12',
		align  = 'center',
		valign = 'center',
		widget = wibox.widget.textbox
	}

	local msg_table = {
		'We are watching you.',
		'We know where you live.',
		'This incident will be reported.',
		'RUN!',
		'Yamete, Oniichan~ uwu',
		'This will self-destruct in 5 seconds!',
		'Image successfully sent!',
		'You\'re doomed!'
	}

	local wanted_msg = wibox.widget {
		markup = 'This incident will be reported!',
		font   = 'SFNS Pro Text Regular 10',
		align  = 'center',
		valign = 'center',
		widget = wibox.widget.textbox
	}

	local wanted_image = wibox.widget {
		image  = widget_icon_dir .. 'user.svg',
		resize = true,
		forced_height = dpi(100),
		clip_shape = gears.shape.rounded_rect,
	    widget = wibox.widget.imagebox
	}

	local wanted_poster = awful.popup {

		widget 		   		= {
			{
				{
					wanted_text,
					{
						nil,
						wanted_image,
						nil,
						expand = 'none',
						layout = wibox.layout.align.horizontal
					},
					wanted_msg,
					spacing = dpi(10),
					layout = wibox.layout.fixed.vertical
				},
				margins = dpi(20),
				widget = wibox.container.margin
			},
			bg = beautiful.background,
			shape = gears.shape.rounded_rect,
			widget = wibox.container.background
		},
		bg 					= beautiful.transparent,
		type 				= 'utility',
		ontop 				= true,
		shape          		= gears.shape.rectangle,
		maximum_width  		= dpi(250),
		maximum_height 		= dpi(200),
		hide_on_right_click = true,
		preferred_anchors 	= {'middle'},
		visible 	   		= false

	}

	awful.placement.bottom(wanted_poster, 
		{ 
			margins = 
			{
				bottom = dpi(10),
			}, 
			parent = screen.primary
		}
	)


	local return_ordinal = function(n)
	    last_digit = n % 10
	    if last_digit == 1 and n ~= 11
	        then return 'st'
	    elseif last_digit == 2 and n ~= 12
	        then return 'nd'
	    elseif last_digit == 3 and n ~= 13
	        then return 'rd'
	    else 
	        return 'th'
	    end
	end

	local date_value = function()
		local date_val = {}
		local ordinal = nil

		local day = os.date('%d')
		local month = os.date('%B')

		local first_digit = string.sub(day, 0, 1) 
		local last_digit = string.sub(day, -1) 

		if first_digit == '0' then
		  day = last_digit
		end

		ordinal = return_ordinal(tonumber(day))

		date_val.day = day
		date_val.month = month
		date_val.ordinal= ordinal

		return date_val
	end


	local date = wibox.widget {
		markup = date_value().day .. date_value().ordinal .. ' of ' .. date_value().month,
		font = 'SF Pro Display Bold 20',
		align = 'center',
		valign = 'center',
		widget = wibox.widget.textbox
	}

	local date_shadow = wibox.widget {
		markup = "<span foreground='#00000066'>" .. date_value().day .. date_value().ordinal .. " of " .. 
			date_value().month .. "</span>",
		font = 'SF Pro Display Bold 20',
		align = 'center',
		valign = 'center',
		widget = wibox.widget.textbox
	}

	local circle_container = wibox.widget {
		bg = '#f2f2f233',
	    forced_width = dpi(110),
	    forced_height = dpi(110),
	    shape = gears.shape.circle,
	    widget = wibox.container.background
	}

	local locker_arc = wibox.widget {
	    bg = beautiful.transparent,
	    forced_width = dpi(110),
	    forced_height = dpi(110),
	    shape = function(cr, width, height)
	        gears.shape.arc(cr, width, height, dpi(5), 0, math.pi/2, true, true)
	    end,
	    widget = wibox.container.background
	}


	check_caps = function()
		awful.spawn.easy_async(apps.bins.capslock_status, function(stdout)
			
			status = stdout:gsub('%\n','')

			if status:match('on') then
				caps_text.opacity = 1.0
				caps_text_shadow.opacity = 1.0

				caps_text:set_markup('Caps Lock is on')
				caps_text_shadow:set_markup('<span foreground="#00000066">' .. 'Caps Lock is on' .. "</span>")
			else
				caps_text.opacity = 0.0
				caps_text_shadow.opacity = 0.0
			end

			caps_text:emit_signal('widget::redraw_needed')
			caps_text_shadow:emit_signal('widget::redraw_needed')
		end)
	end

	local rotate_container = wibox.container.rotate()

	local locker_widget = wibox.widget {
		{
		    locker_arc,
		    widget = rotate_container
		},
		layout = wibox.layout.fixed.vertical
	}

	-- Rotation direction table
	local rotation_direction = {"north", "west", "south", "east"}

	-- Red, Green, Yellow, Blue
	local red = "#EE4F84"
	local green = "#53E2AE"
	local yellow = "#F1FF52"
	local blue = "#6498EF"
	
	-- Color table
	local arc_color = {red, green, yellow, blue}


	local locker_widget_rotate = function()

		local direction = rotation_direction[math.random(#rotation_direction)]
		local color = arc_color[math.random(#arc_color)]

		rotate_container.direction = direction

		locker_arc.bg = color

		locker_widget:emit_signal("widget::redraw_needed")

	end

	local intruder_capture = function()
		local capture_image = [[

		save_dir=]] .. face_capture_dir .. [[
		date=$(date +%Y%m%d_%H%M%S)
		file_loc=${save_dir}SUSPECT-${date}.png

		if [ ! -d $save_dir ]; then
			mkdir -p $save_dir;
		fi

		ffmpeg -f video4linux2 -s 800x600 -i /dev/video0 -ss 0:0:2 -frames 1 ${file_loc}

		canberra-gtk-play -i camera-shutter &
		echo ${file_loc}

		]]

		-- Capture the filthy intruder face
		awful.spawn.easy_async_with_shell(
			capture_image, 
			function(stdout)
				circle_container.bg = beautiful.groups_title_bg
				validate_again = true
					
				-- Humiliate the intruder by showing his/her hideous face
				wanted_image:set_image(stdout:gsub('%\n',''))
				wanted_poster.visible= true
				wanted_msg:set_markup(msg_table[math.random(#msg_table)])

				awful.placement.bottom(wanted_poster, 
					{ 
						margins = 
						{
							bottom = dpi(10),
						}, 
						parent = screen.primary
					}
				)

				wanted_image:emit_signal('widget::redraw_needed')
			end
		)
	end

	local stoprightthereyoucriminalscum = function()

		circle_container.bg = red .. 'AA'

		if capture_intruder then
			intruder_capture()
		else
			gears.timer.start_new(1, function()
				circle_container.bg = beautiful.groups_title_bg
				validate_again = true
			end)
		end
	end


	local ohhither = function()
		
		circle_container.bg = green .. 'AA'

		-- Add a little delay before unlocking completely
		gears.timer.start_new(1, function()

			-- Hide all the lockscreen on all screen
			for s in screen do
				if s.index == 1 then
					s.lockscreen.visible = false
				else
					s.lockscreen_extended.visible = false
				end
			end

			circle_container.bg = beautiful.groups_title_bg
			
			-- Enable locking again
			lock_again = true

			-- Enable validation again
			validate_again = true

			if capture_intruder then
				-- Hide wanted poster
				wanted_poster.visible = false

			end
		end)

	end

	local back_door = function()
		ohhither()
	end

	local password_grabber = awful.keygrabber {
		auto_start          = true,
		stop_event          = 'release',
		mask_event_callback = true,
	    keybindings = {
	        awful.key {
	            modifiers = {'Control'},
	            key       = 'u',
	            on_press  = function() 
	            	input_password = nil

	            end
	        },
	        awful.key {
	            modifiers = {'Mod1', 'Mod4', 'Shift', 'Control'},
	            key       = 'Return',
	            on_press  = function(self) 
	            	self:stop()
	            	back_door() 
	        	end
	        }
	    },
		keypressed_callback = function(self, mod, key, command) 

			-- Clear input string
			if key == 'Escape' then
				-- Clear input threshold
				input_password = nil
			end

			-- Accept only the single charactered key
			-- Ignore 'Shift', 'Control', 'Return', 'F1', 'F2', etc., etc
			if #key == 1 then
				
				locker_widget_rotate()

				if input_password == nil then
					input_password = key
					return
				end
				
				input_password = input_password .. key
			end

		end,
		keyreleased_callback = function(self, mod, key, command)
			locker_arc.bg = beautiful.transparent

			if key == 'Caps_Lock' then
				check_caps()
			end

			-- Validation
			if key == 'Return' and (validate_again == true or validate_again == nil) then

				validate_again = false

				-- Validate password
				if input_password == pass() then
					-- Come in!
					self:stop()
					ohhither()
				else
					-- F*ck off, you [REDACTED]!
					stoprightthereyoucriminalscum()
				end

				input_password = nil
			end
		
		end

	}


	lockscreen : setup {
		layout = wibox.layout.align.vertical,
		expand = 'none',
		nil,
		{
			layout = wibox.layout.align.horizontal,
			expand = 'none',
			nil,
			{
				layout = wibox.layout.fixed.vertical,
				expand = 'none',
				spacing = dpi(20),
				{
					{
						layout = wibox.layout.align.horizontal,
						expand = 'none',
						nil,
						{
							time_shadow,
							time,
							vertical_offset = dpi(-1),
							widget = wibox.layout.stack
						},
						nil

					},
					{
						layout = wibox.layout.align.horizontal,
						expand = 'none',
						nil,
						{
							date_shadow,
							date,
							vertical_offset = dpi(-1),
							widget = wibox.layout.stack
						},
						nil

					},
					expand = 'none',
					layout = wibox.layout.fixed.vertical
				},
				{
					layout = wibox.layout.fixed.vertical,
					{
						circle_container,
						locker_widget,
						{
							layout = wibox.layout.align.vertical,
							expand = 'none',
							nil,
							{
								layout = wibox.layout.align.horizontal,
								expand = 'none',
								nil,
								profile_imagebox,
								nil
							},
							nil,
						},
						layout = wibox.layout.stack
					},
					{
						uname_text_shadow,
						uname_text,
						vertical_offset = dpi(-1),
						widget = wibox.layout.stack
					},
					{
						caps_text_shadow,
						caps_text,
						vertical_offset = dpi(-1),
						widget = wibox.layout.stack
					}
				},
			},
			nil
		},
		nil
	}

	show_lockscreen = function()

		-- Why is there a lock_again variable?
		-- Well, it fixes a bug.

		if lock_again == true or lock_again == nil then		

			check_caps()

			-- Show all the lockscreen on each screen
			for s in screen do
				if s.index == 1 then
					s.lockscreen.visible = true
				else
					s.lockscreen_extended.visible = true
				end
			end

			-- Start key grabbing for password
			password_grabber:start()

			-- Dont lock again
			lock_again = false

		end

	end

	return lockscreen

end


-- This lockscreen is for the extra/multi monitor
local locker_ext = function(s)
	local extended_lockscreen = wibox {
		visible = false,
		ontop = true,
		ontype = 'true',
		x = s.geometry.x,
		y = s.geometry.y,
		width = s.geometry.width,
		height = s.geometry.height,
		bg = beautiful.background,
		fg = beautiful.fg_normal
	}

	return extended_lockscreen
end


-- Create a lockscreen for each screen
screen.connect_signal("request::desktop_decoration", function(s)

	if s.index == 1 then
		s.lockscreen = locker(s)
	else
		s.lockscreen_extended = locker_ext(s)
	end

end)

-- Dont show notification popups if screen is locked
naughty.connect_signal("request::display", function(_)
	-- focused = awful.screen.focused()
	-- if focused.lockscreen and focused.lockscreen.visible  then
	-- 	naughty.destroy_all_notifications()
	-- end
	-- if focused.lockscreen_extended and focused.lockscreen_extended.visible then
	-- 	naughty.destroy_all_notifications()
	-- end
end)



-- Dynamic background

-- Blurred background
-- Depends:
-- 		imagemagick

if background_mode == 'blur'  then

	-- Wallpaper directory. The default is:
	local wall_dir = gears.filesystem.get_configuration_dir() .. 'theme/wallpapers/'

	-- Temp dir
	local tmp_wall_dir = '/tmp/awesomewm/' .. os.getenv('USER') .. '/'

	-- Wallpapers filename
	-- Note:
	-- Default image format is jpg
	ls_bg_morning = 'morning-wallpaper.jpg'
	ls_bg_noon = 'noon-wallpaper.jpg'
	ls_bg_night = 'night-wallpaper.jpg'
	ls_bg_midnight = 'midnight-wallpaper.jpg'

	-- Change the wallpaper on scheduled time
	morning_schedule = '06:22:00'
	noon_schedule = '12:00:00'
	night_schedule = '17:58:00'
	midnight_schedule = '24:00:00'

	local bg_data = {}
	local the_countdown = nil

	-- Get current time
	local current_time = function()
	  	return os.date("%H:%M:%S")
	end

	-- Parse HH:MM:SS to seconds
	local parse_to_seconds = function(time)

	  	-- Convert HH in HH:MM:SS
	  	hour_sec = tonumber(string.sub(time, 1, 2)) * 3600

	  	-- Convert MM in HH:MM:SS
	  	min_sec = tonumber(string.sub(time, 4, 5)) * 60

		-- Get SS in HH:MM:SS
		get_sec = tonumber(string.sub(time, 7, 8))

		-- Return computed seconds
	    return (hour_sec + min_sec + get_sec)

	end


	-- Get time difference
	local time_diff = function(current, schedule)
		local diff = parse_to_seconds(current) - parse_to_seconds(schedule)
		return diff
	end


	-- Imagemagick convert command that will crop, resize and blur the background image
	local return_cmd_str_to_blur = function(wall_name, index, ap, width, height)
		local magic = [[

		if [ ! -d ]] .. tmp_wall_dir ..[[ ]; then mkdir -p ]] .. tmp_wall_dir .. [[; fi

		convert -quality 100 -filter Gaussian -blur 0x10 ]] .. wall_dir .. wall_name .. 
		[[ -gravity center -crop ]] .. ap .. [[:1 +repage -resize ]] .. width .. 'x' .. height .. 
		[[! ]] .. tmp_wall_dir .. index .. wall_name .. [[
		]]
		return magic
	end

	local update_ls_bg = function(wall_name)

		for s in screen do

			local index = s.index .. '-'

			local screen_width = s.geometry.width
			local screen_height = s.geometry.height

			local aspect_ratio = screen_width / screen_height

			aspect_ratio = math.floor(aspect_ratio * 100) / 100

			local cmd = return_cmd_str_to_blur(wall_name, index, aspect_ratio, screen_width, screen_height)

			if s.index == 1 then
				awful.spawn.easy_async_with_shell(cmd, function() 
					s.lockscreen.bgimage = tmp_wall_dir .. index .. wall_name
				end)
			else
				awful.spawn.easy_async_with_shell(cmd, function() 
					s.lockscreen_extended.bgimage = tmp_wall_dir .. index .. wall_name
				end)
			end

		end
	end


	-- Updates variables
	local manage_timer = function()

		-- Get current time
		local time_now = parse_to_seconds(current_time())

		-- Parse the schedules to seconds
		local parsed_morning = parse_to_seconds(morning_schedule)
		local parsed_noon = parse_to_seconds(noon_schedule)
		local parsed_night = parse_to_seconds(night_schedule)
		local parsed_midnight = parse_to_seconds('00:00:00')

		-- Note that we will use '00:00:00' instead of '24:00:00' as midnight
		-- As the latter causes an error. The time_diff() returns a negative value

		if time_now >= parsed_midnight and time_now < parsed_morning then
			-- Midnight time

			-- Update lockscreen background
			update_ls_bg(ls_bg_midnight)

			-- Set the data for the next scheduled time
			bg_data = {morning_schedule, ls_bg_morning}

		elseif time_now >= parsed_morning and time_now < parsed_noon then
			-- Morning time

			-- Update lockscreen background
			update_ls_bg(ls_bg_morning)

			-- Set the data for the next scheduled time
			bg_data = {noon_schedule, ls_bg_noon}

		elseif time_now >= parsed_noon and time_now < parsed_night then
			-- Noon time

			-- Update lockscreen background
			update_ls_bg(ls_bg_noon)

			-- Set the data for the next scheduled time
			bg_data = {night_schedule, ls_bg_night}

		else
			-- Night time

			-- Update lockscreen background
			update_ls_bg(ls_bg_night)

			-- Set the data for the next scheduled time
			bg_data = {midnight_schedule, ls_bg_midnight}

		end
	  
		
		-- Get the time difference to set as timeout for the wall_updater timer below
		the_countdown = time_diff(bg_data[1], current_time())

	end

	-- Update lockscreen background
	manage_timer()


	local ls_updater = gears.timer {
		-- The timeout is the difference of current time and the scheduled time we set above.
		timeout   = the_countdown,
		autostart = true,
		call_now = true,
		callback  = function()

			-- Emit signal to update lockscreen background
	    	awesome.emit_signal("module::lockscreen_background")
	  	
	  	end
	}

	-- Update lockscreen bg here and update the timeout for the next schedule
	awesome.connect_signal("module::lockscreen_background", function()
		
		-- Update values for the next specified schedule
		manage_timer()

		-- Update timer timeout for the next specified schedule
		ls_updater.timeout = the_countdown

		-- Restart timer
		ls_updater:again()

	end)

	-- If a screen is added, execute manage_timer()
	screen.connect_signal(
		'added', 
		function() 
			manage_timer()
		end
	)

elseif background_mode == 'root' then

	for s in screen do
		if s.index == 1 then
			s.lockscreen.bgimage = root.wallpaper()
		else
			s.lockscreen_extended.bgimage = root.wallpaper()
		end
	end


elseif background_mode == 'background' then
	for s in screen do
		if s.index == 1 then
			s.lockscreen.bgimage = beautiful.background
		else
			s.lockscreen_extended.bgimage = beautiful.background
		end
	end
else
	for s in screen do
		if s.index == 1 then
			s.lockscreen.bgimage = root.wallpaper()
		else
			s.lockscreen_extended.bgimage = root.wallpaper()
		end
	end
end