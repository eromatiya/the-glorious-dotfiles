#!/bin/sh

MPD_MUSIC_PATH="/home/gerome/Music"
TMP_COVER_PATH="/tmp/mpd-track-cover.jpg"

exiftool -b -Picture "$MPD_MUSIC_PATH/$(mpc -p 6601 --format "%file%" current)" > "$TMP_COVER_PATH"
