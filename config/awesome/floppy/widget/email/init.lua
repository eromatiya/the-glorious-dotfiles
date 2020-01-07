local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local wibox = require('wibox')

local dpi = require('beautiful').xresources.apply_dpi
local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/email/icons/'

local naughty = require('naughty')

local mail_counter = 0

-- Set email account credentials here
-- Make sure to encrypt this file
-- Generate an app password from your email account; just google it.
local email_account   = ''
local app_password    = ''
local imap_server     = ''
local port            = ''



local email_icon_widget = wibox.widget {
  {
    id = 'icon',
    image = PATH_TO_ICONS .. 'email' .. '.svg',
    resize = true,
    forced_height = dpi(45),
    forced_width = dpi(45),
    widget = wibox.widget.imagebox,
  },
  layout = wibox.layout.fixed.horizontal
}

local email_header = wibox.widget {
  text   = "Email",
  font   = 'SFNS Display Regular 14',
  align  = 'center',
  valign = 'center',
  widget = wibox.widget.textbox
}

local email_count = wibox.widget {
  markup = '<span font="SFNS Display Regular 14">Loading...</span>',
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

print(unread)
END
]]


-- Show unread emails
local read_unread = [[
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
            print ("Local Date:", local_date.strftime("%a, %d %b %Y %H:%M:%S"))
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

-- Widget layout
local email_report = wibox.widget{
  expand = 'none',
  layout = wibox.layout.fixed.vertical,
  {
    wibox.widget {
      wibox.container.margin(email_header, dpi(10), dpi(10), dpi(10), dpi(10)),
      bg = beautiful.bg_modal_title,
      shape = function(cr, width, height)
      gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, beautiful.modal_radius) end,
      widget = wibox.container.background,
    },
    layout = wibox.layout.fixed.vertical,
  },
  {
    {
      expand = "none",
      layout = wibox.layout.fixed.horizontal,
      {
        wibox.widget {
          email_icon_widget,
          margins = dpi(4),
          widget = wibox.container.margin
        },
        margins = dpi(5),
        widget = wibox.container.margin
      },
      {
        {

          layout = wibox.layout.flex.vertical,
          email_count,
        },
        margins = dpi(4),
        widget = wibox.container.margin
      },
    },
    bg = beautiful.bg_modal,
    shape = function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, beautiful.modal_radius) end,
    widget = wibox.container.background
  },
}

-- Create a notification
local notify_new_email = function(count)
  if tonumber(count) > tonumber(mail_counter) then
    mail_counter = count
    naughty.notify({ 
      title = "Message received!",
      text = "You have an unread email!",
      app_name = 'Email',
      icon = PATH_TO_ICONS .. 'email' .. '.svg'
    })
  else
    mail_counter = count
  end
end

-- Set text
local set_markup = function(mail_count)

  if mail_count == 'no-credentials' then
    email_count.markup = '<span font="SFNS Display Regular 14">Email credentials are required!</span>'
    return
  end

  if mail_count == 'no-network' then
    email_count.markup = '<span font="SFNS Display Regular 14">Check internet connection!</span>'
    return
  end


  if tonumber(mail_count) <= 1 then
    email_count.markup = '<span font="SFNS Display Regular 14">You have ' .. mail_count .. ' unread email!</span>'
  else
    email_count.markup = '<span font="SFNS Display Regular 14">You have ' .. mail_count .. ' unread emails!</span>'
  end
end


local update_widget = function()
  awful.spawn.easy_async_with_shell(check_count, function(stdout)
    if tonumber(stdout) ~= nil then
      unread_count = stdout:gsub('%\n','')
      -- Update textbox
      set_markup(unread_count)
      -- Notify
      notify_new_email(unread_count)
    else
      -- Update textbox
      set_markup('no-network')
    end
  end)
end


local check_credentials = function()
  if email_account == '' or app_password == '' or imap_server == '' or port == '' then
    set_markup('no-credentials')
  else
    -- Update widget
    update_widget()
  end
end


-- Updater
local update_widget_timer = gears.timer {
  timeout = 60,
  autostart = true,
  call_now = true,
  callback  = function()
    -- Check if there's a credentials
    check_credentials() 
end
}


-- A tooltip
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


-- Update tooltip
function show_emails()
  awful.spawn.easy_async_with_shell(read_unread, function(stdout, stderr, reason, exit_code)
    if (stdout:match("%W")) then
      if stdout ~= nil then
        read_emails.text = stdout
      else
        read_emails.text = 'Loading...'
      end
    else
      read_emails.text = 'No unread emails...'
    end
  end
  )
end

-- Show unread emails on hover
email_icon_widget:connect_signal("mouse::enter", function() show_emails() end)


return email_report
