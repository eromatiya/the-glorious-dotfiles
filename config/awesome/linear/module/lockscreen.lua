local wibox = require('wibox')
local gears = require('gears')
local awful = require('awful')
local naughty = require('naughty')
local beautiful = require('beautiful')
local filesystem = gears.filesystem
local config_dir = filesystem.get_configuration_dir()
local dpi = beautiful.xresources.apply_dpi
local apps = require('configuration.apps')
local widget_icon_dir = config_dir .. 'configuration/user-profile/'

package.cpath = package.cpath .. ';' .. config_dir .. '/library/?.so;'
local pam = require('liblua_pam')

-- General Configuration
local capture_intruder = true  											-- Capture a picture using webcam 
local face_capture_dir = '$(xdg-user-dir PICTURES)/Intruders/'  		-- Save location, auto creates

-- Background Mode Configuration
local blur_background = true											-- True to blur the background
local wall_dir = config_dir .. 'theme/wallpapers/'						-- Wallpaper directory
local default_wall_name = 'morning-wallpaper.jpg'						-- Default wallpaper
local tmp_wall_dir = '/tmp/awesomewm/' .. os.getenv('USER') .. '/'		-- /tmp directory

-- Useful variables (DO NOT TOUCH THESE)
local input_password = nil
local lock_again = nil
local type_again = true
local capture_now = capture_intruder
local locked_tag = nil

