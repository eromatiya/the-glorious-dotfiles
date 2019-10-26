local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local apps = require('configuration.apps')
local dpi = require('beautiful').xresources.apply_dpi

local left_panel = function(screen)
  local panel_content_width = dpi(350) -- 400

  local panel =
    wibox {
      ontop = true,
      screen = screen,
      width = dpi(1),
      height = screen.geometry.height,
      x = screen.geometry.width - panel_content_width,
      bg = beautiful.background.hue_800,
      opacity = 0.0,
      -- bg = '#ff00ff'
    }

  panel.opened = false

  local backdrop =
    wibox {
    ontop = true,
    screen = screen,
    bg = '#00000000',
    type = 'dock',
    x = screen.geometry.x,
    y = screen.geometry.y,
    width = screen.geometry.width,
    height = screen.geometry.height
  }

  function panel:run_rofi()
    _G.awesome.spawn(
      apps.default.rofi,
      false,
      false,
      false,
      false,
      function()
        panel:toggle()
      end
    )
  end

  local openPanel = function(should_run_rofi)
    panel.opacity = 1.0
    panel.width = panel_content_width
    backdrop.visible = true
    panel.visible = false
    panel.visible = true
    panel:get_children_by_id('panel_content')[1].visible = true
    if should_run_rofi then
      panel:run_rofi()
    end
    panel:emit_signal('opened')
  end

  local closePanel = function()
    panel.opacity = 0.0
    panel.width = dpi(1)
    panel:get_children_by_id('panel_content')[1].visible = false
    backdrop.visible = false
    panel:emit_signal('closed')
  end

  -- Hide this panel when app dashboard is called.
  function panel:HideDashboard()
    closePanel()
  end

  function panel:toggle(should_run_rofi)
    self.opened = not self.opened
    if self.opened then
      openPanel(should_run_rofi)
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
          panel:toggle()
        end
      )
    )
  )

  panel:setup {
    expand = 'none',
    layout = wibox.layout.align.horizontal,
     nil,
    {
      id = 'panel_content',
      ontop = true,
      bg = beautiful.background.hue_800 .. '66', -- Background color of Dashboard
      widget = wibox.container.background,
      visible = false,
      forced_width = panel_content_width,
      {
        require('layout.left-panel.dashboard')(screen, panel),
        layout = wibox.layout.stack
      }
    },
    nil,
  }
  return panel
end

return left_panel
