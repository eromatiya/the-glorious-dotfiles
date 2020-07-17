#!/usr/bin/env bash

# Simple ncmpcpp notification script by Gerome Matilla;
# gerome.matilla07@gmail.com
#	Depends:
#		- mpc, mpd, ncmpcpp, imagemagick, ffmpeg or perl-image-exiftool

MUSIC_DIR="${HOME}/Music"
TMP_DIR="/tmp/ncmpcpp_${USER}"
TMP_COVER_PATH="${TMP_DIR}/ncmpcpp_cover.jpg"
TMP_SONG="/tmp/current-song"
CHECK_EXIFTOOL=$(command -v exiftool)
CHECK_DUNST=$(command -v dunst)
CHECK_AWESOME_CLIENT=$(command -v awesome-client)

current_title="$(mpc -f %title% current | tr -d '"')"
current_artist="$(mpc -f %artist% current | tr -d '"')"

# Exit if $USER is in TTY
if [[ "$(ps -h -o comm -p "$PPID")" == *"login"* ]]; then
  exit 1
fi

if [[ ! -d "$TMP_DIR" ]]; then
	mkdir -p "$TMP_DIR"
fi

# Remove file extension name
function check_mpc_data() {
	if [[ -z "$current_title" ]]; then
		file_name="$(mpc -f %file% current | tr -d '"')"
		file_name=${file_name::-4}
		current_title="${file_name}"
		current_artist='unknown artist'
	fi
}

check_mpc_data

# This function is unused right now
function display_album_art() {
	if [[ "$TERM" == "kitty" ]]; then
	  kitty +kitten icat --clear
	  kitty +kitten icat --transfer-mode stream --place 25x25@0x0 "$TMP_COVER_PATH"
	fi
}

# Check DE/WM
function get_desktop_env() {
	# Identify environment
	DE="${DESKTOP_STARTUP_ID}"
	if [[ ! -z "$DE" && "$DE" == *"awesome"* ]] || [[ ! -z "$CHECK_AWESOME_CLIENT" ]]; then
		echo "AWESOME"
		return
	fi
	echo "NOT_AWESOME"
}

# Extract album cover
if [[ ! -z "$CHECK_EXIFTOOL" ]]; then

	SONG="$MUSIC_DIR/$(mpc -p 6600 --format "%file%" current)"
	PICTURE_TAG="-Picture"
			
	if [[ "$SONG" == *".m4a" ]]; then
		PICTURE_TAG="-CoverArt"
	fi

	# Extract album cover using perl-image-exiftool
	exiftool -b "$PICTURE_TAG" "$SONG"  > "$TMP_COVER_PATH"

else

	#Extract image using ffmpeg
	cp "$MUSIC_DIR/$(mpc --format %file% current)" "$TMP_SONG"

	ffmpeg \
	-hide_banner \
    -loglevel 0 \
    -y \
    -i "$TMP_SONG" \
    -vf scale=300:-1 \
    "$TMP_COVER_PATH" > /dev/null 2>&1

	rm "$TMP_SONG"
fi

# Check if image is valid
function check_album_data() {
	img_data=$(identify "$TMP_COVER_PATH" 2>&1)
	if [[ "$img_data" == *"insufficient"* ]]; then
		TMP_COVER_PATH="${HOME}/.config/ncmpcpp/vinyl.svg"
	fi
}

check_album_data

# Create a notification using AwesomeWM API
function notify_awesome() {
	awesome-client "
	local naughty = require('naughty')
	local awful = require('awful')
	local gears = require('gears')

	local prev = naughty.action ({
		name = 'Prev'
	})

	local pause = naughty.action ({
		name = 'Pause'
	})

	local next = naughty.action ({
		name = 'Next'
	})

	prev:connect_signal('invoked', function()
		awful.spawn('mpc prev', false)
	end)

	pause:connect_signal('invoked', function()
		awful.spawn('mpc pause', false)
	end)

	next:connect_signal('invoked', function()
		awful.spawn('mpc next', false)
	end)

    for k, noti in ipairs(naughty.active) do
      if noti.app_name == 'ncmpcpp' then
        noti.message = \"${current_artist}\"
        noti.title = \"${current_title}\"
        noti.icon = gears.surface.load_uncached(\"${TMP_COVER_PATH}\")
        noti.urgency = 'normal'
        return
      end
    end

	naughty.notification({
		app_name = 'ncmpcpp',
		message = \"${current_artist}\",
		title = \"${current_title}\",
		icon = gears.surface.load_uncached(\"${TMP_COVER_PATH}\"),
		urgency = 'normal',
		actions = { prev, pause, next }
	})
	"
}

# Create a notification
function notify_non_awesome() {
	if [[ ! -z "$CHECK_DUNST" ]]; then
		dunstify --urgency 'normal' --appname "ncmpcpp" \
		--replace 3 --icon "$TMP_COVER_PATH" "$current_title" "$current_artist"
	else
		notify-send --urgency "normal" --app-name "ncmpcpp" \
		--icon "$TMP_COVER_PATH" "$current_title" "$current_artist"
	fi
}

# Call to create a notification
if [[ "$(get_desktop_env)" == "AWESOME" ]]; then
	notify_awesome
else
	notify_non_awesome
fi