local uname_text = wibox.widget {
	id = 'uname_text',
	markup = '$USER',
	font = 'SF Pro Display Bold 12',
	align = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

local caps_text = wibox.widget {
	id = 'uname_text',
	markup = 'Caps Lock is on',
	font = 'SF Pro Display Italic 10',
	align = 'center',
	valign = 'center',
	opacity = 0.0,
	widget = wibox.widget.textbox
}

local profile_imagebox = wibox.widget {
	id = 'user_icon',
	image = widget_icon_dir .. 'default.svg',
	resize = true,
	forced_height = dpi(120),
	forced_width = dpi(120),
	clip_shape = gears.shape.circle,
	widget = wibox.widget.imagebox
}

local time = wibox.widget.textclock(
	'<span font=\'SF Pro Display Bold 56\'>%I:%M %p</span>',
	1
)

local wanted_text = wibox.widget {
	markup = 'INTRUDER ALERT!',
	font   = 'Inter Bold 12',
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
	'You\'re doomed!',
	'Authentication failed!',
	'I am watching you.',
	'I know where you live.',
	'RUN!',
	'Why are you the way that you are?',
	'Intruder image successfully sent!',
	'Someone\'s gonna bites za dusto!',
	'“You miss 100% of the shots you don\'t take – Wayne Gretzky – Michael Scott”',
	'Get out of there, it\'s gonna blow!'
}

local wanted_msg = wibox.widget {
	markup = 'This incident will be reported!',
	font   = 'Inter Regular 10',
	align  = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

local wanted_image = wibox.widget {
	image  = widget_icon_dir .. 'default.svg',
	resize = true,
	forced_height = dpi(120),
	clip_shape = gears.shape.rounded_rect,
	widget = wibox.widget.imagebox
}

local date_value = function()
	local ordinal = nil
	local date = os.date('%d')
	local day = os.date('%A')
	local month = os.date('%B')

	local first_digit = string.sub(date, 0, 1) 
	local last_digit = string.sub(date, -1) 
	if first_digit == '0' then
	  date = last_digit
	end

	if last_digit == '1' and date ~= '11' then
	  ordinal = 'st'
	elseif last_digit == '2' and date ~= '12' then
	  ordinal = 'nd'
	elseif last_digit == '3' and date ~= '13' then
	  ordinal = 'rd'
	else
	  ordinal = 'th'
	end

	return date .. ordinal .. ' of ' .. month .. ', ' .. day
end

local date = wibox.widget {
	markup = date_value(),
	font = 'SF Pro Display Bold 20',
	align = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

local circle_container = wibox.widget {
	bg = '#f2f2f233',
	forced_width = dpi(130),
	forced_height = dpi(130),
	shape = gears.shape.circle,
	widget = wibox.container.background
}

local locker_arc = wibox.widget {
	bg = beautiful.transparent,
	forced_width = dpi(130),
	forced_height = dpi(130),
	shape = function(cr, width, height)
		gears.shape.arc(cr, width, height, dpi(5), 0, math.pi/2, true, true)
	end,
	widget = wibox.container.background
}

local rotate_container = wibox.container.rotate()
local locker_widget = wibox.widget {
	{
		locker_arc,
		widget = rotate_container
	},
	layout = wibox.layout.fixed.vertical
}

-- Rotation direction table
local rotation_direction = {'north', 'west', 'south', 'east'}

-- Red, Green, Yellow, Blue
local red = beautiful.system_red_dark
local green = beautiful.system_green_dark
local yellow = beautiful.system_yellow_dark
local blue = beautiful.system_blue_dark
	
-- Color table
local arc_color = {red, green, yellow, blue}

-- Processes
local locker = function(s)

	local lockscreen = wibox {
		screen = s,
		visible = false,
		ontop = true,
		type = 'splash',
		width = s.geometry.width,
		height = s.geometry.height,
		bg = beautiful.background,
		fg = beautiful.fg_normal
	}

	-- Update username textbox
	awful.spawn.easy_async_with_shell(
		'sh -c "getent passwd `whoami` | cut -d : -f 5 | tr -d \'\\n\'"',
		function(stdout)
			-- No full name, use username
			if not stdout or stdout == '' then
				awful.spawn.easy_async_with_shell(
					'sh -c "whoami | tr -d \'\\n\'"',
					function(stdout)
						uname_text.markup = stdout
					end
				)
				return
			end

			-- Set fullname markup
			uname_text.markup = stdout
		end
	)

	local update_profile_pic = function()
		awful.spawn.easy_async_with_shell(
			apps.bins.update_profile,
			function(stdout)
				stdout = stdout:gsub('%\n','')
				if not stdout:match('default') then
					profile_imagebox:set_image(stdout)
				else
					profile_imagebox:set_image(widget_icon_dir .. 'default.svg')
				end
			end
		)
	end

	-- Update image
	gears.timer.start_new(
		2, 
		function() 
			update_profile_pic()
		end
	)

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
		hide_on_right_click = false,
		preferred_anchors 	= {'middle'},
		visible 	   		= false
	}

	-- Place wanted poster at the bottom of primary screen
	awful.placement.bottom(
		wanted_poster, 
		{ 
			margins = 
			{
				bottom = dpi(10),
			}, 
			parent = screen.primary
		}
	)
	
	-- Check Capslock state
	local check_caps = function()
		awful.spawn.easy_async_with_shell(
			'xset q | grep Caps | cut -d: -f3 | cut -d0 -f1 | tr -d \' \'',
			function(stdout)
				if stdout:match('on') then
					caps_text.opacity = 1.0
				else
					caps_text.opacity = 0.0
				end
				caps_text:emit_signal('widget::redraw_needed')
			end
		)
	end

	local locker_widget_rotate = function()

		local direction = rotation_direction[math.random(#rotation_direction)]
		local color = arc_color[math.random(#arc_color)]

		rotate_container.direction = direction
		locker_arc.bg = color

		rotate_container:emit_signal('widget:redraw_needed')
		locker_arc:emit_signal('widget::redraw_needed')
		locker_widget:emit_signal('widget::redraw_needed')
	end

	-- Check webcam
	local check_webcam = function()
		awful.spawn.easy_async_with_shell(
			[[
			ls -l /dev/video* | grep /dev/video0
			]],
			function(stdout)
				if not capture_intruder then
					capture_now = false
					return
				end

				if not stdout:match('/dev/video0') then
					capture_now = false
				else
					capture_now = true
				end
			end
		)
	end

	check_webcam()

	-- Snap an image of the intruder
	local intruder_capture = function()
		local capture_image = [[
		save_dir=]] .. face_capture_dir .. [[
		date="$(date +%Y%m%d_%H%M%S)"
		file_loc="${save_dir}SUSPECT-${date}.png"

		if [ ! -d "$save_dir" ]; then
			mkdir -p "$save_dir";
		fi

		ffmpeg -f video4linux2 -s 800x600 -i /dev/video0 -ss 0:0:2 -frames 1 "${file_loc}"

		canberra-gtk-play -i camera-shutter &
		echo "${file_loc}"
		]]

		-- Capture the filthy intruder face
		awful.spawn.easy_async_with_shell(
			capture_image, 
			function(stdout)
				circle_container.bg = beautiful.groups_title_bg

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
				type_again = true
			end
		)
	end

	local stoprightthereyoucriminalscum = function()

		circle_container.bg = red .. 'AA'

		if capture_now then
			intruder_capture()
		else
			gears.timer.start_new(
				1,
				function()
					circle_container.bg = beautiful.groups_title_bg
					type_again = true
				end
			)
		end
	end


	local generalkenobi_ohhellothere = function()
		
		circle_container.bg = green .. 'AA'

		-- Add a little delay before unlocking completely
		gears.timer.start_new(
			1,
			function()
				if capture_now then
					-- Hide wanted poster
					wanted_poster.visible = false
				end

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
				type_again = true

				-- Select old tag 
				-- And restore minimized focused client if there's any
				if locked_tag then
					locked_tag.selected = true
					locked_tag = nil
				end
				local c = awful.client.restore()
				if c then
					client.focus = c
					c:raise()
				end
			end
		)
	end

	-- A backdoor
	local back_door = function()
		generalkenobi_ohhellothere()
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
					if not type_again then
						return
					end
					self:stop()
					back_door() 
				end
			}
		},
		keypressed_callback = function(self, mod, key, command) 

			if not type_again then
				return
			end

			-- Clear input string
			if key == 'Escape' then
				-- Clear input threshold
				input_password = nil
				return
			end

			-- Accept only the single charactered key
			-- Ignore 'Shift', 'Control', 'Return', 'F1', 'F2', etc., etc.
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
			locker_arc:emit_signal('widget::redraw_needed')

			if key == 'Caps_Lock' then
				check_caps()
				return
			end

			if not type_again then
				return
			end

			-- Validation
			if key == 'Return' then

				-- Validate password
				local pam_auth = false
				if input_password ~= nil then
					pam_auth = pam:auth_current_user(input_password)
				else
					return
				end

				if pam_auth then
					-- Come in!
					self:stop()
					generalkenobi_ohhellothere()
				else
					-- F*ck off, you [REDACTED]!
					stoprightthereyoucriminalscum()
				end

				type_again = false

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
						time,
						nil

					},
					{
						layout = wibox.layout.align.horizontal,
						expand = 'none',
						nil,
						date,
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
					uname_text,
					caps_text
				},
			},
			nil
		},
		nil
	}

	local show_lockscreen = function()

		-- Unselect all tags and minimize the focused client
		-- Will also fix the problem with virtualbox or any other program that has keygrabbing enabled
		if client.focus then
			client.focus.minimized = true
		end
		for _, t in ipairs(mouse.screen.selected_tags) do
			locked_tag = t
			t.selected = false
		end

		-- Why is there a lock_again variable?
		-- Well, it fixes a bug.
		-- What is the bug? 
		-- It's a secret.

		if lock_again == true or lock_again == nil then		

			-- Check capslock status
			check_caps()

			-- Check webcam status
			check_webcam()

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

	awesome.connect_signal(
		'module::lockscreen_show',
		function()
			if lock_again == true or lock_again == nil then
				show_lockscreen()
			end
		end
	)
	return lockscreen

