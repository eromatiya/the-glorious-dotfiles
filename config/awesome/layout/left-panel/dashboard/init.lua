local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local mat_list_item = require('widget.material.list-item')
local mat_icon = require('widget.material.icon')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('theme.icons')
local gears = require('gears')

return function(_, panel)
  local search_button =
    wibox.widget {
    wibox.widget {
      icon = icons.search,
      size = dpi(24),
      widget = mat_icon
    },
    wibox.widget {
      text = 'Search Applications',
      font = 'SFNS Display Regular 12',
      widget = wibox.widget.textbox,
      align = center
    },
    forced_height = dpi(12),
    clickable = true,
    widget = mat_list_item
  }

  search_button:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          panel:run_rofi()
        end
      )
    )
  )

  local exit_button =
    wibox.widget {
    wibox.widget {
      icon = icons.logout,
      size = dpi(24),
      widget = mat_icon
    },
    wibox.widget {
      text = 'End work session',
      font = 'SFNS Display Regular 12',
      widget = wibox.widget.textbox
    },
    clickable = true,
    divider = false,
    widget = mat_list_item
  }

  exit_button:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          panel:toggle()
          _G.exit_screen_show()
        end
      )
    )
  )


  local quickSearchSeparator = wibox.widget {
    orientation = 'vertical',
    forced_height = 10,
    opacity = 0.00,
    widget = wibox.widget.separator
  }

  local topBotSeparator = wibox.widget {
    orientation = 'horizontal',
    forced_height = 15,
    opacity = 0,
    widget = wibox.widget.separator,
  }

  return wibox.widget {
    layout = wibox.layout.align.vertical,
    {
      topBotSeparator,
      layout = wibox.layout.fixed.vertical,
      {
        wibox.widget {
          search_button,
          bg = '#ffffff20',     --beautiful.background.hue_800,
          shape = function(cr, w, h)
                    gears.shape.rounded_rect(cr, w, h, 28)
                  end,
          widget = wibox.container.background,
        },
        widget = mat_list_item,
      },
      quickSearchSeparator,
      require('layout.left-panel.dashboard.quick-settings'),
      require('layout.left-panel.dashboard.hardware-monitor'),
      require('layout.left-panel.dashboard.action-center'),
    },
    nil,
    {

      layout = wibox.layout.fixed.vertical,
      wibox.widget{
        wibox.widget{
          exit_button,
          bg = '#ffffff20',--beautiful.background.hue_800,
          widget = wibox.container.background,
          shape = function(cr, w, h)
                    gears.shape.rounded_rect(cr, w, h, 12)
                  end,
        },
        widget = mat_list_item,
      },
      topBotSeparator
    }
  }
end
