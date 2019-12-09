-- Music title and artist name
local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi

local song_info = {}

-- Music Title
music_title = wibox.widget {
  {
    id = 'title',
    text = 'Title',
    font = 'SFNS Display Bold 12',
    align  = 'center',
    valign = 'center',
    ellipsize = 'end',
    widget = wibox.widget.textbox
  },
  layout = wibox.layout.flex.horizontal
}

-- Music Artist
music_artist = wibox.widget {
  {
    id = 'artist',
    text = 'Artist',
    font = 'SFNS Display 9',
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  },
  layout = wibox.layout.flex.horizontal
}

music_info = wibox.widget {
  expand = 'none',
  layout = wibox.layout.fixed.vertical,
  music_title,
  music_artist,
}

song_info.music_title = music_title
song_info.music_artist = music_artist
song_info.music_info = music_info


return song_info