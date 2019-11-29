local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local mat_list_item = require('widget.material.list-item')
local mat_list_sep = require('widget.material.list-item-separator')



local barColor = beautiful.bg_modal

local hardwareTitle = wibox.widget
{
  text = 'Hardware Monitor',
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
  {
    {
      hardwareTitle,
      bg = beautiful.bg_modal_title,
      shape = function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, beautiful.modal_radius) end,
      widget = wibox.container.background,
    },
    widget = mat_list_item,
  },
  {
    {
      require('widget.cpu.cpu-meter'),
      bg = barColor,
      shape = function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, false, false, false, false, beautiful.modal_radius) end,
      widget = wibox.container.background
    },
    widget = mat_list_item,
  },
  {
    {
      require('widget.ram.ram-meter'),
      bg = barColor,
      shape = function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, false, false, false, false, beautiful.modal_radius) end,
      widget = wibox.container.background
    },
    widget = mat_list_item,
  },
  layout = wibox.layout.fixed.vertical,
  {
    {
      require('widget.temperature.temperature-meter'),
      bg = barColor,
      shape = function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, false, false, false, false, beautiful.modal_radius) end,
      widget = wibox.container.background
    },
    widget = mat_list_item,
  },
  {
    {
      require('widget.harddrive.harddrive-meter'),
      bg = barColor,
      shape = function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, beautiful.modal_radius) end,
      widget = wibox.container.background
    },
    widget = mat_list_item,
  },
}
