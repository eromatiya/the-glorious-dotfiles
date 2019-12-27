local filesystem = require('gears.filesystem')
local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')


local clickable_container = require('widget.action-center.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local watch = require('awful.widget.watch')
local mat_list_item = require('widget.material.list-item')


local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/action-center/icons/'
local apps = require('configuration.apps')

local frame_status = nil

-- Imagebox
local button_widget =
  wibox.widget {
  {
    id = 'icon',
    image = PATH_TO_ICONS .. 'toggled-off' .. '.svg',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}


-- Update imagebox
local update_imagebox = function()
  if action_status then
    button_widget.icon:set_image(PATH_TO_ICONS .. 'toggled-on' .. '.svg')
  else
    button_widget.icon:set_image(PATH_TO_ICONS .. 'toggled-off' .. '.svg')
  end
end

-- Check Blur Status Commands
local check_blur_status = [[
grep -F "blur-background-frame = false;" ]] .. filesystem.get_configuration_dir() .. [[/configuration/compton.conf | tr -d '[\-\;\=\ ]'
]]

-- Check status
local check_action_status = function()
  awful.spawn.easy_async_with_shell(check_blur_status, function(stdout)
    if stdout:match('blurbackgroundframefalse') then
      action_status = false
    else
      action_status = true
    end
   
    -- Update imagebox
    update_imagebox()
  end)
end


local toggle_action = function()
  if action_status then
    action_status = false
    apps.bins.disableBlur()
  else
    action_status = true
    apps.bins.enableBlur()
  end

  -- Update imagebox
  update_imagebox()
end

-- Button
local widget_button = clickable_container(wibox.container.margin(button_widget, dpi(7), dpi(7), dpi(7), dpi(7)))
widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        toggle_action()
      end
    )
  )
)

-- Tootltip
awful.tooltip {
  objects = {widget_button},
  mode = 'outside',
  align = 'right',
  timer_function = function()
    if action_status == true then
      return 'Window effects enabled'
    else
      return 'Window effects disabled'
    end
  end,
  preferred_positions = {'right', 'left', 'top', 'bottom'}
}


-- Action Name
local action_name = wibox.widget {
  text = 'Window Effects',
  font = 'SFNS Display 11',
  align = 'left',
  widget = wibox.widget.textbox
}

-- Heirarchy
local widget_content = wibox.widget {
  {
    action_name,
    layout = wibox.layout.fixed.horizontal,
  },
  nil,
  {
    widget_button,
    layout = wibox.layout.fixed.horizontal,
  },
  layout = wibox.layout.align.horizontal,
}

-- Wrapping
local action_widget =  wibox.widget {
  wibox.widget {
    widget_content,
    widget = mat_list_item
  },
  layout = wibox.layout.fixed.vertical
}

-- Update/Check status on startup
check_action_status()

-- Return widget
return action_widget
