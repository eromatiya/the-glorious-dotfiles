-------------------------------------------------
-- WiFi Widget for Awesome Window Manager
-- Shows the wifi status using some magic
-- Make sure to change the wireless interface
-- See `ifconfig` or `iwconfig`
-------------------------------------------------

local awful = require('awful')
local watch = require('awful.widget.watch')
local wibox = require('wibox')
local gears = require('gears')
local naughty = require('naughty') 

local clickable_container = require('widget.material.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/wifi/icons/'


local interface = 'wlp3s0'
local connected = false
local status = nil
local start_up = true
local essid = 'N/A'
local wifi_strength = 0

local widget =
  wibox.widget {
  {
    id = 'icon',
    image = PATH_TO_ICONS .. 'wifi-strength-off' .. '.svg',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

-- Wicd client
-- local widget_button = clickable_container(wibox.container.margin(widget, dpi(7), dpi(7), dpi(7), dpi(7)))
-- widget_button:buttons(
--   gears.table.join(
--     awful.button(
--       {},
--       1,
--       nil,
--       function()
--         awful.spawn('wicd-client -n')
--       end
--     )
--   )
-- )

-- Network manager
local widget_button = clickable_container(wibox.container.margin(widget, dpi(7), dpi(7), dpi(7), dpi(7)))
widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn('nm-connection-editor')
      end
    )
  )
)

-- Tooltip
awful.tooltip(
  {
    objects = {widget_button},
    mode = 'outside',
    align = 'right',
    timer_function = function()
      if connected then

        return 'Connected to: ' .. essid .. 
          '\nWiFi-strength: ' .. tostring(wifi_strength) .. '%'
      else

        return 'Wireless network is disconnected'
      end
    end,
    preferred_positions = {'right', 'left', 'top', 'bottom'},
    margin_leftright = dpi(8),
    margin_topbottom = dpi(8)
  }
)

-- Get ESSID
local get_essid = function()
  if connected then
    awful.spawn.easy_async(
      'iw dev ' .. interface .. ' link',
      function(stdout)
        essid = stdout:match('SSID:(.-)\n')
        if (essid == nil) then
          essid = 'N/A'
        end
      end
    )
  end
end

-- Notify the change in connection status
local notify_connection = function()

  if status ~= connected then
    status = connected

    if start_up == false then
      if connected == true then
        get_essid()
        naughty.notify({ 
          text = "You're now connected to WiFi:\n" .. essid,
          title = "WiFi Connection",
          app_name = 'System notification',
          icon = PATH_TO_ICONS .. 'wifi.svg'
          })
      else
        naughty.notify({ 
          text = "WiFi Disconnected",
          title = "WiFi Connection",
          app_name = "System Notification",
          icon = PATH_TO_ICONS .. 'wifi-off.svg'
          })
      end
    end
  end 
end


-- Get wifi strenth bash script
local get_wifi_strength = [[
awk 'NR==3 {printf "%3.0f" ,($3/70)*100}' /proc/net/wireless
]]

watch(get_wifi_strength, 5,
  function(_, stdout)
    local widgetIconName = 'wifi-strength'
    wifi_strength = tonumber(stdout)
    if (wifi_strength ~= nil) then
      connected = true
      -- Create a notification
      notify_connection()
      -- Get wifi wifi_strength
      local wifi_strength_rounded = math.floor(wifi_strength / 25 + 0.5)
      widgetIconName = widgetIconName .. '-' .. wifi_strength_rounded
      -- Update wifi strength icon
      widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. '.svg')
    else
      connected = false
      -- Create a notification
      notify_connection()
      -- Update wifi strength to off
      widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. '-off' .. '.svg')
    end

    -- If not connected
    if (connected and (essid == 'N/A' or essid == nil)) then
      get_essid()
    end

    -- Using this as condition for notify_connection()
    -- So we don't have a notification every after startup
    if start_up then
      start_up = false
    end

    -- Cleanup memory
    collectgarbage('collect')
  end
)

-- Tooltip text update
widget:connect_signal(
  'mouse::enter',
  function()
    get_essid()
  end
)

return widget_button
