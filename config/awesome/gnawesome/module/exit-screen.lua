local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')

local dpi = require('beautiful').xresources.apply_dpi

local icons = require('theme.icons')
local apps = require('configuration.apps')
local clickable_container = require('widget.clickable-container')

-- Appearance
local icon_size = beautiful.exit_screen_icon_size or dpi(90)

local user_name = wibox.widget {
	markup = 'Choose wisely, $USER!',
	font = 'SF Pro Text UltraLight 48',
	align = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

awful.spawn.easy_async_with_shell("whoami", function(stdout) 
	if stdout then
		-- Remove new line
		local username = stdout:gsub('%\n','')

		-- Capitalize first letter of username
		-- Comment it if you're not using your name as your username
		username = username:sub(1, 1):upper() .. username:sub(2)

		user_name:set_markup('Choose wisely,' .. ' ' .. username .. '!')
	end
end, false)


local buildButton = function(icon, name)

	local button_text = wibox.widget {
		text = name,
		font = beautiful.font,
		align = 'center',
		valign = 'center',
		widget = wibox.widget.textbox
	}

	local abutton = wibox.widget {
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
			forced_width = icon_size,
			forced_height = icon_size,
			widget = clickable_container
		},
		left = dpi(24),
		right = dpi(24),
		widget = wibox.container.margin
	}

	local buildabutton = wibox.widget {
		layout = wibox.layout.fixed.vertical,
		spacing = dpi(5),
		abutton,
		button_text
	}

	return buildabutton
end

suspend_command = function()
	exit_screen_hide()
	awful.spawn.with_shell(apps.default.lock .. ' & systemctl suspend')
end

exit_command = function()
	_G.awesome.quit()
end

lock_command = function()
	exit_screen_hide()
	awful.spawn.with_shell('sleep 1 && ' .. apps.default.lock)
end

poweroff_command = function()
	awful.spawn.with_shell('poweroff')
	awesome.emit_signal("module::exit_screen_hide")
end

reboot_command = function()
	awful.spawn.with_shell('reboot')
	awesome.emit_signal("module::exit_screen_hide")
end

local poweroff = buildButton(icons.power, 'Shutdown')
poweroff:connect_signal(
	'button::release',
	function()
		poweroff_command()
	end
)

local reboot = buildButton(icons.restart, 'Restart')
reboot:connect_signal(
	'button::release',
	function()
		reboot_command()
	end
)

local suspend = buildButton(icons.sleep, 'Sleep')
suspend:connect_signal(
	'button::release',
	function()
		suspend_command()
	end
)

local exit = buildButton(icons.logout, 'Logout')
exit:connect_signal(
	'button::release',
	function()
		exit_command()
	end
)

local lock = buildButton(icons.lock, 'Lock')
lock:connect_signal(
	'button::release',
	function()
		lock_command()
	end
)

-- Create exit screen on every screen
screen.connect_signal("request::desktop_decoration", function(s)

	-- Get screen geometry
	local screen_geometry = s.geometry

	-- Create the widget
	s.exit_screen = wibox
	{
		screen = s,
		type = 'splash',
		visible = false,
		ontop = true,
		height = screen_geometry.height,
		width = screen_geometry.width,
		x = screen_geometry.x,
		y = screen_geometry.y
	}

	s.exit_screen.bg = beautiful.background
	s.exit_screen.fg = beautiful.exit_screen_fg or beautiful.wibar_fg or '#FEFEFE'

	-- Hide exit screen
	exit_screen_hide = function()
		awesome.emit_signal("module::exit_screen_hide")

		-- Hide exit_screen in all screens
		for s in screen do
			s.exit_screen.visible = false
		end

	end


	local exit_screen_grabber = awful.keygrabber {

		auto_start          = true,
		stop_event          = 'release',
		keypressed_callback = function(self, mod, key, command) 

			if key == 's' then
				suspend_command()

			elseif key == 'e' then
				exit_command()

			elseif key == 'l' then
				lock_command()

			elseif key == 'p' then
				poweroff_command()

			elseif key == 'r' then
				reboot_command()

			elseif key == 'Escape' or key == 'q' or key == 'x' then
				exit_screen_hide()

			end

		end

	}

	-- Exit screen show
	exit_screen_show = function()

		exit_screen_grabber:start()

		-- Hide exit_screen in all screens to avoid duplication
		for s in screen do
			s.exit_screen.visible = false
		end

		-- Then open it in the focused one
		awful.screen.focused().exit_screen.visible = true

	end

	-- Signals
	awesome.connect_signal("module::exit_screen_show", function() 

		exit_screen_grabber:start()
	end)

	awesome.connect_signal("module::exit_screen_hide", function()

		exit_screen_grabber:stop()
	end)



	s.exit_screen:buttons(
		gears.table.join(
			-- Middle click - Hide exit_screen
			awful.button(
				{},
				2,
				function()
					exit_screen_hide()
				end
			),
			-- Right click - Hide exit_screen
			awful.button(
				{},
				3,
				function()
					exit_screen_hide()
				end
			)
		)
	)


	-- Item placement
	s.exit_screen:setup {
		nil,
		{
			nil,
			{
				user_name,
				{
					poweroff,
					reboot,
					suspend,
					exit,
					lock,
					layout = wibox.layout.fixed.horizontal
				},
				spacing = dpi(40),
				layout = wibox.layout.fixed.vertical
			},
			nil,
			expand = 'none',
			layout = wibox.layout.align.horizontal
		},
		nil,
		expand = 'none',
		layout = wibox.layout.align.vertical
	}


end)