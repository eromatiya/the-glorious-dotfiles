local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')

local dpi = require('beautiful').xresources.apply_dpi

local clickable_container = require('widget.material.clickable-container')
local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/music/icons/'

local mat_list_item = require('widget.material.list-item')

local apps = require('configuration.apps')

-- A table that will contain some functions
local music_func = {}


-- Create music box in every screen
screen.connect_signal("request::desktop_decoration", function(s)

  -- Create the box
  local width = dpi(260)
  music_player = wibox
  {
    bg = '#00000000',
    visible = false,
    ontop = true,
    type = "normal",
    height = dpi(375),
    width = width,
    x = s.geometry.width - width,
    y = dpi(26),
  }

  backdrop = wibox {
    ontop = true,
    visible = false,
    screen = s,
    bg = '#00000000',
    type = 'dock',
    x = s.geometry.x,
    y = dpi(26),
    width = s.geometry.width,
    height = s.geometry.height - dpi(26)
  }

  -- Make this non private
  toggle_player = function()
    -- awful.spawn('notify-send yayayayyaay')
    backdrop.visible = not backdrop.visible
    music_player.visible = not music_player.visible
  end

  backdrop:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          toggle_player()
        end
      )
    )
  )


  music_player:setup {
    expand = "none",
    -- wibox.widget.textbox('asdsad'),
    {
      layout = wibox.layout.fixed.vertical,
      spacing = dpi(8),
      {
        require('widget.music.content.album-cover'),
        -- Yes I know how to do this in a one liner, I'm just changing my *style* yow
        top = dpi(15),
        left = dpi(15),
        right = dpi(15),
        bottom = dpi(5),
        widget = wibox.container.margin,
      },
      {
        spacing = dpi(0),
        layout = wibox.layout.fixed.vertical,
        {
          spacing = dpi(4),
          layout = wibox.layout.fixed.vertical,
          {
            require('widget.music.content.progress-bar'),
            left = dpi(15),
            right = dpi(15),
            widget = wibox.container.margin,
          },
          {
            require('widget.music.content.track-time').time_track,
            left = dpi(15),
            right = dpi(15),
            widget = wibox.container.margin,
          },
        },
        {
          require('widget.music.content.song-info').music_info,
          left = dpi(15),
          right = dpi(15),
          widget = wibox.container.margin,
        },
        {
          require('widget.music.content.media-buttons').navigate_buttons,
          left = dpi(15),
          right = dpi(15),
          widget = wibox.container.margin,
        },
        {
          require('widget.music.content.volume-slider').slider_volume,
          left = dpi(15),
          right = dpi(15),
          widget = wibox.container.margin,
        },
      },
    },
    -- The real background color
    bg = beautiful.background.hue_800,
    -- The real, anti-aliased shape
    shape = function(cr, width, height)
     gears.shape.partially_rounded_rect( cr, width, height, false, false, true, true, 12) 
    end,
    widget = wibox.container.background()
  }

end)

-- Add toggle_player() function in table
music_func.toggle = toggle_player


-- Update the widget
require('widget.music.mpd-music-updater')


-- Return the table to make it usable/accessible to another part of the setup
return music_func