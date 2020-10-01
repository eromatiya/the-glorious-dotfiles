local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local filesystem = gears.filesystem
local dpi = beautiful.xresources.apply_dpi
local icons = require('theme.icons')
local apps = require('configuration.apps')
local clickable_container = require('widget.clickable-container')
local config_dir = filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'configuration/user-profile/'

local msg_table = {
	'See you later, alligator!',
	'After a while, crocodile.',
	'Stay out of trouble.',
	'I’m out of here.',
	'Yamete, onii-chan~. UwU',
	'Okay...bye, fry guy!',
	'Peace out!',
	'Peace out, bitch!',
	'Gotta get going.',
	'Out to the door, dinosaur.',
	'Don\'t forget to come back!',
	'Smell ya later!',
	'In a while, crocodile.',
	'Adios, amigo.',
	'Begone!',
	'Arrivederci.',
	'Never look back!',
	'So long, sucker!',
	'Au revoir!',
	'Later, skater!',
	'That\'ll do pig. That\'ll do.',
	'Happy trails!',
	'Smell ya later!',
	'See you soon, baboon!',
	'Bye Felicia!',
	'Sayonara!',
	'Ciao!',
	'Well.... bye.',
	'Delete your browser history!',
	'See you, Space Cowboy!',
	'Change da world. My final message. Goodbye.',
	'Find out on the next episode of Dragonball Z...'
}

