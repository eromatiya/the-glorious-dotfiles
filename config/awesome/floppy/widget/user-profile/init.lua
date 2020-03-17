-- User profile widget
-- Optional dependency:
--    mugshot (use to update profile picture and information)


local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local naughty = require('naughty')

local dpi = beautiful.xresources.apply_dpi

local clickable_container = require('widget.clickable-container')

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/user-profile/icons/'

local user_icon_dir = '/var/lib/AccountsService/icons/'

title_table = {
	"Hey, I have a message for you",
	"Listen here you little shit!",
	"Le' me tell you a secret",
	"I never lie",
	"Message received from your boss"
}

message_table = {
	"Let me rate your face! Oops... It looks like I can't compute negative numbers. You're ugly af, sorry",
	"Lookin' good today, now fuck off!",
	"The last thing I want to do is hurt you. But it’s still on the list.",
	"If I agreed with you we’d both be wrong.",
	"I intend to live forever. So far, so good.",
	"Jesus loves you, but everyone else thinks you’re an asshole.",
	"Your baby is so ugly, you should have thrown it away and kept the stork.",
	"If your brain was dynamite, there wouldn’t be enough to blow your hat off.",
	"You are more disappointing than an unsalted pretzel.",
	"Your kid is so ugly, he makes his Happy Meal cry.",
	"Your secrets are always safe with me. I never even listen when you tell me them.",
	"I only take you everywhere I go just so I don’t have to kiss you goodbye.",
	"You look so pretty. Not at all gross, today.",
	"It’s impossible to underestimate you.",
	"I’m not insulting you, I’m describing you.",
	"Keep rolling your eyes, you might eventually find a brain.",
	"You bring everyone so much joy, when you leave the room.",
	"I thought of you today. It reminded me to take out the trash.",
	"You are the human version of period cramps.",
	"You’re the reason God created the middle finger."
}


local profile_imagebox = wibox.widget {
	{
		id = 'icon',
		forced_height = dpi(45),
		forced_width = dpi(45),
		image = widget_icon_dir .. 'user' .. '.svg',
		clip_shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius) end,
		widget = wibox.widget.imagebox,
		resize = true
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
				naughty.notification({
					app_name = "FBI's ChatBot v69",
					title = title_table[math.random(#title_table)],
					message = message_table[math.random(#message_table)] .. 
					"\n\n- xXChatBOT69Xx",
					urgency = 'normal'
				})
			end
		)
	)
)


local profile_name = wibox.widget {
	font = "SF Pro Text Bold 14",
	markup = 'User',
	align = 'left',
	valign = 'center',
	widget = wibox.widget.textbox
}

local distro_name = wibox.widget {
	font = "SF Pro Text Regular 11",
	markup = 'GNU/Linux',
	align = 'left',
	valign = 'center',
	widget = wibox.widget.textbox
}

local kernel_version = wibox.widget {
	font = "SF Pro Text Regular 10",
	markup = 'Linux',
	align = 'left',
	valign = 'center',
	widget = wibox.widget.textbox
}

local uptime_time = wibox.widget {
	font = "SF Pro Text Regular 10",
	markup = 'up 1 minute',
	align = 'left',
	valign = 'center',
	widget = wibox.widget.textbox
}

-- Get profile picture

local user_jpg_checker = [[
if test -f ]] .. widget_icon_dir .. 'user.jpg' .. [[; then print 'yes'; fi
]]

awful.spawn.easy_async_with_shell(user_jpg_checker, function(already)

	if already:match('yes') then
		
		-- Update imagebox
		profile_imagebox.icon:set_image(widget_icon_dir .. 'user.jpg')
	
	else

		-- Get username first
		awful.spawn.easy_async_with_shell('whoami', function(stdout)

			local username = stdout:gsub('%W', '')

			local check_profile_pic_cmd = [[
			if test -f ]] .. user_icon_dir .. username .. [[; then print 'detected'; fi
			]]


			-- Check AccountsService if user profile image is available
			awful.spawn.easy_async_with_shell(check_profile_pic_cmd, function(status) 


			-- If image exist
			if status:match('detected') then

				-- Copy it to widget icon folder as `user.jpg`
				copy_profile_image_cmd = [[
				cp ]] .. user_icon_dir .. username .. [[ ]] .. widget_icon_dir .. [[user.jpg
				]]

				-- Copy
				awful.spawn.easy_async(copy_profile_image_cmd)


				-- Update imagebox with a delay
				gears.timer.start_new(1, function() 
					profile_imagebox.icon:set_image(widget_icon_dir .. 'user.jpg')
				end)

			else

				-- No image in AccountsService, use the default picture
				profile_imagebox.icon:set_image(widget_icon_dir .. 'user' .. '.svg')

			end

			end, false)
		end, false)
	end
end, false)


-- Get username

awful.spawn.easy_async_with_shell('whoami', function(stdout) 

	i_am_who = stdout:gsub('%W', '')

	-- Capitalize first letter
	-- i_am_who = i_am_who:sub(1,1):upper() .. i_am_who:sub(2)

	awful.spawn.easy_async_with_shell('hostname', function(host)

		host_who = host:gsub('%W', '')
		
		profile_name.markup = i_am_who .. '@' .. host_who


	end, false)


end, false)

-- Get distro name

local get_distro_name_cmd = [[
cat /etc/os-release | awk 'NR==1'| awk -F '"' '{print $2}'
]]

awful.spawn.easy_async_with_shell(get_distro_name_cmd, function(out)

	distroname = out:gsub('%\n', '')
	distro_name.markup = distroname

end)

awful.spawn.easy_async_with_shell('uname -r', function(out)

	kname = out:gsub('%\n', '')
	kernel_version.markup = kname

end)


-- Get and update uptime

local update_uptime = function()
	awful.spawn.easy_async_with_shell("uptime -p", function(out)
		uptime = out:gsub('%\n','')
		uptime_time.markup = uptime		
	end)
end

local uptime_updater_timer = gears.timer{
	timeout = 60,
	autostart = true,
	call_now = true,
	callback = function()
		update_uptime()
	end
}


local user_profile = wibox.widget {
	{
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(10),
			{
				layout = wibox.layout.align.vertical,
				expand = 'none',
				nil,
				profile_imagebox,
				nil
			},
			{
				layout = wibox.layout.align.vertical,
				expand = 'none',
				nil,
				{
					layout = wibox.layout.fixed.vertical,
					profile_name,
					distro_name,
					kernel_version,
					uptime_time
				},
				nil
			}
		},
		margins = dpi(10),
		widget = wibox.container.margin
	},
	forced_height = dpi(92),
	bg = beautiful.groups_bg,
	shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius) end,
	widget = wibox.container.background
	
}

-- Update uptime on hover
user_profile:connect_signal('mouse::enter', function() 
	update_uptime()
end)



return user_profile
