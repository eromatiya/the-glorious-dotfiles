-- Return UI Table
return {
	album_cover = require('widget.mpd.content.album-cover'),
	progress_bar = require('widget.mpd.content.progress-bar'),
	track_time = require('widget.mpd.content.track-time'),
	song_info = require('widget.mpd.content.song-info'),
	media_buttons = require('widget.mpd.content.media-buttons'),
	volume_slider = require('widget.mpd.content.volume-slider'),
}