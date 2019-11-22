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
function getTitle()
  awful.spawn.easy_async_with_shell('mpc -f %title% current', function( stdout )
    if (stdout:match("%W")) then
      musicTitle.title:set_text(stdout)
    else
      musicTitle.title:set_text("Play Music :)")
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
function getArtist()
  awful.spawn.easy_async_with_shell('mpc -f %artist% current', function( stdout )
    if (stdout:match("%W")) then
      musicArtist.artist:set_text(stdout)
    else
      musicArtist.artist:set_text("Music is love. Music is life.")
    end
  end)
end



local musicInfo =
  wibox.widget {
    wibox.container.margin(musicTitle, dpi(15), dpi(15)),
    wibox.container.margin(musicArtist, dpi(15), dpi(15)),
    layout = wibox.layout.flex.vertical,
}

return musicInfo
