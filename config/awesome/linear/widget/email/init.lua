local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local naughty = require('naughty')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/email/icons/'

local secrets = require('configuration.secrets')

local email_account   = secrets.email.address
local app_password    = secrets.email.app_password
local imap_server     = secrets.email.imap_server
local port            = secrets.email.port

local unread_email_count = 0
local startup_show = true

local format_string = function(key, value)
	local key = "<span font='SF Pro Text Bold 10'>" .. key .. "</span>"
	return key .. ' ' .. value
end

local email_icon_widget = wibox.widget {
	{
		id = 'icon',
		image = widget_icon_dir .. 'email' .. '.svg',
		resize = true,
		forced_height = dpi(45),
		forced_width = dpi(45),
		widget = wibox.widget.imagebox,
	},
	layout = wibox.layout.fixed.horizontal
}

local email_unread_count = wibox.widget {
	markup = format_string('Unread Count:', '0'),
	font = 'SF Pro Text Regular 10',
	align = 'left',
	valign = 'center',
	widget = wibox.widget.textbox
}

local email_recent_from = wibox.widget {
	font = 'SF Pro Text Regular 10',
	markup = format_string('From:', 'loading@stdout.sh'),
	align = 'left',
	valign = 'center',
	widget = wibox.widget.textbox
}

local email_recent_subject = wibox.widget {
	font = 'SF Pro Text Regular 10',
	markup = format_string('Subject:', 'Loading data'),
	align = 'left',
	valign = 'center',
	widget = wibox.widget.textbox
}


local email_report = wibox.widget{
	{
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(10),
			{
				layout = wibox.layout.align.vertical,
				expand = 'none',
				nil,
				email_icon_widget,
				nil
			},
			{
				layout = wibox.layout.align.vertical,
				expand = 'none',
				nil,
				{
					layout = wibox.layout.fixed.vertical,
					email_unread_count,
					email_recent_from,
					email_recent_subject
				},
				nil
			}
		},
		margins = dpi(10),
		widget = wibox.container.margin
	},
	forced_height = dpi(92),
	bg = beautiful.groups_bg,
	shape = function(cr, width, height)
		gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, beautiful.groups_radius)
	end,
	widget = wibox.container.background
}

local email_details_tooltip = awful.tooltip
{
	text = 'Loading...',
	objects = {email_icon_widget},
	mode = 'outside',
	align = 'right',
	preferred_positions = {'right', 'left', 'top', 'bottom'},
	margin_leftright = dpi(8),
	margin_topbottom = dpi(8)
}

local fetch_email_command = [[
python3 - <<END
import imaplib
import email
import datetime
import re
import sys

def process_mailbox(M):
	rv, data = M.search(None, "(UNSEEN)")
	if rv != 'OK':
		print ("No messages found!")
		return

	for num in reversed(data[0].split()):
		rv, data = M.fetch(num, '(BODY.PEEK[])')
		if rv != 'OK':
			print ("ERROR getting message", num)
			return

		msg = email.message_from_bytes(data[0][1])
		print ('From:', msg['From'])
		print ('Subject: %s' % (msg['Subject']))
		date_tuple = email.utils.parsedate_tz(msg['Date'])
		if date_tuple:
			local_date = datetime.datetime.fromtimestamp(email.utils.mktime_tz(date_tuple))
			print ("Local Date:", local_date.strftime("%a, %d %b %Y %H:%M:%S") + "\n")
			# with code below you can process text of email
			# if msg.is_multipart():
			#     for payload in msg.get_payload():
			#         if payload.get_content_maintype() == 'text':
			#             print  payload.get_payload()
			#         else:
			#             print msg.get_payload()


try:
	M=imaplib.IMAP4_SSL("]] .. imap_server .. [[", ]] .. port .. [[)
	M.login("]] .. email_account .. [[","]] .. app_password .. [[")

	status, counts = M.status("INBOX","(MESSAGES UNSEEN)")

	rv, data = M.select("INBOX")
	if rv == 'OK':
		unread = re.search(r'UNSEEN\s(\d+)', counts[0].decode('utf-8')).group(1)
		print ("Unread Count: " + unread)
		process_mailbox(M)

	M.close()
	M.logout()

except Exception as e:
	if e:
		print (e)

END
]]

local notify_all_unread_email = function(email_data)
	
	local unread_counter = email_data:match('Unread Count: (.-)From:'):sub(1, -2)

	email_data = email_data:match('(From:.*)'):sub(1, -2)
	email_data = gears.string.xml_unescape(email_data)

	local title = nil

	if tonumber(unread_email_count) > 1 then
		title = 'You have ' .. unread_counter .. ' unread emails!'
	else
		title = 'You have ' .. unread_counter .. ' unread email!'
	end
	
	naughty.notification ({
		app_name = 'Email',
		title = title,
		message = email_data,
		timeout = 200,
		icon = widget_icon_dir .. 'email-unread' .. '.svg'
	})
