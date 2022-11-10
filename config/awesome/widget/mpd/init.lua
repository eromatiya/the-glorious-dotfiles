local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local ui_content = require("widget.mpd.content")
local album = ui_content.album_cover
local song_info = ui_content.song_info.music_info
local media_buttons = ui_content.media_buttons.navigate_buttons
local top_panel_button = require("widget.mpd.top-panel-widget")

require("widget.mpd.mpd-music-updater")

-- 🔧 TODO: fix music box widget
local music_box = wibox.widget({
	layout = wibox.layout.align.vertical,
	forced_height = dpi(46),
	{
		layout = wibox.layout.fixed.horizontal,
		halign = "center",
		spacing = dpi(10),
		album,
		song_info,
		media_buttons,
	},
})

---@type theme_dictionary<any>
local theme_map = {
	surreal = music_box,
	linear = music_box,
	floppy = top_panel_button,
	gnawesome = top_panel_button,
}

-- Mpd widget updater
return theme_map[THEME]
