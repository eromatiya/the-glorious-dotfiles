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

local function check_wifi()
  awful.spawn.easy_async_with_shell('nmcli general status', function( stdout )
    checker = stdout:match('disabled')
    -- IF NOT NULL THEN WIFI IS DISABLED
    -- IF NULL IT THEN WIFI IS ENABLED
    if(checker ~= nil) then
      mode = false
      --awful.spawn('notify-send checker~=NOTNULL disabled')
      update_icon()
    else
      mode = true
    --awful.spawn('notify-send checker==NULL enabled')
      update_icon()
    end
  end)

end

local function toggle_wifi()
  if(mode == true) then
    awful.spawn('nmcli r wifi off')
    awful.spawn("notify-send 'Airplane Mode Enabled'")
    mode = false
    update_icon()
  else
    awful.spawn('nmcli r wifi on')
    awful.spawn("notify-send 'Initializing WI-FI'")
    mode = true
    update_icon()
  end
end


check_wifi()



local wifi_button = clickable_container(wibox.container.margin(widget, dpi(7), dpi(7), dpi(7), dpi(7))) -- 4 is top and bottom margin
wifi_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        toggle_wifi()
      end
    )
  )
)

-- Alternative to naughty.notify - tooltip. You can compare both and choose the preferred one
awful.tooltip(
  {
    objects = {wifi_button},
    mode = 'outside',
    align = 'right',
    timer_function = function()
      if checker == nil then
        return 'WI-FI is ON'
      else
        return 'Airplane Mode'
      end
    end,
    preferred_positions = {'right', 'left', 'top', 'bottom'}
  }
)

local last_wifi_check = os.time()
watch(
  'nmcli general status',
  5,
  function(_, stdout)
   -- Check if there  bluetooth
    checker = stdout:match('disabled') -- If 'Controller' string is detected on stdout
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
  text = 'Wireless Connection',
  font = 'Iosevka Regular 10',
  align = 'left',
  widget = wibox.widget.textbox
}

local content =   wibox.widget {
    settingsName,
    wifi_button,
    bg = '#ffffff20',
    shape = gears.shape.rounded_rect,
    widget = wibox.container.background(settingsName),
    layout = wibox.layout.ratio.horizontal,

  }
content:set_ratio(1, .85)

local wifiButton =  wibox.widget {
  wibox.widget {
    content,
    widget = mat_list_item
  },
  layout = wibox.layout.fixed.vertical
}
return wifiButton
--return wifi_button
