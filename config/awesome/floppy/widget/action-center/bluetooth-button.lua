local awful = require('awful')
local naughty = require('naughty')
local wibox = require('wibox')
local clickable_container = require('widget.action-center.clickable-container')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local watch = require('awful.widget.watch')
local mat_list_item = require('widget.material.list-item')

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/action-center/icons/'
local checker
local mode


local widget =
  wibox.widget {
  {
    id = 'icon',
    image = PATH_TO_ICONS .. 'toggled-off' .. '.svg',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

local function update_icon()
  local widgetIconName
  if(mode == true) then
    widgetIconName = 'toggled-on'
    widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. '.svg')
  else
    widgetIconName = 'toggled-off'
    widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. '.svg')
  end
end

local function check_bluetooth()
  awful.spawn.easy_async_with_shell('rfkill list bluetooth', function( stdout )
    checker = stdout:match('Soft blocked: yes')
    if(checker ~= nil) then
      mode = false
    else
      mode = true
    end
    
    -- Update icon
    update_icon()
  end)

end


local poweroff = [[

echo 'power off' | bluetoothctl
rfkill block bluetooth
notify-send 'Bluetooth device disabled'

]]

local poweron = [[

rfkill unblock bluetooth
echo 'power on' | bluetoothctl 
notify-send 'Initializing bluetooth Service...'

]]

local function toggle_bluetooth()
  if(mode == true) then
    awful.spawn.easy_async_with_shell(poweroff, function( stdout ) end, false)
    mode = false
  else
    awful.spawn.easy_async_with_shell(poweron, function( stdout ) end, false)
    mode = true
  end

  -- Update icon
  update_icon()
end


-- Check bluetooth status
check_bluetooth()


local bluetooth_button = clickable_container(wibox.container.margin(widget, dpi(7), dpi(7), dpi(7), dpi(7)))
bluetooth_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        toggle_bluetooth()
      end
    )
  )
)

-- Alternative to naughty.notify - tooltip. You can compare both and choose the preferred one
awful.tooltip(
  {
    objects = {bluetooth_button},
    mode = 'outside',
    align = 'right',
    timer_function = function()
      if checker == nil then
        return 'Bluetooth Enabled'
      else
        return 'Bluetooth Disabled'
      end
    end,
    preferred_positions = {'right', 'left', 'top', 'bottom'}
  }
)

local last_bluetooth_check = os.time()
watch(
  'rfkill list bluetooth',
  5,
  function(_, stdout)
   -- Check if there  bluetooth
    checker = stdout:match('Soft blocked: yes')
    local widgetIconName
    if (checker == nil) then
      widgetIconName = 'toggled-on'
    else
      widgetIconName = 'toggled-off'
    end
    widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. '.svg')
    collectgarbage('collect')
  end,
  widget
)

local settingsName = wibox.widget {
  text = 'Bluetooth Connection',
  font = 'SFNS Display 11',
  align = 'left',
  widget = wibox.widget.textbox
}

local content = wibox.widget {
  {
    settingsName,
    layout = wibox.layout.fixed.horizontal,
  },
  nil,
  {
    bluetooth_button,
    layout = wibox.layout.fixed.horizontal,
  },
  layout = wibox.layout.align.horizontal,
}

local bluetoothButton =  wibox.widget {
  wibox.widget {
    content,
    widget = mat_list_item
  },
  layout = wibox.layout.fixed.vertical
}
return bluetoothButton
