-- YOU CAN UPDATE YOUR PROFILE PICTURE USING `mugshot` package
-- Will use default user.svg if there's no user image in /var/lib/...

local awful = require('awful')
local naughty = require('naughty')
local watch = require('awful.widget.watch')
local wibox = require('wibox')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi

local beautiful = require('beautiful')

local clickable_container = require('widget.material.clickable-container')

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/user-profile/icons/'

local PATH_TO_USERICON = '/var/lib/AccountsService/icons/'



local profile_imagebox =
  wibox.widget {
  {
    id = 'icon',
    forced_height = dpi(70),
    image = PATH_TO_ICONS .. 'user' .. '.svg',
    clip_shape = gears.shape.circle,
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

local profile_name = wibox.widget {
  align = 'left',
  valign = 'bottom',
  widget = wibox.widget.textbox
}

local distro_name = wibox.widget {
  align = 'left',
  valign = 'center',
  widget = wibox.widget.textbox
}

local uptime_time = wibox.widget {
  align = 'left',
  valign = 'center',
  widget = wibox.widget.textbox
}



  -- Check username
awful.spawn.easy_async_with_shell('whoami', function(out)

  -- Update profile name
  -- Capitalize first letter of username
  name = out:gsub('%W','')
  name =  name:sub(1,1):upper()..name:sub(2)
  profile_name.markup = '<span font="SFNS Display Bold 24">' .. name ..'</span>' --out:sub(1,1):upper()..out:sub(2)


  -- Bash script to check if user profile picture exists in /var/lib/AccountsService/icons/
  local cmd_check_user_profile = "if test -f " .. PATH_TO_USERICON .. out .. "; then print 'image_detected'; else print 'not_detected'; fi"
  awful.spawn.easy_async_with_shell(cmd_check_user_profile, function(stdout)

    -- there_is_face
    if stdout:match('image_detected') then

      -- Check if we already have a user's profile image copied to icon folder
      local cmd_icon_check = "if test -f " .. PATH_TO_ICONS .. 'user.jpg' .. "; then print 'exists'; fi"
      awful.spawn.easy_async_with_shell(cmd_icon_check, function(stdout)
        if stdout:match('exists') then
          -- If the file already copied, don't copy, just update the imagebox
          profile_imagebox.icon:set_image(PATH_TO_ICONS .. 'user.jpg')
        else
          -- Image detected, now copy your profile picture to the widget directory icon folder
          copy_cmd = 'cp ' .. PATH_TO_USERICON .. out .. ' ' .. PATH_TO_ICONS .. 'user.jpg'
          awful.spawn(copy_cmd)

          -- Add a timer to a delay
          -- The cp command is not fast enough so we will need this to update image
          gears.timer {
            timeout = 1,
            autostart = true,
            single_shot = true,
            callback  = function()
              -- Then set copied image as profilepic in the widget
              profile_imagebox.icon:set_image(PATH_TO_ICONS .. 'user.jpg')
            end
          }
        end
      end, false)

    else
      -- r_u_ugly?
      -- if yes then use this image instead
      profile_imagebox.icon:set_image(PATH_TO_ICONS .. 'user' .. '.svg')
    end

  end, false)

end, false)



-- Check distro name
awful.spawn.easy_async_with_shell("cat /etc/os-release | awk 'NR==1'| awk -F " .. "'" .. '"' .. "'" .. " '{print $2}'", function(out)
  -- Remove newline represented by `\n`
  distroname = out:gsub('%\n','')
  distro_name.markup = '<span font="SFNS Display Regular 12">' .. distroname ..'</span>'
end)

-- RUn once on startup or login
awful.spawn.easy_async_with_shell("uptime -p", function(out)
  uptime = out:gsub('%\n','')
  uptime_time.markup = '<span font="SFNS Display Regular 10">' .. uptime ..'</span>'
end)
-- Check uptime every 600 seconds/10min
awful.widget.watch('uptime -p', 600, function(widget, stdout)
  uptime = stdout:gsub('%\n','')
  uptime_time.markup = '<span font="SFNS Display Regular 10">' .. uptime ..'</span>'
  collectgarbage('collect')
end)


local user_profile = wibox.widget {
  expand = 'none',
  {
    {
      layout = wibox.layout.align.horizontal,
      {
        profile_imagebox,
        margins = dpi(3),
        widget = wibox.container.margin,
      },
      {
        -- expand = 'none',
        layout = wibox.layout.align.vertical,
        {
          wibox.container.margin(profile_name, dpi(5)),
          layout = wibox.layout.fixed.horizontal,
        },
        {
          wibox.container.margin(distro_name, dpi(5)),
          layout = wibox.layout.fixed.vertical,
        },
        {
          wibox.container.margin(uptime_time, dpi(5)),
          layout = wibox.layout.fixed.vertical,
        },
      },
    },
    margins = dpi(10),
    widget = wibox.container.margin,
  },
  bg = beautiful.bg_modal,
  shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 6) end,
  widget = wibox.container.background
}


-- return profile_imagebox

return user_profile