end

-- This lockscreen is for the extra/multi monitor
local locker_ext = function(s)
	local extended_lockscreen = wibox {
		screen = s,
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

local create_lock_screens = function(s)
	if s.index == 1 then
		s.lockscreen = locker(s)
	else
		s.lockscreen_extended = locker_ext(s)
	end
end

-- Dont show notification popups if the screen is locked
local check_lockscreen_visibility = function()
	focused = awful.screen.focused()
	if focused.lockscreen and focused.lockscreen.visible then
		return true
	end
	if focused.lockscreen_extended and focused.lockscreen_extended.visible then
		return true
	end
	return false
end

naughty.connect_signal(
	'request::display',
	function(_)
		if check_lockscreen_visibility() then
			naughty.destroy_all_notifications(nil, 1)
		end
	end
)

-- Background Mode Processes
local blur_resize_image = function(wall_name, index, ap, width, height)
	local magic = [[
	sh -c "
	if [ ! -d ]] .. tmp_wall_dir ..[[ ]; then mkdir -p ]] .. tmp_wall_dir .. [[; fi

	convert -quality 100 -brightness-contrast -20x0 -filter Gaussian -blur 0x10 ]] .. wall_dir .. wall_name .. 
	[[ -gravity center -crop ]] .. ap .. [[:1 +repage -resize ]] .. width .. 'x' .. height .. 
	[[! ]] .. tmp_wall_dir .. index .. wall_name .. [[
	"]]
	return magic
end

local resize_image = function(wall_name, index, ap, width, height)
	local magic = [[
	sh -c "
	if [ ! -d ]] .. tmp_wall_dir ..[[ ]; then mkdir -p ]] .. tmp_wall_dir .. [[; fi

	convert -quality 100 -brightness-contrast -20x0 ]] .. wall_dir .. wall_name .. 
	[[ -gravity center -crop ]] .. ap .. [[:1 +repage -resize ]] .. width .. 'x' .. height .. 
	[[! ]] .. tmp_wall_dir .. index .. wall_name .. [[
	"]]
	return magic
end

local apply_ls_bg_image = function(wall_name)
	for s in screen do
		local index = s.index .. '-'

		local screen_width = s.geometry.width
		local screen_height = s.geometry.height

		local aspect_ratio = screen_width / screen_height

		aspect_ratio = math.floor(aspect_ratio * 100) / 100

		local cmd = nil
		if blur_background then
			cmd = blur_resize_image(wall_name, index, aspect_ratio, screen_width, screen_height)
		else
			cmd = resize_image(wall_name, index, aspect_ratio, screen_width, screen_height)
		end

		if s.index == 1 then
			awful.spawn.easy_async_with_shell(
				cmd,
				function(stdout, stderr)
					s.lockscreen.bgimage = tmp_wall_dir .. index .. wall_name
				end
			)
		else
			awful.spawn.easy_async_with_shell(
				cmd,
				function() 
					s.lockscreen_extended.bgimage = tmp_wall_dir .. index .. wall_name
				end
			)
		end
	end
end

-- Create a lockscreen and its background for each screen on start-up
screen.connect_signal(
	'request::desktop_decoration',
	function(s)
		create_lock_screens(s)
		apply_ls_bg_image(default_wall_name)
	end
)

-- Regenerate lockscreens and its background if a screen was added to avoid errors
screen.connect_signal(
	'added', 
	function(s)
		create_lock_screens(s)
		apply_ls_bg_image(default_wall_name)
	end

)

-- Regenerate lockscreens and its background if a screen was removed to avoid errors
screen.connect_signal(
	'removed',
	function(s)
		create_lock_screens(s)
		apply_ls_bg_image(default_wall_name)
	end
)
