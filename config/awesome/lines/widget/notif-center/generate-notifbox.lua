local awful = require('awful')
local naughty = require('naughty')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local dpi = require('beautiful').xresources.apply_dpi

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/notif-center/icons/'

-- Boolean variable to remove empty message
local remove_notibox_empty = true

-- Notification boxes container layout
local notifbox_layout = wibox.layout.fixed.vertical()

-- Notification boxes container layout spacing
notifbox_layout.spacing = dpi(5)

notifbox_layout.expand = 'none'

-- Notification icon container
local notifbox_icon = function(ico_image)
  local noti_icon = wibox.widget {
    {
      id = 'icon',
      resize = true,
      forced_height = dpi(25),
      forced_width = dpi(25),
      widget = wibox.widget.imagebox,
    },
    layout = wibox.layout.fixed.horizontal
  }
  noti_icon.icon:set_image(ico_image)
  return noti_icon
end

-- Notification title container
local notifbox_title = function(title)
  return wibox.widget {
    text   = title,
    font   = 'SFNS Display Bold 12',
    align  = 'left',
    valign = 'center',
    widget = wibox.widget.textbox
  }
end

-- Notification message container
local notifbox_message = function(msg)
  return wibox.widget {
    text   = msg,
    font   = 'SFNS Display Regular 12',
    align  = 'left',
    valign = 'center',
    widget = wibox.widget.textbox
  }
end

-- Get current time
local current_time = function()
  return os.date("%H:%M:%S")
end

-- Convert time to seconds
local parse_to_seconds = function(time)
  -- Convert HH in HH:MM:SS
  hourInSec = tonumber(string.sub(time, 1, 2)) * 3600

  -- Convert MM in HH:MM:SS
  minInSec = tonumber(string.sub(time, 4, 5)) * 60

  -- Get SS in HH:MM:SS
  getSec = tonumber(string.sub(time, 7, 8))

  return (hourInSec + minInSec + getSec)

end


-- Notification actions container
local notifbox_actions = function(notif)
  actions_template = wibox.widget {
    notification = notif,
    base_layout = wibox.widget {
      spacing        = dpi(5),
      layout         = wibox.layout.flex.vertical
    },
    widget_template = {
      {
        {
          {
            id     = 'text_role',
            font   = 'SFNS Display Regular 10',
            widget = wibox.widget.textbox
          },
            widget = wibox.container.place
        },

        bg                 = beautiful.bg_modal,
        shape              = gears.shape.rounded_rect,
        border_width       = dpi(1),
        border_color       = '#ffffff40',
        forced_height      = 30,
        widget             = wibox.container.background,
      },
      margins = 4,
      widget  = wibox.container.margin,
    },
    style = { underline_normal = false, underline_selected = true },
    widget = naughty.list.actions,
  }

  return actions_template
end

-- Empty notification message
local notifbox_empty = function()
  local empty_notifbox = wibox.widget {
    {
      {
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(5),
        {
          expand = 'none',
          layout = wibox.layout.align.horizontal,
          nil, 
          {
            image = PATH_TO_ICONS .. 'empty-notification' .. '.svg',
            resize = true,
            forced_height = dpi(35),
            forced_width = dpi(35),
            widget = wibox.widget.imagebox,
          },
          nil
        },
        {
          text = 'Wow, such empty.',
          font = 'SFNS Display Italic 14',
          align = 'center',
          valign = 'center',
          widget = wibox.widget.textbox
        },
        {
          text = 'Come back later.',
          font = 'SFNS Display Italic 10',
          align = 'center',
          valign = 'center',
          widget = wibox.widget.textbox
        },
      },
      margins = dpi(20),
      widget = wibox.container.margin
    },
    border_width = dpi(1),
    border_color = '#ffffff40',
    bg = beautiful.bg_modal,
    shape = function(cr, width, height)
      gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, beautiful.modal_radius) end,
    widget = wibox.container.background,
  }
  return empty_notifbox
end

-- Reset notifbox_layout
reset_notifbox_layout = function()
  notifbox_layout:reset(notifbox_layout)
  notifbox_layout:insert(1, notifbox_empty())
  remove_notibox_empty = true
end

-- Returns the notification box
local notifbox_box = function(icon, title, message, notif)

  -- Get current time for `this` instance of box
  local time_of_pop = current_time()
  
  -- Notification time pop container
  local notifbox_timepop =  wibox.widget {
    id = 'time_pop',
    text = nil,
    font = 'SFNS Display Regular 10',
    align = 'left',
    valign = 'center',
    widget = wibox.widget.textbox
  }

  -- Timer for notification time pop
  gears.timer {
    timeout   = 60,
    call_now  = true,
    autostart = true,
    callback  = function()

      local time_difference = nil
      -- Get the time difference
      time_difference = parse_to_seconds(current_time()) - parse_to_seconds(time_of_pop)
      -- String to Number
      time_difference = tonumber(time_difference)

      -- If seconds is less than one minute
      if time_difference < 60 then
        notifbox_timepop.text = 'Now'

      -- If greater that one hour
      elseif time_difference >= 3600 then
        notifbox_timepop.text = time_of_pop

      -- Use time of popup instead
      else
        local time_in_minutes = math.floor(time_difference / 60)
        if tonumber(time_in_minutes) > 1 then
          notifbox_timepop.text = time_in_minutes .. ' ' .. 'minutes ago'
        else
          notifbox_timepop.text = time_in_minutes .. ' ' .. 'minute ago'
        end
      end

      collectgarbage('collect')
    end
  }

  -- Template of notification box
  local notifbox_template =  wibox.widget {
    id = 'notifbox_template',
    expand = 'none',
    {
      {
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(5),
        {
          expand = 'none',
          layout = wibox.layout.align.horizontal,
          notifbox_icon(icon),
          nil,
          notifbox_timepop,
        },
        {
          layout = wibox.layout.fixed.vertical,
          spacing = dpi(5),
          {
            notifbox_title(title),
            notifbox_message(message),
            layout = wibox.layout.fixed.vertical
          },
          notifbox_actions(notif),
        },

      },
      margins = dpi(10),
      widget = wibox.container.margin
    },
    border_width = dpi(1),
    border_color = '#ffffff40',
    bg = beautiful.bg_modal,
    shape = function(cr, width, height)
      gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, beautiful.modal_radius) end,
    widget = wibox.container.background,
  }

  -- Delete notification box
  local notifbox_delete = function()
    notifbox_layout:remove_widgets(notifbox_template, true)
  end

  -- Delete notification box when pressed
  notifbox_template:connect_signal("button::press", function(_, _, _, button)
    if #notifbox_layout.children == 1 then
      reset_notifbox_layout()
    else
      notifbox_delete()
    end
  end)

  return notifbox_template
end


-- Add empty notification message on start-up
notifbox_layout:insert(1, notifbox_empty())

-- Connect to naughty
naughty.connect_signal("request::display", function(n)

  -- If notifbox_layout has a child and remove_notibox_empty
  if #notifbox_layout.children == 1 and remove_notibox_empty then
    -- Reset layout
    notifbox_layout:reset(notifbox_layout)
    remove_notibox_empty = false
  end

  -- Throw data from naughty to notifbox_layout 
  -- Generates notifbox
  if n.icon then
    notifbox_layout:insert(1, notifbox_box(n.icon, n.title, n.message, n))
  else
    notifbox_layout:insert(1, notifbox_box(PATH_TO_ICONS .. 'new-notif.svg', n.title, n.message, n))
  end
end)


return notifbox_layout