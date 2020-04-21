#!/usr/bin/env bash


# Configuration
CACHE_DIR="${HOME}/.cache/wallblur"
DISPLAY_RES="$(echo -n "$(xdpyinfo | grep 'dimensions')" | awk '{print $2;}')"


# Usage

print_usage () {
	printf "Usage:\nwall-blur.sh -i \"path/to/wallpaper.1jpg\"\n"
}

print_err () {
	echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}


gen_blurred_seq () {
	notify-send "Building wallpaper blur cache for ${base_filename}"

	clean_cache

	wallpaper_resolution=$(identify -format "%wx%h" "$wallpaper")

	print_err "Display resolution is: ${DISPLAY_RES}"
	print_err "Wallpaper resolution is: ${WALL_RES}"

	if [ "$WALL_RES" != "$DISPLAY_RES" ]
	then
		print_err "Scaling wallpaper to match screen resolution"
		convert "$wallpaper" -resize "$DISPLAY_RES" "${CACHE_DIR}/${filename}0.${extension}"
		wallpaper="${CACHE_DIR}/${filename}0.${extension}"
	fi

	for i in $(seq 0 1 5)
	do
		blurred_wallpaper="${CACHE_DIR}/${filename}${i}.${extension}"
		convert -blur 0x${i} "$wallpaper" "$blurred_wallpaper"
	done
}

do_blur () {
	for i in $(seq 5)
	do
		blurred_wallpaper="${CACHE_DIR}/${filename}${i}.${extension}"
		feh --bg-fill "$blurred_wallpaper"
	done
}

do_unblur () {
	for i in $(seq 5 -1 0)
	do
		blurred_wallpaper="${CACHE_DIR}/${filename}${i}.${extension}"
		feh --bg-fill "$blurred_wallpaper"
	done
}

clean_cache() {
	if [  "$(ls -A "$CACHE_DIR")" ]; then
		print_err "* Cleaning existing cache"
		rm -r "$CACHE_DIR"/*
	fi
}

# Get the current wallpaper
i_option=''
while getopts ":i:d:" flag; do
	case "${flag}" in
		i) i_option="${OPTARG}";;
		:) print_usage 
		   exit 1;;
		*) print_usage 
		   exit 1;;
	esac
done

# Check to make sure an option is given
if [[ -z "$i_option" ]]; then
	printf "\nPlease specify a wallpaper\n\n"
	print_usage
	exit 1
fi

wallpaper="$i_option"

base_filename="${wallpaper##*/}"
extension="${base_filename##*.}"
filename="${base_filename%.*}"

print_err $wallpaper
print_err $CACHE_DIR

# Create a cache directory if it doesn't exist
if [ ! -d "$CACHE_DIR" ]; then
	err "* Creating cache directory"
	mkdir -p "$CACHE_DIR"
 else
 	clean_cache
fi

blur_cache="${CACHE_DIR}/${filename}0.${extension}"

# Generate cached images if no cached images are found
if [ ! -f "${blur_cache}" ]
then
	gen_blurred_seq
fi

prev_state="reset"

while :; do
	current_workspace="$(xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}')"
	num_windows="$(echo "$(wmctrl -l)" | awk -F" " '{print $2}' | grep ^$current_workspace)"
	# If there are active windows
	if [ -n "$num_windows" ]
	then
		if [ "$prev_state" != "blurred" ]
		then
			print_err " ! Blurring"
			do_blur
		fi
		prev_state="blurred"
	else #If there are no active windows
	   	if [ "$prev_state" != "unblurred" ]
	   	then
	   		print_err " ! Un-blurring"
	   		do_unblur
	   	fi
	   	prev_state="unblurred"
	fi
	sleep 0.3
done
# printf "${DISPLAY_RES}"
# print_usage