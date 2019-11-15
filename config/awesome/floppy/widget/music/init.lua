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


screen.connect_signal("request::desktop_decoration", function(s)
  -- Create the box
  local width = dpi(260)
  musicPlayer = wibox
  {
    bg = '#00000000',
    visible = false,
    ontop = true,
    type = "normal",
    height = dpi(380),
    width = width,
    x = s.geometry.width - width,
    y = dpi(26),
  }
end)

local backdrop =
  wibox {
  ontop = true,
  visible = false,
  screen = awful.screen.focused(),
  bg = '#00000000',
  type = 'dock',
  x = awful.screen.focused().geometry.x,
  y = dpi(26),
  width = awful.screen.focused().geometry.width,
  height = awful.screen.focused().geometry.height - dpi(26)
}


function togglePlayer()
  backdrop.visible = not backdrop.visible
  musicPlayer.visible = not musicPlayer.visible
end


backdrop:buttons(
  awful.util.table.join(
    awful.button(
      {},
      1,
      function()
        togglePlayer()
      end
    )
  )
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

local widget_button = clickable_container(wibox.container.margin(widget, dpi(7), dpi(7), dpi(7), dpi(7)))
widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        togglePlayer()
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


function checkCover()
  local cmd = "if [[ -f /tmp/cover.jpg ]]; then print exists; fi"
  awful.spawn.easy_async_with_shell(cmd, function(stdout)
    if (stdout:match("%W")) then
      cover.icon:set_image(gears.surface.load_uncached('/tmp/cover.jpg'))
    else
      cover.icon:set_image(gears.surface.load_uncached(PATH_TO_ICONS .. 'vinyl' .. '.svg'))
    end
  end)
end

-- Update info
function updateInfo()
  _G.getTitle()
  _G.getArtist()
  awful.spawn(apps.bins.coverUpdate, false)
  awesome.emit_signal("song_changed")
end


musicPlayer:setup {
  expand = "none",
    {
      {
        wibox.container.margin(cover, dpi(15), dpi(15), dpi(15), dpi(5)),
        layout = wibox.layout.fixed.vertical,
      },
      nil,
      {
        spacing = dpi(4),
        require('widget.music.progressbar'),
        require('widget.music.music-info'),
        require('widget.music.media-buttons'),
        layout = wibox.layout.flex.vertical,
      },
      layout = wibox.layout.fixed.vertical,
    },
    -- The real background color
    bg = beautiful.background.hue_800,
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
        awful.spawn('rm /tmp/cover.jpg', false)
      end
    }
end)

widget.icon:set_image(PATH_TO_ICONS .. 'music' .. '.svg')

-- Update music info on Initialization
local function initMusicInfo()
  awful.spawn(apps.bins.coverUpdate, false)
  checkCover()
  cover.icon:set_image('/tmp/cover.jpg')
  _G.getTitle()
  _G.getArtist()
end
initMusicInfo()

return widget_button
