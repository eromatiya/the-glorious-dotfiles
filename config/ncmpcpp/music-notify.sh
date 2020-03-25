#!/usr/bin/env bash

# Simple ncmpcpp notification script by Gerome Matilla;
# gerome.matilla07@gmail.com
#	Depends:
#		- mpc, mpd, ncmpcpp, imagemagick, ffmpeg or perl-image-exiftool

music_dir="${HOME}/Music"
tmp_cover_path="/tmp/ncmpcpp_cover.jpg"
temp_song="/tmp/current-song"
check_exiftool=$(command -v exiftool)
check_dunst=$(command -v dunst)
check_awesome_client=$(command -v awesome-client)

current_title="$(mpc -f %title% current)"
current_artist="$(mpc -f %artist% current)"

# Exit if $USER is in TTY
if [[ $(ps -h -o comm -p $PPID) == *"login"* ]]; then
  exit 1
fi

# Remove file extension name
function check_mpc_data() {
	if [[ -z $current_title ]]; then
		file_name="$(mpc -f %file% current)"
		file_name=${file_name::-4}
		current_title="$file_name"
		current_artist='unknown artist'
	fi
}

check_mpc_data

# This function is unused right now
function display_album_art() {
	if [[ $TERM == "kitty" ]]; then
	  kitty +kitten icat --clear
	  kitty +kitten icat --transfer-mode stream --place 25x25@0x0 $tmp_cover_path
	fi
}

# Check DE/WM
function get_desktop_env() {
	# Identify environment
	de=${DESKTOP_STARTUP_ID}
	if [[ ! -z "$de" && $de == *"awesome"* ]] || [[ ! -z "$check_awesome_client" ]]; then
		echo "AWESOME"
		return
	fi
	echo "NOT_AWESOME"
}

# Extract album cover
if [[ ! -z "$check_exiftool" ]]; then

	# Extract album cover using perl-image-exiftool
 	exiftool -b -Picture \
 	"$music_dir/$(mpc -p 6600 --format "%file%" current)" > "$tmp_cover_path"

else

	#Extract image using ffmpeg
	cp "$music_dir/$(mpc --format %file% current)" "$temp_song"

	ffmpeg \
	-hide_banner \
    -loglevel 0 \
    -y \
    -i "$temp_song" \
    -vf scale=300:-1 \
    "$tmp_cover_path" > /dev/null 2>&1

	rm "$temp_song"
fi

# Check if image is valid
function check_album_data() {
	img_data=$(identify $tmp_cover_path 2>&1)
	if [[ $img_data == *"insufficient"* ]]; then
		tmp_cover_path="${HOME}/.config/ncmpcpp/vinyl.svg"
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
        noti.icon = gears.surface.load_uncached(\"${tmp_cover_path}\")
        noti.urgency = 'normal'
        return
      end
    end

	naughty.notification({
		app_name = 'ncmpcpp',
		message = \"${current_artist}\",
		title = \"${current_title}\",
		icon = gears.surface.load_uncached(\"${tmp_cover_path}\"),
		urgency = 'normal',
		actions = { prev, pause, next }
	})
	"
}

# Create a notification
function notify_non_awesome() {
	if [[ ! -z "$check_dunst" ]]; then
		dunstify --urgency 'normal' --appname "ncmpcpp" \
		--replace 3 --icon ${tmp_cover_path} ${current_title} ${current_artist}
	else
		notify-send --urgency "normal" --app-name "ncmpcpp" \
		--icon "$tmp_cover_path" "$current_title" "$current_artist"
	fi
}

# Call to create a notification
if [[ $(get_desktop_env) == "AWESOME" ]]; then
	notify_awesome
else
	notify_non_awesome
fi