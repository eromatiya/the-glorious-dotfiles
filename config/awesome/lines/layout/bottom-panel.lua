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
local apps = require('configuration.apps')

local dpi = require('beautiful').xresources.apply_dpi

local icons = require('theme.icons')

  -- Clock / Calendar 12h format
  -- Check Date/Time formats in 'man strftime'
local textclock = wibox.widget.textclock('<span font="SFNS Display Regular 12">%l:%M %p</span>')

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
    margin_topbottom = dpi(8),
    delay_show = 1
  }
)

local cal_shape = function(cr, width, height)
  gears.shape.partially_rounded_rect(
    cr,
    width,
    height,
    true,
    true,
    false,
    false,
    12)
end

-- Calendar Widget
local month_calendar = awful.widget.calendar_popup.month({
	start_sunday = true,
	spacing = 10,
	font = 'SFNS Display 10',
	long_weekdays = true,
	margin = 0, -- 10
	style_month = { border_width = 0, padding = 12, shape = cal_shape, padding = 25},
	style_header = { border_width = 0, bg_color = '#00000000'},
	style_weekday = { border_width = 0, bg_color = '#00000000' },
	style_normal = { border_width = 0, bg_color = '#00000000'},
	style_focus = { border_width = 0, bg_color = beautiful.primary.hue_500 },

	})
	month_calendar:attach( clock_widget, "br" , { on_pressed = true, on_hover = false })

  local searchButton =
    wibox.widget {
    {
      id = 'icon',
      widget = wibox.widget.imagebox,
      resize = true
    },
    layout = wibox.layout.align.horizontal
  }

  local search_button = clickable_container(wibox.container.margin(searchButton, dpi(11), dpi(11), dpi(11), dpi(11))) -- 4 is top and bottom margin
  search_button:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        nil,
        function()
          _G.awesome.spawn(apps.default.rofi)
        end
      )
    )
  )

  searchButton.icon:set_image(icons.search)

screen.connect_signal("request::desktop_decoration", function(s)
  s.systray = wibox.widget.systray()
  s.systray.visible = false
  s.systray:set_horizontal(true)
  s.systray:set_base_size(28)
  beautiful.systray_icon_spacing = 0
  s.systray.opacity = 0.3
end)

-- Execute if button is system tray widget is not loaded
awesome.connect_signal("toggle_tray", function()
  if not require('widget.systemtray') then
    if awful.screen.focused().systray.visible ~= true then
      awful.screen.focused().systray.visible = true
    else
      awful.screen.focused().systray.visible = false
    end
  end
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

local hSeparator = wibox.widget {
        orientation = 'vertical',
        forced_width = 16,
        opacity = 0.50,
        span_ratio = 0.7,
        widget = wibox.widget.separator
}

local BotPanel = function(s, offset)
  local offsetx = 0
  local panel =
    awful.wibar(
    {
      ontop = true,
      position = 'bottom',
      screen = s,
      visible = true,
      type = 'normal',
      height = dpi(42),
      width = s.geometry.width,
      stretch = false,
      -- Set transparent bg
      bg = '#00000000',
      struts = {
        bottom = dpi(42)
      }
    }
  )

  panel:struts(
    {
      bottom = dpi(42)
    }
  )

-- Generate widget with background
local function genWidget(widget)
return wibox.widget {
  wibox.widget {
    widget,
    border_width = dpi(1),
    border_color = '#ffffff40',
    shape = function(cr, width, height)
              gears.shape.partially_rounded_rect(
                cr,
                width,
                height,
                true,
                true,
                true,
                true,
                10)
            end,
    widget = wibox.container.background,
    },
    margins = 4,
    widget = wibox.container.margin,
}
end

local function genTasklist(widget)
return wibox.widget {
  wibox.widget {
    widget,
    border_width = dpi(1),
    border_color = '#ffffff40',
    shape = function(cr, width, height)
              gears.shape.rounded_rect(
                cr,
                width,
                height,
                4)
            end,
    widget = wibox.container.background,
    },
    margins = 3,
    widget = wibox.container.margin,
}
end

  panel:setup {
    {
      expand = "none",
      layout = wibox.layout.align.horizontal,
      {
        genWidget(require('widget.search')),
        genWidget(require('widget.music')),
        genWidget(require('widget.mini-settings')),
        genWidget(search_button),
        hSeparator,
        genTasklist(TagList(s)),
        genTasklist(TaskList(s)),
        add_button,
        layout = wibox.layout.fixed.horizontal,

      },
      -- Middle Widget
      nil,
      {
        hSeparator,
        layout = wibox.layout.fixed.horizontal,
        wibox.container.margin(s.systray, dpi(0), dpi(0), dpi(10), dpi(10)),
        {
          layout = wibox.layout.fixed.horizontal,
          genWidget(require('widget.systemtray')),
          genWidget(require('widget.package-updater')),
          genWidget(require('widget.bluetooth')),
          genWidget(require('widget.wifi')),
          genWidget(require('widget.battery')),
        },
        hSeparator,
        genWidget(require('widget.dashboard')),
        genWidget(LayoutBox(s)),
        genWidget(wibox.container.margin(clock_widget, dpi(10), dpi(10))),
      },
    },
    -- The real background color
    bg = beautiful.background.hue_800,
    widget = wibox.container.background()
  }

  return panel
end

return BotPanel
