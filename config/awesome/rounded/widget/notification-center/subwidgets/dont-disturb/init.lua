local awful = require('awful')
local naughty = require('naughty')
local wibox = require('wibox')
local clickable_container = require('widget.action-center.clickable-container')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi


local mat_list_item = require('widget.material.list-item')
local beautiful = require('beautiful')

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/notification-center/icons/'
local PATH_TO_WIDGET = HOME .. '/.config/awesome/widget/notification-center/subwidgets/dont-disturb/'

dont_disturb = false

local dont_disturb_text = wibox.widget {
  text = 'Do Not Disturb',
  font = 'SFNS Display 12',
  align = 'left',
  widget = wibox.widget.textbox
}


local widget =
  wibox.widget {
  {
    id = 'icon',
    image = PATH_TO_ICONS .. 'toggled-on' .. '.svg',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

local dont_disturb_icon =
  wibox.widget {
  {
    image = PATH_TO_ICONS .. 'dont-disturb' .. '.svg',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

local function update_icon()
  local widgetIconName
  if(dont_disturb == true) then
    widgetIconName = 'toggled-on'
    widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. '.svg')
  else
    widgetIconName = 'toggled-off'
    widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. '.svg')
  end
end


-- Function to check status after awesome.restart()
local function check_disturb_status()
  local cmd = "cat " .. PATH_TO_WIDGET .. "disturb_status"
  awful.spawn.easy_async_with_shell(cmd, function(stdout)
    local status = stdout
    if status:match("true") then
      dont_disturb = true
      update_icon()
    elseif status:match("false") then
      dont_disturb = false
      update_icon()
    else
      dont_disturb = false
      awful.spawn.easy_async_with_shell("echo " .. 'false' .. " > " .. PATH_TO_WIDGET .. "disturb_status", function(stdout) end, false)
      update_icon()
    end
  end, false)
end


-- Check Status after restart()
check_disturb_status()

-- Maintain Status even after awesome.restart() by writing on the PATH_TO_WIDGET/ .. disturb_status
local function toggle_disturb()
  if(dont_disturb == true) then
    -- Switch Off
    dont_disturb = false
    awful.spawn.easy_async_with_shell("echo " .. tostring(dont_disturb) .. " > " .. PATH_TO_WIDGET .. "disturb_status", function(stdout) end, false)
    update_icon()
  else
    -- Switch On
    dont_disturb = true
    awful.spawn.easy_async_with_shell("echo " .. tostring(dont_disturb) .. " > " .. PATH_TO_WIDGET .. "disturb_status", function(stdout) end, false)
    update_icon()
  end
end


local disturb_button = clickable_container(wibox.container.margin(widget, dpi(7), dpi(7), dpi(7), dpi(7)))
disturb_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        toggle_disturb()
      end
    )
  )
)

local content = wibox.widget {
  {
    wibox.container.margin(dont_disturb_icon, dpi(5), dpi(5), dpi(12), dpi(12)),
    dont_disturb_text,
    layout = wibox.layout.fixed.horizontal,
  },
  nil,
  {
    disturb_button,
    layout = wibox.layout.fixed.horizontal,
  },
  layout = wibox.layout.align.horizontal,
}

local dont_disturb_wrap =  wibox.widget {
  {
    {
      content,
      widget = mat_list_item
    },
    bg = beautiful.bg_modal_title,
    shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, beautiful.modal_radius) end,
    widget = wibox.container.background,

  },
  -- Add margins to the left and right only
  left = dpi(15), 
  right = dpi(15),
  widget = wibox.container.margin,
}


return dont_disturb_wrap
