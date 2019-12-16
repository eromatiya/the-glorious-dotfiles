local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local wibox = require('wibox')

local dpi = require('beautiful').xresources.apply_dpi
local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/gmail/icons/'

local naughty = require('naughty')

local gmail_icon_widget = wibox.widget {
  {
    id = 'icon',
    image = PATH_TO_ICONS .. 'gmail' .. '.svg',
    resize = true,
    forced_height = dpi(45),
    forced_width = dpi(45),
    widget = wibox.widget.imagebox,
  },
  layout = wibox.layout.fixed.horizontal
}

local gmail_header = wibox.widget {
  text   = "Gmail",
  font   = 'SFNS Display Regular 14',
  align  = 'center',
  valign = 'center',
  widget = wibox.widget.textbox
}


local gmail_count = wibox.widget {
  markup = '<span font="SFNS Display Regular 14">Loading...</span>',
  align = 'left',
  valign = 'center',
  widget = wibox.widget.textbox
}

-- Set email account credentials here
-- Make sure to ecrypt this file
local gmail_account   = ''
local gmail_password  = ''
local imap_server     = 'imap.gmail.com'
local port            = '993'

local check_count = [[
# A simple python script to get email count wrapped inside bash wrapped inside lua lol
# Make sure to encrypt this
python3 - <<END
import imaplib
import re

M=imaplib.IMAP4_SSL("]] .. imap_server .. [[", ]] .. port .. [[)
M.login("]] .. gmail_account .. [[","]] .. gmail_password .. [[")

status, counts = M.status("INBOX","(MESSAGES UNSEEN)")

if status == "OK":
  unread = re.search(r'UNSEEN\s(\d+)', counts[0].decode('utf-8')).group(1)
else:
  unread = "N/A"

print(unread)
END
]]


local read_undread = [[
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
M.login("]] .. gmail_account .. [[","]] .. gmail_password .. [[")

rv, data = M.select("INBOX")
if rv == 'OK':
    process_mailbox(M)
M.close()
M.logout()

END
]]



  local gmail_report = wibox.widget{
    expand = 'none',
    layout = wibox.layout.fixed.vertical,
    {
      wibox.widget {
        wibox.container.margin(gmail_header, dpi(10), dpi(10), dpi(10), dpi(10)),
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
            gmail_icon_widget,
            margins = dpi(4),
            widget = wibox.container.margin
          },
          margins = dpi(5),
          widget = wibox.container.margin
        },
        {
          {

            layout = wibox.layout.flex.vertical,
            gmail_count,
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



  -- Updater
  local updateWidget = gears.timer {
    timeout = 60,
    autostart = true,
    call_now = true,
    callback  = function()
    awful.spawn.easy_async_with_shell(check_count, function(stdout)
      if tonumber(stdout) ~= nil then
        unread_count = stdout:gsub('%\n','')
        if tonumber(unread_count) > 1 then
          gmail_count.markup = '<span font="SFNS Display Regular 14">You have ' .. unread_count .. ' unread emails!</span>'
        else
          gmail_count.markup = '<span font="SFNS Display Regular 14">You have ' .. unread_count .. ' unread email!</span>'
        end
      else
        gmail_count.markup = '<span font="SFNS Display Regular 14">Check internet connection!</span>'
      end
    end)
  end
}



local read_emails = awful.tooltip
{
  text = 'Loading...',
  objects = {gmail_icon_widget},
  mode = 'outside',
  align = 'right',
  preferred_positions = {'right', 'left', 'top', 'bottom'},
  margin_leftright = dpi(8),
  margin_topbottom = dpi(8)
}



function show_emails()
  awful.spawn.easy_async_with_shell(read_undread, function(stdout, stderr, reason, exit_code)
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

gmail_icon_widget:connect_signal("mouse::enter", function() show_emails() end)


return gmail_report
