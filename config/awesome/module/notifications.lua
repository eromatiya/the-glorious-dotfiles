local naughty = require('naughty')
local beautiful = require('beautiful')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('theme.icons')

-- Defaults
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(32)
naughty.config.defaults.screen = 1
naughty.config.defaults.timeout = 5
naughty.config.defaults.shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(6)) end
naughty.config.defaults.title = 'System Notification'

-- -- Apply theme variables
naughty.config.padding = 8
naughty.config.spacing = 8
naughty.config.defaults.margin = dpi(16)
naughty.config.defaults.border_width = 0

-- Timeouts
naughty.config.presets.low.timeout = 3
naughty.config.presets.critical.timeout = 0

naughty.config.presets.normal = {
  font         = 'SFNS Display 10',
  fg           = beautiful.fg_normal,
  bg           = beautiful.background.hue_800,
  border_width = 0,
  margin       = dpi(16),
  position     = 'top_right'
}

naughty.config.presets.low = {
  font         = 'SFNS Display 10',
  fg           = beautiful.fg_normal,
  bg           = beautiful.background.hue_800,
  border_width = 0,
  margin       = dpi(16),
  position     = 'top_right'
}

naughty.config.presets.critical = {
  font         = 'SFNS Display Bold 10',
  fg           = '#ffffff',
  bg           = '#ff0000',
  border_width = 0,
  margin       = dpi(16),
  position     = 'top_right',
  timeout      = 0
}


naughty.config.presets.ok = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical


-- Error handling
if _G.awesome.startup_errors then
  naughty.notify(
    {
      preset = naughty.config.presets.critical,
      title = 'Oops, there were errors during startup!',
      text = _G.awesome.startup_errors
    }
  )
end

do
  local in_error = false
  _G.awesome.connect_signal(
    'debug::error',
    function(err)
      if in_error then
        return
      end
      in_error = true

      naughty.notify(
        {
          preset = naughty.config.presets.critical,
          title = 'Oops, an error happened!',
          text = tostring(err)
        }
      )
      in_error = false
    end
  )
end

function log_this(title, txt)
  naughty.notify(
    {
      title = 'log: ' .. title,
      text = txt
    }
  )
end


-- naughty.disconnect_signal("request::display", naughty.default_notification_handler)

-- Battery notifications
-- ===================================================================

-- Helper variables
local charger_plugged = true
local battery_full_already_notified = true
local battery_low_already_notified = false
local battery_critical_already_notified = false

local last_notification
local function send_notification(title, text, icon, timeout)
    local args = {
        title = title,
        text = text,
        icon = icon,
        timeout = timeout,
    }
    if last_notification and not last_notification.is_expired then
        last_notification.title = args.title
        last_notification.text = args.text
        last_notification.icon = args.icon
    else
        last_notification = naughty.notification(args)
    end

    last_notification = notification
end

-- Full / Low / Critical notifications
awesome.connect_signal("module::battery", function(battery)
    local text
    local icon
    local timeout
    if not charger_plugged then
        icon = icons.battery
        if battery < 6 and not battery_critical_already_notified then
            battery_critical_already_notified = true
            text = "Battery Critical!"
            timeout = 0
        elseif battery < 16 and not battery_low_already_notified then
            battery_low_already_notified = true
            text = "Battery Full!"
            timeout = 6
        end
    else
        icon = icons.battery_charging
        if battery > 99 and not battery_full_already_notified then
            battery_full_already_notified = true
            text = "Battery Full!"
            timeout = 6
        end
    end

    -- If text has been initialized, then we need to send a
    -- notification
    if text then
        send_notification("Battery status", text, icon, timeout)
    end
end)

-- Charger notifications
local charger_first_time = true
awesome.connect_signal("module::charger", function(plugged)
    charger_plugged = plugged
    local text
    local icon
    -- TODO if charger is plugged and battery is full, then set
    -- battery_full_already_notified to true
    if plugged then
        battery_critical_already_notified = false
        battery_low_already_notified = false
        text = "Plugged"
        icon = icons.batt_charging
    else
        battery_full_already_notified = false
        text = "Unplugged"
        icon = icons.batt_discharging
    end

    -- Do not send a notification the first time (when AwesomeWM (re)starts)
    if charger_first_time then
        charger_first_time = false
    else
        send_notification("Charger Status", text, icon, 3)
    end
end)
