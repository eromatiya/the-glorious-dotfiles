local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')

local naughty = require('naughty')
local dpi = require('beautiful').xresources.apply_dpi

local clickable_container = require('widget.material.clickable-container')
local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/music/icons/'

local mat_list_item = require('widget.material.list-item')

local apps = require('configuration.apps')


awful.screen.connect_for_each_screen(
  function(s)
    -- Create the box
    local offsetx = dpi(360)
    musicPlayer = wibox(
      {
        bg = '#00000000',
        visible = false,
        ontop = true,
        type = "normal",
        height = dpi(380),
        width = 260,
        x = s.geometry.width - offsetx,
        y = dpi(26),
      }
    )
  end
)

local widget =
  wibox.widget {
  {
    id = 'icon',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

local widget_button = clickable_container(wibox.container.margin(widget, dpi(14), dpi(14), dpi(7), dpi(7))) -- 4 is top and bottom margin
widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        musicPlayer.visible = not musicPlayer.visible
      end
    )
  )
)

-- Album Cover
local cover =
  wibox.widget {
  {
    id = 'icon',
    widget = wibox.widget.imagebox,
    resize = true,
    clip_shape = gears.shape.rounded_rect,
  },
  layout = wibox.layout.fixed.vertical
}

-- Music Title
local musicTitle =
  wibox.widget {
  {
    id = 'title',
    font = 'SFNS Display Bold 12',
    align  = 'center',
    valign = 'bottom',
    ellipsize = 'end',
    widget = wibox.widget.textbox
  },
  layout = wibox.layout.flex.horizontal
}
local function getTitle()
  awful.spawn.easy_async_with_shell('mpc -f %title% current', function( stdout )
    if (stdout:match("%W")) then
      musicTitle.title:set_text(stdout)
    else
      musicTitle.title:set_text("Play A")
    end
  end)
end

-- Music Artist
local musicArtist =
  wibox.widget {
  {
    id = 'artist',
    font = 'SFNS Display 9',
    align  = 'center',
    valign = 'top',
    widget = wibox.widget.textbox
  },
  layout = wibox.layout.flex.horizontal
}
local function getArtist()
  awful.spawn.easy_async_with_shell('mpc -f %artist% current', function( stdout )
    if (stdout:match("%W")) then
      musicArtist.artist:set_text(stdout)
    else
      musicArtist.artist:set_text('MUSIC :)')
    end
  end)
end

-- Update info
function updateInfo()
  getTitle()
  getArtist()
  awful.spawn(apps.bins.coverUpdate)
  awesome.emit_signal("song_changed")
end


musicPlayer:setup {
  expand = "none",
    {
      {
        wibox.container.margin(cover, 15, 15, 15, 5),
        layout = wibox.layout.fixed.vertical,
      },
      nil,
      {
        require('widget.music.progressbar'),
        musicTitle,
        musicArtist,
        require('widget.music.media-buttons'),
        layout = wibox.layout.flex.vertical,
      },
      layout = wibox.layout.fixed.vertical,
    },
    -- The real background color
    bg = "#000000".. "66",
    -- The real, anti-aliased shape
    shape = function(cr, width, height)
              gears.shape.partially_rounded_rect(
                cr,
                width,
                height,
                false,
                false,
                true,
                true,
                12)
            end,
    widget = wibox.container.background()
}


-- Check every X seconds if song status is
-- Changed outside this widget
local updateWidget = gears.timer {
    timeout = 5,
    autostart = true,
    callback  = function()
      _G.checkIfPlaying()
      updateInfo()
    end
}

-- Execute if button is next/play/prev button is pressed
awesome.connect_signal("song_changed", function()
  gears.timer {
      timeout = 1,
      autostart = true,
      single_shot = true,
      callback  = function()
        cover.icon:set_image(gears.surface.load_uncached('/tmp/cover.jpg'))
        awful.spawn('rm /tmp/cover.jpg')
      end
    }
end)

widget.icon:set_image(PATH_TO_ICONS .. 'music' .. '.svg')

-- Update info on Initialization
awful.spawn(apps.bins.coverUpdate)
cover.icon:set_image('/tmp/cover.jpg')
getTitle()
getArtist()

return widget_button
