-- This widget is messy AF
-- It is a hackish way to disable and enable blur effect in compton because
-- There's no native way to do it. Implementing DBUS integration would be useful in here but it isnt supported
-- It uses unix command to change some strings in compton config

local awful = require('awful')
local naughty = require('naughty')
local wibox = require('wibox')
local clickable_container = require('widget.action-center.clickable-container')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local watch = require('awful.widget.watch')
local mat_list_item = require('widget.material.list-item')
local filesystem = require('gears.filesystem')
local apps = require('configuration.apps')
local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/action-center/icons/'
local frameStatus
local widgetIconName

-- Image wibox

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
  if frameStatus then
    widgetIconName = 'toggled-on'
    widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. '.svg')
  else
    widgetIconName = 'toggled-off'
    widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. '.svg')
  end
end

local check_blur_status = [[

grep -F "blur-background-frame = false;" ]] .. filesystem.get_configuration_dir() .. [[/configuration/compton.conf | tr -d '[\-\;\=\ ]'

]]
-- It checks the line "blur-background-frame: false;"
-- I use 'tr' shell command to remove the special characters
-- because lua is choosy on MATCH method
-- So the output will be 'blurbackgroundframefalse'
-- if it matches the assigned value inside the match method below
-- then it will declared as value of frameChecker
-- The rest is history
local frameChecker
function checkFrame()
  awful.spawn.easy_async_with_shell(check_blur_status, function( stdout )
    frameChecker = stdout:match('blurbackgroundframefalse')
    if frameChecker == nil then
      frameStatus = true
      update_icon()
    else
      frameStatus = false
    end
    
    -- Update icon
    update_icon()
  end)
end



-- The Toggle button backend
local function toggle_compositor()
  if(frameStatus == true) then
    apps.bins.disableBlur()
    frameStatus = false
  else
    apps.bins.enableBlur()
    frameStatus = true
  end

  -- Update icon
  update_icon()

end

-- Check blur status
checkFrame()

local compton_button = clickable_container(wibox.container.margin(widget, dpi(7), dpi(7), dpi(7), dpi(7))) -- 4 is top and bottom margin
compton_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        toggle_compositor()
      end
    )
  )
)

local settingsName = wibox.widget {
  text = 'Window Effects',
  font = 'SFNS Display 11',
  align = 'left',
  widget = wibox.widget.textbox
}


local content =   wibox.widget {
  {
    settingsName,
    layout = wibox.layout.fixed.horizontal,
  },
  nil,
  {
    compton_button,
    layout = wibox.layout.fixed.horizontal,
  },
  layout = wibox.layout.align.horizontal,
}

local comptonButton =  wibox.widget {
  wibox.widget {
    content,
    widget = mat_list_item
  },
  layout = wibox.layout.fixed.vertical
}

return comptonButton
