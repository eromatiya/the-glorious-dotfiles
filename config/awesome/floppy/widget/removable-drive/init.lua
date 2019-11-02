-- Removable drive widget
-- Currently limited to support only one external drive/flashdrive

local awful = require('awful')
local naughty = require('naughty')
local watch = require('awful.widget.watch')
local wibox = require('wibox')
local clickable_container = require('widget.material.clickable-container')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi


local apps = require('configuration.apps')
local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/removable-drive/icons/'
local PATH_TO_WIDGET = HOME .. '/.config/awesome/widget/removable-drive/'
local checker
local mountStatus
local tooltipText

local widget =
  wibox.widget {
  {
    id = 'icon',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

local widget_button = clickable_container(wibox.container.margin(widget, dpi(7), dpi(7), dpi(7), dpi(7)))
widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        if mountStatus == "connected" then
          awful.spawn(apps.bins.mountDrive, false)
        elseif mountStatus == "mounted" then
          awful.spawn(apps.bins.unmountDrive, false)
        end
      end
    ),
    awful.button(
      {},
      3,
      nil,
      function()
        if mountStatus == "mounted" then
          awful.spawn(apps.bins.openExtDrive, false)
        end
      end
    )
  )
)

-- Function to check status after awesome.restart()
local function checkMountStatus()
  local cmd = "cat " .. PATH_TO_WIDGET .. "status"
  awful.spawn.easy_async_with_shell(cmd, function(stdout)
    local status = stdout
    if status:match("connected") then
      awesome.emit_signal("drive::connected")
    end
    if status:match("mounted") then
      awesome.emit_signal("drive::mounted")
    end
    if status:match("none") then
      awesome.emit_signal("drive::unmounted")
    end
    if status == nil then
      awesome.emit_signal("drive::unmounted")
    end
  end, false)
end


-- Alternative to naughty.notify - tooltip. You can compare both and choose the preferred one
awful.tooltip(
  {
    objects = {widget_button},
    mode = 'outside',
    align = 'right',
    timer_function = function()
      return tooltipText
    end,
    preferred_positions = {'right', 'left', 'top', 'bottom'}
  }
)

-- Drive is inserted, but not yet mounted
awesome.connect_signal("drive::connected", function()
  -- Show widget
  widget_button.visible = true
  -- Update widget icon
  widget.icon:set_image(PATH_TO_ICONS .. 'mount' .. '.svg')
  -- Update Status
  mountStatus = 'connected'
  -- Write the mount status to preserve it on awesome.restart()
  awful.spawn.easy_async_with_shell("echo " .. mountStatus .. " > " .. PATH_TO_WIDGET .. "status", function(stdout) end, false)
  -- Update tooltip
  tooltipText = "Click to mount the device."
end)

-- Drive is mounted
awesome.connect_signal("drive::mounted", function()
  -- Show widget
  widget_button.visible = true
  -- Update Icon
  widget.icon:set_image(PATH_TO_ICONS .. 'eject' .. '.svg')
  -- Update status
  mountStatus = 'mounted'
  -- Write status to preserve it in case of awesome.restart()
  awful.spawn.easy_async_with_shell("echo " .. mountStatus .. " > " .. PATH_TO_WIDGET .. "status", function(stdout) end, false)
  -- Update tooltip
  tooltipText = "Left-click to eject the device.\nRight click to open device."
end)

-- Drive is unmounted
awesome.connect_signal("drive::unmounted", function()
  -- Hide widget
  widget_button.visible = false
  -- Update status
  mountStatus = 'none'
  -- Preserve status by writing it in a file
  awful.spawn.easy_async_with_shell("echo " .. mountStatus .. " > " .. PATH_TO_WIDGET .. "status", function(stdout) end, false)
end)


-- Monitor script
local udisk_script = [[
    sh -c "
    udisksctl monitor | grep -o --line-buffered 'filesystem-unmount\|filesystem-mount\|Added /org/freedesktop/UDisks2/drives/'
"]]

-- Kill old udiscksctl process
awful.spawn.easy_async_with_shell("ps x | grep \"udisksctl\" | grep -v grep | awk '{print $1}' | xargs kill", function ()
    -- Update mounted drive status with each line printed by udisk_script
    awful.spawn.with_line_callback(udisk_script, {
        stdout = function(stdout)
          if stdout == 'Added /org/freedesktop/UDisks2/drives/' then
            awful.spawn("notify-send 'External drive connected!'", false)
            awesome.emit_signal("drive::connected")
          elseif stdout == 'filesystem-mount' then
            awful.spawn("notify-send 'The device is now ready for work!'", false)
            awesome.emit_signal("drive::mounted")
          elseif stdout == 'filesystem-unmount' then
            awful.spawn("notify-send 'The device can now be safely removed from the computer!'", false)
            awesome.emit_signal("drive::unmounted")
          end
        end
    })
end, false)

-- checkMountStatus on startup
checkMountStatus()

return widget_button
