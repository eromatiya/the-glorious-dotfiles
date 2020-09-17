local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local naughty = require('naughty')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local apps = require('configuration.apps')
local clickable_container = require('widget.clickable-container')
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'configuration/user-profile/'
local user_icon_dir = '/var/lib/AccountsService/icons/'

title_table = {
	'Hey, I have a message for you',
	'Listen here you little shit!',
	'Le\' me tell you a secret',
	'I never lie',
	'Message received from your boss'
}

message_table = {
	'Let me rate your face! Oops... It looks like I can\'t compute negative numbers. You\'re ugly af, sorry',
	'Lookin\' good today, now fuck off!',
	'The last thing I want to do is hurt you. But it’s still on the list.',
	'If I agreed with you we’d both be wrong.',
	'I intend to live forever. So far, so good.',
	'Jesus loves you, but everyone else thinks you’re an asshole.',
	'Your baby is so ugly, you should have thrown it away and kept the stork.',
	'If your brain was dynamite, there wouldn’t be enough to blow your hat off.',
	'You are more disappointing than an unsalted pretzel.',
	'Your kid is so ugly, he makes his Happy Meal cry.',
	'Your secrets are always safe with me. I never even listen when you tell me them.',
	'I only take you everywhere I go just so I don’t have to kiss you goodbye.',
	'You look so pretty. Not at all gross, today.',
	'It’s impossible to underestimate you.',
	'I’m not insulting you, I’m describing you.',
	'Keep rolling your eyes, you might eventually find a brain.',
	'You bring everyone so much joy, when you leave the room.',
	'I thought of you today. It reminded me to take out the trash.',
	'You are the human version of period cramps.',
	'You’re the reason God created the middle finger.'
}

local create_profile = function()
	local profile_imagebox = wibox.widget {
		{
			id = 'icon',
			image = widget_icon_dir .. 'default.svg',
			widget = wibox.widget.imagebox,
			resize = true,
			forced_height = dpi(28),
			clip_shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
			end
		},
		layout = wibox.layout.align.horizontal
	}

	profile_imagebox:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					awful.spawn.single_instance('mugshot')
				end
			),
			awful.button(
				{},
				3,
				nil,
				function()
					naughty.notification({
						app_name = 'FBI\'s ChatBot v69',
						title = title_table[math.random(#title_table)],
						message = message_table[math.random(#message_table)] .. 
						'\n\n- xXChatBOT69Xx',
						urgency = 'normal'
					})
				end
			)
		)
	)

	local profile_name = wibox.widget {
		font = 'Inter Regular 10',
		markup = 'User',
		align = 'left',
		valign = 'center',
		widget = wibox.widget.textbox
	}

	local update_profile_image = function()
		awful.spawn.easy_async_with_shell(
			apps.utils.update_profile,
			function(stdout)
				stdout = stdout:gsub('%\n','')
				if not stdout:match('default') then
					profile_imagebox.icon:set_image(stdout)
				else
					profile_imagebox.icon:set_image(widget_icon_dir .. 'default.svg')
				end
			end
		)
	end

	update_profile_image()

	awful.spawn.easy_async_with_shell(
		[[
		sh -c '
		fullname="$(getent passwd `whoami` | cut -d ':' -f 5 | cut -d ',' -f 1 | tr -d "\n")"
		if [ -z "$fullname" ];
		then
			printf "$(whoami)@$(hostname)"
		else
			printf "$fullname"
		fi
		'
		]],
		function(stdout) 
			local stdout = stdout:gsub('%\n', '')
			profile_name:set_markup(stdout)
		end
	)

	local user_profile = wibox.widget {
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(5),
		{
			layout = wibox.layout.align.vertical,
			expand = 'none',
			nil,
			profile_imagebox,
			nil
		},
		profile_name
	}

	return user_profile
end

return create_profile
