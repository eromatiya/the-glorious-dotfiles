local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local TaskList = require('widget.task-list')
local gears = require('gears')
local clickable_container = require('widget.material.clickable-container')
local mat_icon_button = require('widget.material.icon-button')
local mat_icon = require('widget.material.icon')
local TagList = require('widget.tag-list')
local mat_list_item = require('widget.material.list-item')

local dpi = require('beautiful').xresources.apply_dpi

local icons = require('theme.icons')

-- Create to each screen
screen.connect_signal("request::desktop_decoration", function(s)
  s.systray = wibox.widget.systray()
  s.systray.visible = false
  s.systray:set_horizontal(true)
  s.systray:set_base_size(28)
  s.systray.opacity = 0.3
  beautiful.systray_icon_spacing = 16
end)


local BotPanel = function(s, offset)
  panel_height = dpi(42)
  panel_width = dpi(764)
  panel_padding = dpi(10)
  local offsetx = 0
  if offset == true then
    offsety = dpi(42)
  end
  local panel =
    wibox
    {
      ontop = true,
      screen = s,
      type = 'dock',
      height = panel_height,
      width = panel_width,
      x = (s.geometry.width / 2) - (panel_width / 2),
      y = s.geometry.height - offsety - (panel_padding / 2),
      stretch = false,
      bg = '00000000',--beautiful.background.hue_800,
      struts = {
        bottom = panel_height + panel_padding / 2
      }
    }


  panel:struts(
    {
      bottom = panel_height + panel_padding / 2
    }
  )


  local hSeparator = wibox.widget {
    orientation = 'vertical',
    forced_width = 16,
    opacity = 0.50,
    span_ratio = 0.7,
    widget = wibox.widget.separator
  }

  panel:setup {
    {
      expand = "none",
      layout = wibox.layout.fixed.horizontal,
      {
        layout = wibox.layout.fixed.horizontal,
        require('widget.search'),
        require('widget.music'),
        hSeparator,
        -- Create a taglist widget
        TagList(s),
      },
      require("widget.xdg-folders"),
    },
    -- The real background color
    bg = beautiful.background.hue_800,
    -- The real, anti-aliased shape
    shape = function(cr, width, height)
      gears.shape.partially_rounded_rect( cr, width, height, true, true, true, true, 12) end,
    widget = wibox.container.background()
  }

  return panel

end

return BotPanel
