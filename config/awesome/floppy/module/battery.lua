-- Dependencies:
-- acpid, upower, acpi_listens
local awful = require("awful")

local update_interval = 30

local battery_script = [[
  sh -c "
  upower -i $(upower -e | grep BAT) | grep percentage | awk '{print $2}'
  "]]

-- Subscribe to power supply status changes with acpi_listen
local charger_script = [[
    sh -c '
    acpi_listen | grep --line-buffered ac_adapter
']]

-- Periodically get battery info
awful.widget.watch(battery_script, update_interval, function(widget, stdout)
    local battery = stdout:gsub("%%", "")
    awesome.emit_signal("module::battery", tonumber(battery))
end)

local emit_charger_info = function()
    awful.spawn.easy_async_with_shell("cat /sys/class/power_supply/*/online", function (out)
        status = tonumber(out)
        if status == 1 then
            awesome.emit_signal("module::charger", true)
        else
            awesome.emit_signal("module::charger", false)
        end
    end)
end

-- Run once to initialize widgets
emit_charger_info()

-- Kill old acpi_listen process
awful.spawn.easy_async_with_shell("ps x | grep \"acpi_listen\" | grep -v grep | awk '{print $1}' | xargs kill", function ()
    -- Update charger status with each line printed
    awful.spawn.with_line_callback(charger_script, {
        stdout = function(_)
            emit_charger_info()
        end
    })

end)






-- naughty.disconnect_signal("request::display", naughty.default_notification_handler)
-- Install acpi_call and acpid and enable its service
-- Battery notifications
-- ===================================================================
local icons = require('theme.icons')
local naughty = require('naughty')
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
        if battery ~= nil then
          if battery > 99 and not battery_full_already_notified then
              battery_full_already_notified = true
              text = "Battery Full!"
              timeout = 6
          end
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

