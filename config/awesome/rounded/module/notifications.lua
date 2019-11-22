local naughty = require('naughty')
local beautiful = require('beautiful')
local gears = require('gears')
local wibox = require('wibox')
local icons = require('theme.icons')
local awful = require('awful')
local dpi = require('beautiful').xresources.apply_dpi

-- Defaults
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(32)
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 5
naughty.config.defaults.shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(6)) end
naughty.config.defaults.title = 'System Notification'

-- -- Apply theme variables
naughty.config.padding = 8
naughty.config.spacing = 8
naughty.config.defaults.margin = dpi(16)
naughty.config.defaults.border_width = 0
naughty.config.defaults.position = 'top_right'

-- Timeouts
naughty.config.presets.low.timeout = 3
naughty.config.presets.critical.timeout = 0

naughty.config.presets.normal = {
  font         = 'SFNS Display 10',
  fg           = beautiful.fg_normal,
  bg           = beautiful.background.hue_800,
  border_width = 0,
  margin       = dpi(16),
  position     = 'top_right'
}

naughty.config.presets.low = {
  font         = 'SFNS Display 10',
  fg           = beautiful.fg_normal,
  bg           = beautiful.background.hue_800,
  border_width = 0,
  margin       = dpi(16),
  position     = 'top_right'
}

naughty.config.presets.critical = {
  font         = 'SFNS Display Bold 10',
  fg           = '#ffffff',
  bg           = '#ff0000',
  border_width = 0,
  margin       = dpi(16),
  position     = 'top_right',
  timeout      = 0
}


naughty.config.presets.ok = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical


-- Error handling
if _G.awesome.startup_errors then
  naughty.notify(
    {
      preset = naughty.config.presets.critical,
      title = 'Oops, there were errors during startup!',
      text = _G.awesome.startup_errors
    }
  )
end

do
  local in_error = false
  _G.awesome.connect_signal(
    'debug::error',
    function(err)
      if in_error then
        return
      end
      in_error = true

      naughty.notify(
        {
          preset = naughty.config.presets.critical,
          title = 'Oops, an error happened!',
          text = tostring(err)
        }
      )
      in_error = false
    end
  )
end

function log_this(title, txt)
  naughty.notify(
    {
      title = 'log: ' .. title,
      text = txt
    }
  )
end




-- Notification template
-- Comment this up to bottom to use default template
-- ===================================================================
-- Fake background, the real bg is in the template
beautiful.notification_bg = "#00000000"
local notification_bg = beautiful.notification_bg
-- margin
beautiful.notification_margin = dpi(5)
naughty.connect_signal("request::display", function(n)

  naughty.layout.box {
    notification = n,
    type = "splash",
    shape = gears.shape.rectangle,
    widget_template = {
      {
        {
          {
            {
              {
                {
                  {
                    {
                      -- TITLE
                      {
                        {
                          {
                            align = "center",
                            widget = naughty.widget.title,
                          },
                          margins = dpi(5),--beautiful.notification_margin,
                          widget  = wibox.container.margin,
                        },
                        -- BG of Titlebar
                        bg = '#000000'.. '44',
                        widget  = wibox.container.background,
                      },
                      -- ICON And Message
                      {
                        {
                          {
                            resize_strategy = 'center',
                            widget = naughty.widget.icon,
                          },
                          margins = dpi(5),
                          widget  = wibox.container.margin,
                        },
                        {
                          {
                            align = "center",
                            widget = naughty.widget.message,
                          },
                          margins = beautiful.notification_margin,
                          widget  = wibox.container.margin,
                         },
                         layout = wibox.layout.fixed.horizontal,
                       },
                       fill_space = true,
                       spacing = beautiful.notification_margin,
                       layout  = wibox.layout.fixed.vertical,
                     },
                     -- Margin between the fake background
                     -- Set to 0 to preserve the 'titlebar' effect
                     margins = dpi(0),
                     widget  = wibox.container.margin,
                   },
                   bg = notification_bg,
                   widget  = wibox.container.background,
                 },
                 -- Notification action list
                 naughty.list.actions,
                 spacing = dpi(4),
                 layout  = wibox.layout.fixed.vertical,
               },
               bg     = "#00000000",
               id     = "background_role",
               widget = naughty.container.background,
             },
             strategy = "min",
             width    = dpi(160),
             widget   = wibox.container.constraint,
           },
           strategy = "max",
           width    = beautiful.notification_max_width or dpi(500),
           widget   = wibox.container.constraint,
         },
         -- Anti-aliasing container
         -- Real BG
         bg = beautiful.background.hue_800,
         -- This will be the anti-aliased shape of the notification
         shape = gears.shape.rounded_rect,
         widget = wibox.container.background
       },
       -- Margin of the fake BG to have a space between notification and the screen edge
       margins = dpi(5),--beautiful.notification_margin,
       widget  = wibox.container.margin
     }
   }


   -- Don't Show/Destroy popup notifications if notification panel is visible
   -- And if do not dont_disturb is on
  if _G.panel_visible or _G.dont_disturb then
    naughty.destroy_all_notifications()
  else
    -- if null
  end

end)
