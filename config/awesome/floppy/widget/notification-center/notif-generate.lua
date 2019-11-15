-- The one that generates notification in right-panel
--
--

local awful = require('awful')
local naughty = require('naughty')
local watch = require('awful.widget.watch')
local wibox = require('wibox')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi

local beautiful = require('beautiful')

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/notification-center/icons/'
local clickable_container = require('widget.material.clickable-container')

local notif_layout = wibox.layout.fixed.vertical(reverse)
notif_layout.spacing = dpi(5)

local separator = wibox.widget {
  orientation = 'horizontal',
  forced_height = 1,
  span_ratio = 1.0,
  opacity = 0.90,
  color = beautiful.bg_modal,
  widget = wibox.widget.separator
}


local notif_icon = function(ico_image)
  local noti_icon = wibox.widget {
    {
      id = 'icon',
      resize = true,
      forced_height = dpi(45),
      forced_width = dpi(45),
      widget = wibox.widget.imagebox,
    },
    layout = wibox.layout.fixed.horizontal
}
  noti_icon.icon:set_image(ico_image)
  return noti_icon
end

local notif_title = function(title)
  return wibox.widget {
    text   = title,
    font   = 'SFNS Display Bold 12',
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  }
end

local notif_message = function(msg)
  return wibox.widget {
    text   = msg,
    font   = 'SFNS Display Regular 12',
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  }
end

local notif_actions = function(noti)
  return wibox.widget {
    notification = noti,
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
            forced_height      = 30,
            widget             = wibox.container.background,
        },
        margins = 4,
        widget  = wibox.container.margin,
    },
    widget = naughty.list.actions,
}
end




-- Empty content
local empty_title = wibox.widget {
  text = "Spooky...",
  font = 'SFNS Display regular 14',
  align = 'center',
  valign = 'center',
  widget = wibox.widget.textbox
}
local empty_message = wibox.widget {
  text = "There's nothing in here... Come back later.",
  font = 'SFNS Display regular 14',
  align = 'center',
  valign = 'center',
  widget = wibox.widget.textbox
}

  local notif_delete_widget = wibox.widget {
    {
      id = 'icon',
      image = PATH_TO_ICONS .. 'close' .. '.svg',
      resize = true,
      forced_height = dpi(8),
      forced_width = dpi(8),
      widget = wibox.widget.imagebox,
    },
    layout = wibox.layout.fixed.horizontal
  }
  local gen_button = function(widgets)
    return wibox.widget {
      {
        widgets,
        bg = beautiful.bg_modal,
        shape = function(cr, width, height)
         gears.shape.rounded_rect(cr, width, height, 12) end,
        widget = wibox.container.background,
      },
      margins = dpi(5),
      widget = wibox.container.margin,
    }
  end

-- The function that generates notifications in right-panel
local function notif_generate(title, message, icon, noti)

  -- Create Delete button
  local notif_del_button = clickable_container(wibox.container.margin(notif_delete_widget, dpi(5), dpi(5), dpi(5), dpi(5)))

  -- The layout of notification to be generated
  local notif_template =  wibox.widget {
    id = 'notif_template',
    expand = 'none',
    layout = wibox.layout.fixed.vertical,
    {
      {
        expand = 'none',
        layout = wibox.layout.align.horizontal,
          {
            nil,
            layout = wibox.layout.fixed.horizontal,
          },
          {
            wibox.container.margin(notif_title(title), dpi(0), dpi(0), dpi(4), dpi(4)),
            layout = wibox.layout.fixed.horizontal,
          },
          {
            gen_button(notif_del_button),
            layout = wibox.layout.fixed.horizontal,
          },
      },
      bg = beautiful.bg_modal_title,
      shape = function(cr, width, height)
      gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, 6) end,
      widget = wibox.container.background,
    },
    {
      {
        expand = "none",
        layout = wibox.layout.fixed.horizontal,
        {
          wibox.widget {
            notif_icon(icon),
            margins = dpi(4),
            widget = wibox.container.margin
          },
          margins = dpi(5),
          widget = wibox.container.margin
        },
        {
          wibox.widget {
            notif_message(message),
            margins = dpi(4),
            widget = wibox.container.margin
          },
          layout = wibox.layout.flex.horizontal,
        },
      },
      bg = beautiful.bg_modal,
      widget = wibox.container.background
    },
    {
      wibox.widget {
        {
          notif_actions(noti),
          margins = dpi(4),
          widget = wibox.container.margin
        },
        bg = beautiful.bg_modal,
        shape = function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, 6) end,
        widget = wibox.container.background,
      },
      layout = wibox.layout.flex.horizontal,
    },
  }

  -- Delete button function
  notif_del_button:buttons(
      gears.table.join(
        awful.button(
          {},
          1,
          nil,
          function()
            -- Dont let the user make the notification center null
            if #notif_layout.children == 1 then
              notif_layout:reset(notif_layout)
              firstime = true
              notif_layout:insert(1, notif_generate(empty_title.text, empty_message.text, PATH_TO_ICONS .. 'boo' .. '.svg'))
            else
              notif_layout:remove_widgets(notif_template, true)
            end
          end
        )
     )
  )

  --return template to generate
  return notif_template

end


-- add a message to an empty notif center
local function add_empty()
  notif_layout:insert(1, notif_generate(empty_title.text, empty_message.text, PATH_TO_ICONS .. 'boo' .. '.svg'))
end

-- Add empty message on startup
add_empty()

-- Clear all. Will be called in right-panel
function clear_all()
  -- Clear all notification
  notif_layout:reset(notif_layout)
  add_empty()
end

-- useful variable to check the notification's content
firstime = true

-- Check signal
naughty.connect_signal("request::display", function(n)

  if firstime then
    -- Delete empty message if the 1st notif is generated
    notif_layout:remove(1)
    firstime = false
  end

  -- Check and set icon to the notification message in panel
  -- Then generate a widget based on naughty.notify data
  if n.icon == nil then
    -- if naughty sends a signal without an icon then use this instead
    notif_layout:insert(1, notif_generate(n.title, n.message, PATH_TO_ICONS .. 'new-notif' .. '.svg', n))
  else
    -- Use the notification's icon
    notif_layout:insert(1, notif_generate(n.title, n.message, n.icon, n))
  end


end)

-- Return notif_layout to right-panel.lua to display it
return notif_layout
