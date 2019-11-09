local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local mat_list_item = require('widget.material.list-item')
local mat_list_sep = require('widget.material.list-item-separator')



local barColor = beautiful.bg_modal

local hardwareTitle = wibox.widget
{
  text = 'Hardware monitor',
  font = 'SFNS Display 12',
  align = 'center',
  widget = wibox.widget.textbox

}


-- local wrapped_mini_line = wibox.widget {
--   wibox.widget {
--     wibox.widget {
--       orientation = 'horizontal',
--       forced_height = 1,
--       span_ratio = 0.90,
--       opacity = 0.90,
--       color = beautiful.bg_modal,
--       widget = wibox.widget.separator
--     },
--     bg = barColor,
--     shape = function(cr, width, height)
--       gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, 6) end,
--       widget = wibox.container.background
--     },
--     widget = mat_list_sep,
--   }

-- local wrapped_line = wibox.widget
-- {
--   wibox.widget{
--      wibox.widget {
--       orientation = 'horizontal',
--       forced_height = 1,
--       span_ratio = 1.0,
--       opacity = 0.90,
--       color = 'beautiful.bg_modal',
--       widget = wibox.widget.separator
--     },
--     bg = barColor,
--     widget = wibox.container.background
--   },
--   widget = mat_list_sep,
-- }

return wibox.widget {
  layout = wibox.layout.fixed.vertical,
  wibox.widget {
    wibox.widget {
      hardwareTitle,
      bg = beautiful.bg_modal_title,
      shape = function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, 6) end,
      widget = wibox.container.background,
    },
    widget = mat_list_item,
  },
  wibox.widget{
    wibox.widget{
      require('widget.cpu.cpu-meter'),
      bg = barColor,
      shape = function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, false, false, false, false, 6) end,
      widget = wibox.container.background
    },
    widget = mat_list_item,
  },
  wibox.widget{
    wibox.widget{
      require('widget.ram.ram-meter'),
      bg = barColor,
      shape = function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, false, false, false, false, 6) end,
      widget = wibox.container.background
    },
    widget = mat_list_item,
  },
  layout = wibox.layout.fixed.vertical,
  wibox.widget{
    wibox.widget{
      require('widget.temperature.temperature-meter'),
      bg = barColor,
      shape = function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, false, false, false, false, 6) end,
      widget = wibox.container.background
    },
    widget = mat_list_item,
  },
  wibox.widget{
    wibox.widget{
      require('widget.harddrive.harddrive-meter'),
      bg = barColor,
      shape = function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, 6) end,
      widget = wibox.container.background
    },
    widget = mat_list_item,
  },
}
