local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')

local naughty = require('naughty')
local dpi = require('beautiful').xresources.apply_dpi

local clickable_container = require('widget.material.clickable-container')
local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/mini-settings/icons/'

local mat_list_item = require('widget.material.list-item')

local apps = require('configuration.apps')


screen.connect_signal("request::desktop_decoration", function(s)
    -- Create the box
    local padding = dpi(10)
    local panel_height = dpi(336)
    mini_settings = wibox(
      {
        bg = '#00000000',
        visible = false,
        ontop = true,
        type = "dock",
        height = panel_height,
        width = dpi(300),
        x = s.geometry.x,
        y = s.geometry.y + dpi(26),
      }
    )

    backdrop =
    wibox {
      ontop = true,
      visible = false,
      screen = s,
      bg = '#00000000',
      type = 'utility',
      x = s.geometry.x,
      y = s.geometry.y + dpi(26),
      width = s.geometry.width,
      height = dpi(720)
  }

end)

  mini_settings:setup {
    expand = 'none',
    layout = wibox.layout.fixed.vertical,
    {
      id = 'panel_content',
      ontop = true,
      bg = beautiful.background.hue_800 .. '66', -- Background color of Dashboard
      widget = wibox.container.background,
      visible = true,
      position = 'left',
      forced_width = panel_content_width,
      {
        require('layout.settings-content.dashboard')(screen, panel),
        layout = wibox.layout.stack
      },
    bg = beautiful.background.hue_800,
    shape = function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, false, false, true, false, beautiful.corner_radius) end,
    },
  }

  local openPanel = function(should_run_rofi)
    backdrop.visible = true
    mini_settings.visible = true
  end

  local closePanel = function()
    backdrop.visible = false
    mini_settings.visible = false
  end

  function mini_sett_toggle()
    if not mini_settings.visible then
      openPanel()
    else
      closePanel()
    end
  end

  backdrop:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          mini_sett_toggle()
        end
      )
    )
  )


local widget =
  wibox.widget {
  {
    id = 'icon',
    image = PATH_TO_ICONS .. 'settings' .. '.svg',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

local widget_text = wibox.widget {
  {
    text = 'Settings',
    font = 'SFNS Display Bold 10',
    align = 'center',
    vertical = 'center',
    widget = wibox.widget.textbox
  },
  left = dpi(8),
  right = dpi(8),
  widget = wibox.container.margin
}


local widget_button = clickable_container(widget_text)
widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        mini_sett_toggle()
      end
    )
  )
)


return widget_button
