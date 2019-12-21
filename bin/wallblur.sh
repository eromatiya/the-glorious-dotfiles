#!/bin/bash

# <Constants>
cache_dir="$HOME/.cache/wallblur"
display_resolution=$(echo -n $(xdpyinfo | grep 'dimensions:') | awk '{print $2;}')
# </Constants>


# <Functions>
print_usage () {
	printf "Usage: wallblur [-i "path/to/wallpaper.jpg"]\n\n"
}

err() {
	echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

gen_blurred_seq () {
	notify-send "Building wallblur cache for "$base_filename""

	clean_cache

	wallpaper_resolution=$(identify -format "%wx%h" $wallpaper)

	err " Display resolution is: ""$display_resolution"""
	err " Wallpaper resolution is: $wallpaper_resolution"

	if [ "$wallpaper_resolution" != "$display_resolution" ]
	then
		
		err "Scaling wallpaper to match resolution"
		convert $wallpaper -resize $display_resolution "$cache_dir"/"$filename"0."$extension"
		wallpaper="$cache_dir"/"$filename"0."$extension"
	    	#echo "New wallpaper"
	    fi

	    for i in $(seq 0 1 5)
	    do
	    	blurred_wallaper=""$cache_dir"/"$filename""$i"."$extension""
	    	convert -blur 0x$i $wallpaper $blurred_wallaper
	    	err " > Generating $(basename $blurred_wallaper)"
	    done
	}


do_blur () {
	for i in $(seq 5)
	do
		blurred_wallaper=""$cache_dir"/"$filename""$i"."$extension""
		feh --bg-fill "$blurred_wallaper" 
	done
}

do_unblur () {
	for i in $(seq 5 -1 0)
	do
		blurred_wallaper=""$cache_dir"/"$filename""$i"."$extension""
		feh --bg-fill "$blurred_wallaper" 
	done
}

clean_cache() {
	if [  "$(ls -A "$cache_dir")" ]; then
		err " * Cleaning existing cache"
		rm -r "$cache_dir"/*
	fi
}
# </Functions>

# To get the current wallpaper
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

base_filename=${wallpaper##*/}
extension="${base_filename##*.}"
filename="${base_filename%.*}"

err $wallpaper
err $cache_dir

# Create a cache directory if it doesn't exist
if [ ! -d "$cache_dir" ]; then
	err "* Creating cache directory"
	mkdir -p "$cache_dir"
 else
 	clean_cache
fi

blur_cache=""$cache_dir"/"$filename"0."$extension""

# Generate cached images if no cached images are found
if [ ! -f "$blur_cache" ]
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
		if [ "$prev_state" != "blurred" ];		then
			err " ! Blurring"
			do_blur
		fi
		prev_state="blurred"
	    else #If there are no active windows
	    	if [ "$prev_state" != "unblurred" ]; 	then
	    		err " ! Un-blurring"
	    		do_unblur
	    	fi
	    	prev_state="unblurred"
	    fi
	    sleep 0.3
done
