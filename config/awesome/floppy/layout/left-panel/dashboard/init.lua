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
      text = 'Web Search',
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


  local topbot_separator = wibox.widget {
    orientation = 'horizontal',
    forced_height = 15,
    opacity = 0,
    widget = wibox.widget.separator,
  }

  return wibox.widget {
    layout = wibox.layout.align.vertical,
    {
      layout = wibox.layout.fixed.vertical,
      topbot_separator,
      {
        spacing = dpi(10),
        layout = wibox.layout.fixed.vertical,
        {
          {
            search_button,
            bg = beautiful.bg_modal, 
            shape = function(cr, w, h)
                      gears.shape.rounded_rect(cr, w, h, beautiful.modal_radius)
                    end,
            widget = wibox.container.background,
          },
          widget = mat_list_item,
        },
        require('layout.left-panel.dashboard.quick-settings'),
        require('layout.left-panel.dashboard.hardware-monitor'),
        require('layout.left-panel.dashboard.action-center'),
      },
    },
    nil,
    {

      layout = wibox.layout.fixed.vertical,
      {
        {
          exit_button,
          bg = beautiful.bg_modal,
          widget = wibox.container.background,
          shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, beautiful.modal_radius) end,
        },
        widget = mat_list_item,
      },
      topbot_separator
    }
  }
end
