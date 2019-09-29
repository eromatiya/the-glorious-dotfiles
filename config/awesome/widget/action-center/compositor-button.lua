local awful = require('awful')
local naughty = require('naughty')
local wibox = require('wibox')
local clickable_container = require('widget.action-center.clickable-container')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local watch = require('awful.widget.watch')
local mat_list_item = require('widget.material.list-item')
local filesystem = require('gears.filesystem')

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/action-center/icons/'
local cmd = 'grep -F "blur-background-frame = false;" ' .. filesystem.get_configuration_dir() .. '/configuration/compton.conf ' .. "| tr -d '[\\-\\;\\=\\ ]' "
local frameStatus
local widgetIconName

-- Image wibox

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
  if frameStatus then
    widgetIconName = 'toggled-on'
    widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. '.svg')
  else
    widgetIconName = 'toggled-off'
    widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. '.svg')
  end
end

------
local frameChecker
function checkFrame()
  awful.spawn.easy_async_with_shell(cmd, function( stdout )
    frameChecker = stdout:match('blurbackgroundframefalse')
    if frameChecker == nil then
      frameStatus = true
      update_icon()
    else
      frameStatus = false
      update_icon()
    end
  end)
end

blurDisable = {

  'sed -i -e "s/blur-background-frame = true/blur-background-frame = false/g" ' .. filesystem.get_configuration_dir() .. '/configuration/compton.conf',
  'compton --config ' .. filesystem.get_configuration_dir() .. '/configuration/compton.conf',
  'notify-send "Blur effect disabled"'
}

blurEnable = {
  'sed -i -e "s/blur-background-frame = false/blur-background-frame = true/g" ' .. filesystem.get_configuration_dir() .. '/configuration/compton.conf',
  'compton --config ' .. filesystem.get_configuration_dir() .. '/configuration/compton.conf',
  'notify-send "Blur effect enabled"'
}


local function run_once(cmd)
  local findme = cmd
  local firstspace = cmd:find(' ')
  if firstspace then
    findme = cmd:sub(0, firstspace - 1)
  end
  awful.spawn.with_shell(string.format('pgrep -u $USER -x %s > /dev/null || (%s)', findme, cmd))
end


local function toggle_wifi()
  if(frameStatus == true) then
    awful.spawn.with_shell('kill -9 $(pidof compton)')
    for _, app in ipairs(blurDisable) do
      run_once(app)
    end
    frameStatus = false
    update_icon()
  else
    awful.spawn.with_shell('kill -9 $(pidof compton)')
    for _, app in ipairs(blurEnable) do
      run_once(app)
    end
    frameStatus = true
    update_icon()
  end
end

checkFrame()
-----------------------------------------------------------------------------------------------------------------

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

local settingsName = wibox.widget {
  text = 'Window Effects',
  font = 'Roboto medium 12',
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
