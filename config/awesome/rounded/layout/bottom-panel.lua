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
  gears.shape.rounded_rect( cr, width, height, beautiful.modal_radius)
end

-- Calendar Widget
local month_calendar = awful.widget.calendar_popup.month({
	start_sunday = true,
	spacing = 10,
	font = 'SFNS Display 10',
	long_weekdays = true,
	margin = 6, -- 10
	style_month = { border_width = 0, padding = 12, shape = cal_shape, padding = 25},
	style_header = { border_width = 0, bg_color = '#00000000'},
	style_weekday = { border_width = 0, bg_color = '#00000000' },
	style_normal = { border_width = 0, bg_color = '#00000000'},
	style_focus = { border_width = 0, bg_color = beautiful.primary.hue_500 },
})
-- Attach calentar to clock_widget
month_calendar:attach(clock_widget, "bc" , { on_pressed = true, on_hover = false })

-- Create to each screen
screen.connect_signal("request::desktop_decoration", function(s)
  s.systray = wibox.widget.systray()
  s.systray.visible = false
  s.systray:set_horizontal(true)
  s.systray:set_base_size(28)
  s.systray.opacity = 0.3
  beautiful.systray_icon_spacing = 16
end)


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
    wibox
    {
      ontop = true,
      screen = s,
      type = 'dock',
      height = panel_height,
      width = s.geometry.width - panel_padding,
      x = s.geometry.x + (panel_padding / 2),
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
      {
        widget,
        bg = '#ffffff20',
        shape = function(cr, width, height)
          gears.shape.partially_rounded_rect( cr, width, height, true, true, true, true, 10) end,
        widget = wibox.container.background,
      },
        margins = 6,
        widget = wibox.container.margin,
      }
  end

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
      layout = wibox.layout.align.horizontal,
      {
        layout = wibox.layout.fixed.horizontal,
        require('widget.search'),
        require('widget.music'),
        require('widget.mini-settings'),
        hSeparator,
        -- Create a taglist widget
        TagList(s),
      },
  	  -- Clock
  	  clock_widget,
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
        decorateWidget(require('widget.right-dashboard')),
        decorateWidget(LayoutBox(s)),
      },
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
