-- Return UI Table
--- @class widget.mpd.content
--- @field album_cover any cover widget
--- @field song_info any info widget
--- @field media_buttons any media widget
--- @field track_time any time widget
--- @field volume_slider any volume widget
--- @field progress_bar any bar widget
--- @type widget.mpd.content
local temp = {
	album_cover = require("widget.mpd.content.album-cover"),
	song_info = require("widget.mpd.content.song-info"),
	media_buttons = require("widget.mpd.content.media-buttons"),
	track_time = require("widget.mpd.content.track-time"),
	volume_slider = require("widget.mpd.content.volume-slider"),
	progress_bar = require("widget.mpd.content.progress-bar"),
}

return temp
