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
local textclock = wibox.widget.textclock('<span font="SFNS Display Regular 12">%l:%M %p</span>')

  -- Clock / Calendar 12AM/PM fornat
  -- local textclock = wibox.widget.textclock('<span font="Roboto Mono bold 11">%I\n%M</span>\n<span font="Roboto Mono bold 9">%p</span>')
  -- textclock.forced_height = 56
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
  gears.shape.rounded_rect(
    cr,
    width,
    height,
    12)
end

-- Calendar Widget
local month_calendar = awful.widget.calendar_popup.month({
	start_sunday = true,
	spacing = 10,
	font = 'SFNS Display 10',
	long_weekdays = true,
	margin = 9, -- 10
	style_month = { border_width = 0, padding = 12, shape = cal_shape, padding = 25},
	style_header = { border_width = 0, bg_color = '#00000000'},
	style_weekday = { border_width = 0, bg_color = '#00000000' },
	style_normal = { border_width = 0, bg_color = '#00000000'},
	style_focus = { border_width = 0, bg_color = beautiful.primary.hue_500 },

	})
	month_calendar:attach( clock_widget, "bc" , { on_pressed = true, on_hover = false })


awful.screen.connect_for_each_screen(function(s)
  s.systray = wibox.widget.systray()
  s.systray.visible = false
  s.systray:set_horizontal(true)
  s.systray:set_base_size(28)
  beautiful.systray_icon_spacing = 24
  s.systray.opacity = 0.3
end)

--[[
-- Systray Widget
local systray = wibox.widget.systray()
	systray:set_horizontal(true)
	systray:set_base_size(28)
	beautiful.systray_icon_spacing = 24
	opacity = 0
]]--

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
  local padding = dpi(10)
  if offset == true then
    offsety = dpi(42) -- 48
  end
  local panel =
    wibox(
    {
      ontop = true,
      screen = s,
      height = dpi(42), -- 48
      width = s.geometry.width - padding,
      x = s.geometry.x + (padding / 2),
      y = s.geometry.height - offsety - (padding / 2),
      stretch = false,
      shape = function(cr, width, height)
        gears.shape.rounded_rect(
          cr,
          width,
          height,
          12)
        end,
      bg = beautiful.background.hue_800,
      fg = beautiful.fg_normal,
      struts = {
        bottom = dpi(42) + padding-- 48
      }
    }
  )

  panel:struts(
    {
      bottom = dpi(42) + dpi(5)-- 48
    }
  )

-- Generate widget with background
local function genWidget(widget)
return wibox.widget {
  wibox.widget {
    widget,
    bg = '#ffffff20',
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
    margins = 6,
    widget = wibox.container.margin,
}

end

  panel:setup {
	expand = "none",
    layout = wibox.layout.align.horizontal,
    {
      layout = wibox.layout.fixed.horizontal,
      -- Create a taglist widget
      require('widget.search'),
      require('widget.music'),
      hSeparator,
      TagList(s),
      -- TaskList(s),
      -- add_button
    },
	  -- Create a clock widget
	  -- Clock

    wibox.container.margin(clock_widget, dpi(10), dpi(10)),
    -- nil,
    {
      layout = wibox.layout.fixed.horizontal,
      wibox.container.margin(s.systray, dpi(10), dpi(10), dpi(10), dpi(10)),
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

    }
  }

  return panel
end

return BotPanel
