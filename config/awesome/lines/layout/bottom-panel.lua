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

-- Clock / Calendar 12h format
-- Get Time/Date format using `man strftime`
local textclock = wibox.widget.textclock('<span font="SFNS Display Regular 12">%l:%M %p</span>')

-- Clock / Calendar 12AM/PM fornatan font="Roboto Mono bold 11">%I\n%M</span>\n<span font="Roboto Mono bold 9">%p</span>')
local clock_widget = wibox.container.margin(textclock, dpi(0), dpi(0))

-- Alternative to naughty.notify - tooltip. You can compare both and choose the preferred one
awful.tooltip(
  {
    objects = {clock_widget},
    mode = 'outside',
    align = 'right',
    timer_function = function()
    return os.date("The date today is %B %d, %Y. And it's fucking %A!")
  end,
  preferred_positions = {'right', 'left', 'top', 'bottom'},
  margin_leftright = dpi(8),
  margin_topbottom = dpi(8)
  }
)


local cal_shape = function(cr, width, height)
  gears.shape.partially_rounded_rect( cr, width, height, true, true, false, false, beautiful.corner_radius)
end

-- Calendar Widget
local month_calendar = awful.widget.calendar_popup.month({
	start_sunday = true,
	spacing = 10,
	font = 'SFNS Display 10',
	long_weekdays = true,
	margin = 0, -- 10
	style_month = { border_width = 1, padding = 12, shape = cal_shape, padding = 25},
	style_header = { border_width = 1, bg_color = '#00000000', border_color = '#ffffff40', shape = gears.shape.rounded_rect},
	style_weekday = { border_width = 1, bg_color = '#00000000', border_color = '#ffffff40', shape = gears.shape.rounded_rect },
	style_normal = { border_width = 1, bg_color = '#00000000', border_color = '#ffffff40', shape = gears.shape.rounded_rect},
	style_focus = { border_width = 1, bg_color = '#8ab4f8', border_color = '#ffffff40', shape = gears.shape.rounded_rect},
})
-- Attach calentar to clock_widget
month_calendar:attach(clock_widget, "br" , { on_pressed = true, on_hover = false })

-- Create to each screen
screen.connect_signal("request::desktop_decoration", function(s)
  s.systray = wibox.widget.systray()
  s.systray.visible = false
  s.systray:set_horizontal(true)
  s.systray:set_base_size(28)
  s.systray.opacity = 0.3
  beautiful.systray_icon_spacing = 16
end)


local add_button = mat_icon_button(mat_icon(icons.plus, dpi(16))) -- add button -- 24
add_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn(
          awful.screen.focused().selected_tag.defaultApp,
          {
            tag = _G.mouse.screen.selected_tag,
            placement = awful.placement.bottom_right
          }
          )
      end
      )
    )
  )
-- Execute only if system tray widget is not loaded
awesome.connect_signal("toggle_tray", function()
  if not require('widget.systemtray') then
    if awful.screen.focused().systray.visible ~= true then
      awful.screen.focused().systray.visible = true
    else
      awful.screen.focused().systray.visible = false
    end
  end
end)

local BotPanel = function(s, offset)
  panel_height = dpi(42)
  panel_padding = dpi(10)
  local offsetx = 0
  if offset == true then
    offsety = dpi(42)
  end
  local panel =
  awful.wibox
  {
    ontop = true,
    screen = s,
    type = 'nornal',
    position = 'bottom',
    height = panel_height,
    width = s.geometry.width,
    stretch = false,
    bg = '00000000',
    struts = {
      bottom = panel_height
    }
  }


  panel:struts(
  {
    bottom = panel_height
  }
  )

  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  local LayoutBox = function(s)
    local layoutBox = clickable_container(awful.widget.layoutbox(s))
    layoutBox:buttons(
      awful.util.table.join(
        awful.button(
          {},
          1,
          function()
            awful.layout.inc(1)
          end
          ),
        awful.button(
          {},
          3,
          function()
            awful.layout.inc(-1)
          end
          ),
        awful.button(
          {},
          4,
          function()
            awful.layout.inc(1)
          end
          ),
        awful.button(
          {},
          5,
          function()
            awful.layout.inc(-1)
          end
          )
        )
      )
    return layoutBox
  end


  -- Generate widget with background
  local function decorateWidget(widget)
    return wibox.widget {
      wibox.widget {
        widget,
        border_width = dpi(1),
        border_color = '#ffffff40',
        shape = function(cr, width, height)
        gears.shape.partially_rounded_rect( cr, width, height, true, true, true, true, 10) end,
        widget = wibox.container.background,
      },
      margins = 4,
      widget = wibox.container.margin,
    }
  end

  local hSeparator = wibox.widget {
    orientation = 'vertical',
    forced_width = 1,
    opacity = 0.50,
    span_ratio = 0.7,
    widget = wibox.widget.separator
  }

  panel:setup {
    {
      expand = "none",
      layout = wibox.layout.align.horizontal,
      {
        layout = wibox.layout.fixed.horizontal,
        decorateWidget(require('widget.search')),
        decorateWidget(require('widget.music')),
        decorateWidget(require('widget.mini-settings')),
        hSeparator,
        -- Create a taglist widget
        decorateWidget(TagList(s)),
        decorateWidget(TaskList(s)),
        add_button,
      },
      -- Clock
      -- clock_widget,
      nil,
      {
        layout = wibox.layout.fixed.horizontal,
        hSeparator,
        wibox.container.margin(s.systray, dpi(0), dpi(0), dpi(10), dpi(10)),
        {
          layout = wibox.layout.fixed.horizontal,
          decorateWidget(require('widget.systemtray')),
          decorateWidget(require('widget.package-updater')),
          decorateWidget(require('widget.bluetooth')),
          decorateWidget(require('widget.wifi')),
          decorateWidget(require('widget.battery')),
        },
        hSeparator,
        decorateWidget(require('widget.notification-center')),
        decorateWidget(LayoutBox(s)),
        decorateWidget(wibox.container.margin(clock_widget, dpi(10), dpi(10))),
      },
    },
    -- The real background color
    border_width = dpi(1),
    border_color = '#ffffff40',
    bg = beautiful.background.hue_900,
    -- The real, anti-aliased shape
    shape = function(cr, width, height)
    gears.shape.partially_rounded_rect( cr, width, height, true, true, true, true, 0) end,
    widget = wibox.container.background()
  }

  return panel
end

return BotPanel
