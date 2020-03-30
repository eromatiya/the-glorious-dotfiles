local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local wibox = require('wibox')
local naughty = require('naughty')

local dpi = beautiful.xresources.apply_dpi

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/email/icons/'

-- Retrieve credentials
local secrets = require('configuration.secrets')

local mail_counter = 0

local email_state = nil


-- Credentials
local email_account   = secrets.email.address
local app_password    = secrets.email.app_password
local imap_server     = secrets.email.imap_server
local port            = secrets.email.port


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

-- local email_header = wibox.widget {
--   text   = "Email",
--   font   = 'SF Pro Text Regular 14',
--   align  = 'center',
--   valign = 'center',
--   widget = wibox.widget.textbox
-- }

local email_unread_text = wibox.widget {
	text = 'Unread emails:',
	font = 'SF Pro Text Bold 10',
	align = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

local email_count = wibox.widget {
	text = '0',
	font = 'SF Pro Text Regular 10',
	align = 'left',
	valign = 'center',
	widget = wibox.widget.textbox
}

local email_recent_from = wibox.widget {
	-- text = 'From:',
	font = 'SF Pro Text Regular 10',
	markup = '<span font="SF Pro Text Bold 10">From: </span>loading@stdout.sh',
	align = 'left',
	valign = 'center',
	widget = wibox.widget.textbox
}

local email_recent_subject = wibox.widget {
	markup = '<span font="SF Pro Text Bold 10">Subject: </span>Loading data',
	-- font = 'SF Pro Text Regular 10',
	align = 'left',
	valign = 'center',
	widget = wibox.widget.textbox
}

-- Show email count
local check_count = [[
# A simple python script to get email count wrapped inside bash wrapped inside lua lol
# Make sure to encrypt this
python3 - <<END
import imaplib
import re

M=imaplib.IMAP4_SSL("]] .. imap_server .. [[", ]] .. port .. [[)
M.login("]] .. email_account .. [[","]] .. app_password .. [[")

status, counts = M.status("INBOX","(MESSAGES UNSEEN)")

if status == "OK":
	unread = re.search(r'UNSEEN\s(\d+)', counts[0].decode('utf-8')).group(1)
else:
	unread = "N/A"

print (unread)
END
]]


-- Script to show unread emails in tooltip
local get_unread = [[
# A simple python script to get unread emails wrapped inside bash wrapped inside lua lol
# Make sure to encrypt this
python3 - <<END
import imaplib
import email
import datetime

def process_mailbox(M):
	rv, data = M.search(None, "(UNSEEN)")
	if rv != 'OK':
		print ("No messages found!")
		return

	for num in data[0].split():
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


M=imaplib.IMAP4_SSL("]] .. imap_server .. [[", ]] .. port .. [[)
M.login("]] .. email_account .. [[","]] .. app_password .. [[")

rv, data = M.select("INBOX")
if rv == 'OK':
		process_mailbox(M)
M.close()
M.logout()

END
]]


-- Show the mose recent received email details
local read_recent_datails = [[
# A simple python script to get unread emails wrapped inside bash wrapped inside lua lol
# Make sure to encrypt this
python3 - <<END
import imaplib
import email
import datetime

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
		return


M=imaplib.IMAP4_SSL("]] .. imap_server .. [[", ]] .. port .. [[)
M.login("]] .. email_account .. [[","]] .. app_password .. [[")

rv, data = M.select("INBOX")
if rv == 'OK':
		process_mailbox(M)
M.close()
M.logout()

END
]]




-- Widget layout
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
					{
						layout = wibox.layout.fixed.horizontal,
						spacing = dpi(5),
						email_unread_text,
						email_count
					},
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
		gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, beautiful.groups_radius) end,
	widget = wibox.container.background
}



-- Create a notification
local notify_new_email = function(count)
	if tonumber(count) > tonumber(mail_counter) then
		mail_counter = count
		naughty.notification({ 
			title = "Message received!",
			message = "You have an unread email!",
			app_name = 'Email',
			icon = widget_icon_dir .. 'email-unread' .. '.svg'
		})
		email_icon_widget.icon:set_image(widget_icon_dir .. 'email-unread' .. '.svg')
	else
		mail_counter = count
	end

	if tonumber(count) == 0 then
		email_icon_widget.icon:set_image(widget_icon_dir .. 'email' .. '.svg')
	end
