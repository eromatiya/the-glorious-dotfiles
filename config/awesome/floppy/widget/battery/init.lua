-------------------------------------------------
-- Battery Widget for Awesome Window Manager
-- Shows the battery status using the ACPI tool
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/battery-widget

-- @author Pavel Makhov
-- @copyright 2017 Pavel Makhov
-------------------------------------------------

local awful = require('awful')
local naughty = require('naughty')
local watch = require('awful.widget.watch')
local wibox = require('wibox')
local clickable_container = require('widget.material.clickable-container')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi

-- acpi sample outputs
-- Battery 0: Discharging, 75%, 01:51:38 remaining
-- Battery 0: Charging, 53%, 00:57:43 until charged

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/battery/icons/'

local widget =
  wibox.widget {
  {
    id = 'icon',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.fixed.horizontal
}

local widget_button = clickable_container(wibox.container.margin(widget, dpi(14), dpi(14), 7, 7)) -- default top bottom margin is 7
widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn('xfce4-power-manager-settings')
      end
    )
  )
)
-- Alternative to naughty.notify - tooltip. You can compare both and choose the preferred one
local battery_popup =
  awful.tooltip(
  {
    objects = {widget_button},
    mode = 'outside',
    align = 'left',
    preferred_positions = {'right', 'left', 'top', 'bottom'}
  }
)

-- To use colors from beautiful theme put
-- following lines in rc.lua before require("battery"):
--beautiful.tooltip_fg = beautiful.fg_normal
--beautiful.tooltip_bg = beautiful.bg_normal

local function show_battery_warning()
  naughty.notify {
    icon = PATH_TO_ICONS .. 'battery-alert.svg',
    icon_size = dpi(48),
    text = 'Huston, we have a problem',
    title = 'Battery is dying',
    timeout = 5,
    hover_timeout = 0.5,
    position = 'top_right',
    bg = '#d32f2f',
    fg = '#EEE9EF',
    width = 248
  }
end

local last_battery_check = os.time()

watch(
  'acpi -i',
  1,
  function(_, stdout)
    local batteryIconName = 'battery'

    local battery_info = {}
    local capacities = {}
    for s in stdout:gmatch('[^\r\n]+') do
      local status, charge_str, time = string.match(s, '.+: (%a+), (%d?%d?%d)%%,?.*')
      if status ~= nil then
        table.insert(battery_info, {status = status, charge = tonumber(charge_str)})
      else
        local cap_str = string.match(s, '.+:.+last full capacity (%d+)')
        table.insert(capacities, tonumber(cap_str))
      end
    end

    local capacity = 0
    for _, cap in ipairs(capacities) do
      capacity = capacity + cap
    end

    local charge = 0
    local status
    for i, batt in ipairs(battery_info) do
      if batt.charge >= charge then
        status = batt.status -- use most charged battery status
      -- this is arbitrary, and maybe another metric should be used
      end

      charge = charge + batt.charge * capacities[i]
    end
    charge = charge / capacity

    if (charge >= 0 and charge < 15) then
      if status ~= 'Charging' and os.difftime(os.time(), last_battery_check) > 300 then
        -- if 5 minutes have elapsed since the last warning
        last_battery_check = _G.time()

        show_battery_warning()
      end
    end

    if status == 'Charging' or status == 'Full' then
      batteryIconName = batteryIconName .. '-charging'
    end

    local roundedCharge = math.floor(charge / 10) * 10
    if (roundedCharge == 0) then
      batteryIconName = batteryIconName .. '-outline'
    elseif (roundedCharge ~= 100) then
      batteryIconName = batteryIconName .. '-' .. roundedCharge
    end

    widget.icon:set_image(PATH_TO_ICONS .. batteryIconName .. '.svg')
    -- Update popup text
    battery_popup.text = string.gsub(stdout, '\n$', '')
    collectgarbage('collect')
  end,
  widget
)

return widget_button