end

local notify_new_email = function(count, from, subject)
	if not startup_show and (tonumber(count) > tonumber(unread_email_count)) then
		unread_email_count = tonumber(count)

		local message = "From: " .. from ..
		"\nSubject: " .. subject
		
		naughty.notification ({
			app_name = 'Email',
			title = 'You have a new unread email!',
			message = message,
			timeout = 200,
			icon = widget_icon_dir .. 'email-unread' .. '.svg'
		})
	else
		unread_email_count = tonumber(count)
	end

end

local set_email_data_tooltip = function(email_data)
	email_data = email_data:match('(From:.*)')
	email_details_tooltip:set_markup(email_data)
end

local set_no_connection_msg = function()
	email_recent_from:set_markup(format_string('From:', 'message@stderr.sh'))
	email_recent_subject:set_markup(format_string('Subject:', 'Check network connection!'))
	email_details_tooltip:set_markup('No internet connection!')
end

local set_invalid_credentials_msg = function()
	email_recent_from:set_markup(format_string('From:', 'message@stderr.sh'))
	email_recent_subject:set_markup(format_string('Subject:', 'Invalid Credentials!'))
	email_details_tooltip:set_markup('You have an invalid credentials!')
end

local set_latest_email_data = function(email_data)

	local unread_count = email_data:match('Unread Count: (.-)From:'):sub(1, -2)
	local recent_from = email_data:match('From: (.-)Subject:'):sub(1, -2)
	local recent_subject = email_data:match('Subject: (.-)Local Date:'):sub(1, -2)

	recent_from = recent_from:match('<(.*)>') or recent_from:match('&lt;(.*)&gt;') or recent_from

	email_unread_count:set_markup(format_string('Unread Count:', unread_count))
	email_recent_from:set_markup(format_string('From:', recent_from))
	email_recent_subject:set_markup(format_string('Subject:', recent_subject))

	notify_new_email(unread_count, recent_from, recent_subject)
end

local set_empty_inbox_msg = function()
	email_unread_count:set_markup(format_string('Unread Count:', '0'))
	email_recent_from:set_markup(format_string('From:', 'empty@stdout.sh'))
	email_recent_subject:set_markup(format_string('Subject:', 'Empty inbox'))
end

local fetch_email_data = function()
	awful.spawn.easy_async_with_shell(
		fetch_email_command,
		function(stdout)
			stdout = gears.string.xml_escape(stdout:sub(1, -2))

			if stdout:match("Temporary failure in name resolution") then
				set_no_connection_msg()
				return
			elseif stdout:match("Invalid credentials") then
				set_invalid_credentials_msg()
				return
			elseif stdout:match("Unread Count: 0") then
				email_icon_widget.icon:set_image(widget_icon_dir .. 'email.svg')
				set_empty_inbox_msg()
				email_details_tooltip:set_markup('Empty inbox.')
				return
			elseif not stdout or stdout == '' then
				return
			elseif not stdout:match('Unread Count: (.-)From:'):sub(1, -2) then
				return
			end

			set_latest_email_data(stdout)
			set_email_data_tooltip(stdout)
			email_icon_widget.icon:set_image(widget_icon_dir .. 'email-unread.svg')

			if startup_show then
				notify_all_unread_email(stdout)
				startup_show = false
			end
		end
	)
end

local set_missing_secrets_msg = function()
	email_unread_count:set_markup(format_string('Unread Count:', 'Unknown'))
	email_recent_from:set_markup(format_string('From:', 'message@stderr.sh'))
	email_recent_subject:set_markup(format_string('Subject:', 'Credentials are missing!'))
	email_details_tooltip:set_markup('Missing credentials!')
end

local check_secrets = function()
	if email_account == '' or app_password == '' or imap_server == '' or port == '' then
		set_missing_secrets_msg()
		return
	else
		fetch_email_data()
	end
end

check_secrets()

local update_widget_timer = gears.timer {
	timeout = 30,
	autostart = true,
	call_now = true,
	callback  = function()
		check_secrets() 
	end
}


email_report:connect_signal(
	"mouse::enter",
	function()
		check_secrets()
	end
)

awesome.connect_signal(
	'system::wifi_connected',
	function()
		gears.timer.start_new(
			5,
			function() 
				check_secrets()
			end
		)
	end
)

return email_report
