local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local ui_content = require('widget.mpd.content')
local album = ui_content.album_cover
local song_info = ui_content.song_info.music_info
local media_buttons = ui_content.media_buttons.navigate_buttons

local music_box = wibox.widget {
	layout = wibox.layout.align.horizontal,
	forced_height = dpi(46),
	{
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(10),
		album,
		song_info
	},
	nil,
	{
		layout = wibox.layout.align.vertical,
		expand = 'none',
		nil,
		media_buttons,
		nil
	}
}

-- Mpd widget updater
require('widget.mpd.mpd-music-updater')

return music_box