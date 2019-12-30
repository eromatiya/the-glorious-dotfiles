local awful = require('awful')
local naughty = require('naughty')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local dpi = require('beautiful').xresources.apply_dpi
local mat_list_item = require('widget.material.list-item')
local clickable_container = require('widget.material.clickable-container')

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/notif-center/icons/'
local PATH_TO_WIDGET = HOME .. '/.config/awesome/widget/notif-center/'

dont_disturb = false

-- Delete button imagebox
local dont_disturb_imagebox = wibox.widget {
  {
    id = 'icon',
    image = PATH_TO_ICONS .. 'dont-disturb-mode' .. '.svg',
    resize = true,
    forced_height = dpi(20),
    forced_width = dpi(20),
    widget = wibox.widget.imagebox,
  },
  layout = wibox.layout.fixed.horizontal
}

local function update_icon()
  local widgetIconName
  if dont_disturb then
    widgetIconName = 'toggled-on'
    dont_disturb_imagebox.icon:set_image(PATH_TO_ICONS .. 'dont-disturb-mode' .. '.svg')
  else
    widgetIconName = 'toggled-off'
    dont_disturb_imagebox.icon:set_image(PATH_TO_ICONS .. 'notify-mode' .. '.svg')
  end
end

-- Function to check status after awesome.restart()
local check_disturb_status = function()
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

-- Check status on startup
check_disturb_status()

-- Maintain Status even after awesome.restart() by writing on the PATH_TO_WIDGET/ .. disturb_status
local toggle_disturb = function()
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



local dont_disturb_button = clickable_container(wibox.container.margin(dont_disturb_imagebox, dpi(7), dpi(7), dpi(7), dpi(7)))
dont_disturb_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        -- toggle
        toggle_disturb()
      end
    )
  )
)

local dont_disturb_wrapped = wibox.widget {
  {
    dont_disturb_button,
    bg = beautiful.bg_modal, 
    shape = gears.shape.circle,
    widget = wibox.container.background
  },
  layout = wibox.layout.fixed.horizontal
}

return dont_disturb_wrapped