end

-- Set text for missing credentials and no internet connection
local set_error_msg = function(status)

	if status == 'no-credentials' then
		email_recent_from.markup = '<span font="SF Pro Text Bold 10">From: </span>' .. 'message@stderr.sh'
		email_recent_subject.markup = '<span font="SF Pro Text Bold 10">Subject: </span>' .. 'Credentials are missing!'
		return
	end

	if status == 'no-network' then
		email_recent_from.markup = '<span font="SF Pro Text Bold 10">From: </span>' .. 'message@stderr.sh'
		email_recent_subject.markup = '<span font="SF Pro Text Bold 10">Subject: </span>' .. 'Check network connection!'
		return
	end

end


-- Update textbox to show recent email details
local set_email_details = function()
	awful.spawn.easy_async_with_shell(read_recent_datails, function(stdout)
		if stdout:match('%W') then
			local text_from = stdout:match('From: (.*)Subject:'):gsub('%\n','')
			local text_subject = stdout:match('Subject: (.*)'):gsub('%\n','')

			-- Only get the email address
			text_from = text_from:match('<(.*)>')

			email_recent_from.markup = '<span font="SF Pro Text Bold 10">From: </span>' .. text_from
			email_recent_subject.markup = '<span font="SF Pro Text Bold 10">Subject: </span>' .. text_subject
		end
	end)
end


-- Update textbox to show that there's no unread email
local set_no_email_details = function()
	awful.spawn.easy_async_with_shell(read_recent_datails, function(stdout)

		email_recent_from.markup = '<span font="SF Pro Text Bold 10">From: </span>' .. 'empty@stdout.sh'
		email_recent_subject.markup = '<span font="SF Pro Text Bold 10">Subject: </span>' .. 'Empty inbox'
	end)
end


-- A tooltip that will show all the unread emails
local read_emails = awful.tooltip
{
	text = 'Loading...',
	objects = {email_icon_widget},
	mode = 'outside',
	align = 'right',
	preferred_positions = {'right', 'left', 'top', 'bottom'},
	margin_leftright = dpi(8),
	margin_topbottom = dpi(8)
}


-- Update tooltip content
local update_tooltip = function()
	awful.spawn.easy_async_with_shell(get_unread, function(stdout)
		if (stdout:match("%W")) then
			if stdout ~= nil then
				read_emails.text = stdout:gsub('\n$', '')
			else
				read_emails.text = 'Loading...'
			end
		else
			read_emails.text = 'No unread emails...'
		end
	end)
end


local update_widget = function()
	awful.spawn.easy_async_with_shell(check_count, function(stdout)
		if tonumber(stdout) ~= nil then
			unread_count = stdout:gsub('%\n','')

			if tonumber(unread_count) > 0 then
				-- Get from and Subject
				set_email_details()
			else
				-- Set empty messages
				set_no_email_details()
			end

			-- Update unread count
			email_count.text = tonumber(unread_count)

			-- Update tooltip
			update_tooltip()
	
			-- Notify
			notify_new_email(unread_count)
		else
			-- Send no network err msg
			set_error_msg('no-network')
		end
	end)
end


local check_credentials = function()
	if email_account == '' or app_password == '' or imap_server == '' or port == '' then
		-- Send no credential/s err msg
		set_error_msg('no-credentials')
	else
		-- If there's credentials, update widget
		update_widget()
	end
end


-- Updater
local update_widget_timer = gears.timer {
	timeout = 30,
	autostart = true,
	call_now = true,
	callback  = function()
		-- Check if there's a credentials
		check_credentials() 
	end
}

-- Update widget after connecting to wifi
awesome.connect_signal('system::wifi_connected', function()
	-- Add a delay of 3 seconds
	gears.timer.start_new(3, function() 
		check_credentials()
	end)
end)


-- Update content if hovers on widget
email_report:connect_signal("mouse::enter", function() 
	-- Update email widget
	check_credentials()
end)


return email_report