local greeter_message = wibox.widget {
	markup = 'Choose wisely!',
	font = 'Inter UltraLight 48',
	align = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

local profile_name = wibox.widget {
	markup = 'user@hostname',
	font = 'Inter Bold 12',
	align = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

local profile_imagebox = wibox.widget {
	image = widget_icon_dir .. 'default.svg',
	resize = true,
	forced_height = dpi(140),
	clip_shape = gears.shape.circle,
	widget = wibox.widget.imagebox
}

local update_profile_pic = function()
	awful.spawn.easy_async_with_shell(
		apps.utils.update_profile,
		function(stdout)
			stdout = stdout:gsub('%\n','')
			if not stdout:match('default') then
				profile_imagebox:set_image(stdout)
			else
				profile_imagebox:set_image(widget_icon_dir .. 'default.svg')
			end
			profile_imagebox:emit_signal('widget::redraw_needed')
		end
	)
end

update_profile_pic()

local update_user_name = function()
	awful.spawn.easy_async_with_shell(
		[[
		fullname="$(getent passwd `whoami` | cut -d ':' -f 5 | cut -d ',' -f 1 | tr -d "\n")"
		if [ -z "$fullname" ];
		then
				printf "$(whoami)@$(hostname)"
		else
			printf "$fullname"
		fi
		]],
		function(stdout)
			stdout = stdout:gsub('%\n','')
			local first_name = stdout:match('(.*)@') or stdout:match('(.-)%s')
			first_name = first_name:sub(1, 1):upper() .. first_name:sub(2)
			profile_name:set_markup(stdout)
			profile_name:emit_signal('widget::redraw_needed')
		end
	)
end

update_user_name()

local update_greeter_msg = function()
	greeter_message:set_markup(msg_table[math.random(#msg_table)])
	greeter_message:emit_signal('widget::redraw_needed')
end

update_greeter_msg()

local build_button = function(icon, name)
	local button_text = wibox.widget {
		text = name,
		font = beautiful.font,
		align = 'center',
		valign = 'center',
		widget = wibox.widget.textbox
	}

	local a_button = wibox.widget {
		{
			{
				{
					{
						image = icon,
						widget = wibox.widget.imagebox
					},
					margins = dpi(16),
					widget = wibox.container.margin
				},
				bg = beautiful.groups_bg,
				widget = wibox.container.background
			},
			shape = gears.shape.rounded_rect,
			forced_width = dpi(90),
			forced_height = dpi(90),
			widget = clickable_container
		},
		left = dpi(24),
		right = dpi(24),
		widget = wibox.container.margin
	}

	local build_a_button = wibox.widget {
		layout = wibox.layout.fixed.vertical,
		spacing = dpi(5),
		a_button,
		button_text
	}
	return build_a_button
end

local suspend_command = function()
	awesome.emit_signal('module::exit_screen:hide')
	awful.spawn.with_shell(apps.default.lock .. ' & systemctl suspend')
end

local logout_command = function()
	awesome.quit()
end

local lock_command = function()
	awesome.emit_signal('module::exit_screen:hide')
	awful.spawn.with_shell('sleep 1 && ' .. apps.default.lock)
end

local poweroff_command = function()
	awful.spawn.with_shell('poweroff')
	awesome.emit_signal('module::exit_screen:hide')
end

local reboot_command = function()
	awful.spawn.with_shell('reboot')
	awesome.emit_signal('module::exit_screen:hide')
end

local poweroff = build_button(icons.power, 'Shutdown')
poweroff:connect_signal(
	'button::release',
	function()
		poweroff_command()
	end
)

local reboot = build_button(icons.restart, 'Restart')
reboot:connect_signal(
	'button::release',
	function()
		reboot_command()
	end
)

local suspend = build_button(icons.sleep, 'Sleep')
suspend:connect_signal(
	'button::release',
	function()
		suspend_command()
	end
)

local exit = build_button(icons.logout, 'Logout')
exit:connect_signal(
	'button::release',
	function()
		logout_command()
	end
)

local lock = build_button(icons.lock, 'Lock')
lock:connect_signal(
	'button::release',
	function()
		lock_command()
	end
)

local create_exit_screen = function(s)
	s.exit_screen = wibox
	{
		screen = s,
		type = 'splash',
		visible = false,
		ontop = true,
		bg = beautiful.background,
		fg = beautiful.fg_normal,
		height = s.geometry.height,
		width = s.geometry.width,
		x = s.geometry.x,
		y = s.geometry.y
	}

	s.exit_screen:buttons(
		gears.table.join(
			awful.button(
				{},
				2,
				function()
					awesome.emit_signal('module::exit_screen:hide')
				end
				),
			awful.button(
				{},
				3,
				function()
					awesome.emit_signal('module::exit_screen:hide')
				end
			)
		)
	)

	s.exit_screen : setup {
		layout = wibox.layout.align.vertical,
		expand = 'none',
		nil,
		{
			layout = wibox.layout.align.vertical,
			{
				nil,
				{
					layout = wibox.layout.fixed.vertical,
					spacing = dpi(5),
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
						nil
					},
					profile_name
				},
				nil,
				expand = 'none',
				layout = wibox.layout.align.horizontal
			},
			{
				layout = wibox.layout.align.horizontal,
				expand = 'none',
				nil,
				{
					widget = wibox.container.margin,
					margins = dpi(15),
					greeter_message
				},
				nil
			},
			{
				layout = wibox.layout.align.horizontal,
				expand = 'none',
				nil,
				{
					{
						{
							poweroff,
							reboot,
							suspend,
							exit,
							lock,
							layout = wibox.layout.fixed.horizontal
						},
						spacing = dpi(30),
						layout = wibox.layout.fixed.vertical
					},
					widget = wibox.container.margin,
					margins = dpi(15)
				},
				nil
			}
		},
		nil
	}
end

screen.connect_signal(
	'request::desktop_decoration',
	function(s)
		create_exit_screen(s)
	end
)

screen.connect_signal(
	'removed',
	function(s)
		create_exit_screen(s)
	end
)

local exit_screen_grabber = awful.keygrabber {
	auto_start = true,
	stop_event = 'release',
	keypressed_callback = function(self, mod, key, command) 
	if key == 's' then
		suspend_command()

	elseif key == 'e' then
		logout_command()

	elseif key == 'l' then
		lock_command()

	elseif key == 'p' then
		poweroff_command()

	elseif key == 'r' then
		reboot_command()

	elseif key == 'Escape' or key == 'q' or key == 'x' then
		awesome.emit_signal('module::exit_screen:hide')
	end
end
}

awesome.connect_signal(
	'module::exit_screen:show',
	function() 
		for s in screen do
			s.exit_screen.visible = false
		end
		awful.screen.focused().exit_screen.visible = true
		exit_screen_grabber:start()
	end
)

awesome.connect_signal(
	'module::exit_screen:hide',
	function()
		update_greeter_msg()
		exit_screen_grabber:stop()
		for s in screen do
			s.exit_screen.visible = false
		end
	end
)
