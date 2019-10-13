#!/usr/bin/env bash

MPD_MUSIC_PATH="/home/gerome/Music"
TMP_COVER_PATH="/tmp/cover.jpg"
temp_song="/tmp/current-song"
coverExtractingPackage=$(which exiftool)

function Album-Cover-Notif() {
  isDunst=$(which dunstify > /dev/null 2>&1)
  if [ ! -z $isDunst ]
  then
    dunstify --appname 'nmpcpp' --replace 3 --icon $TMP_COVER_PATH "$(mpc -f %title% current)" "$(mpc -f %artist% current)"
  else
    notify-send -i $TMP_COVER_PATH $(mpc -f %title% current) $(mpc -f %artist% current)
  fi

}
#NOTE: ALBUM COVER EXTRACTION WORKS ONLY with
#MEDIA WITH HARDCODED ALBUM COVER

#If you want to extract the song's image album cover
#without copying the song to /tmp then use Exiftool
#Package name Perl-Image-Exiftool in Arch
#Else Use FFMpeg and copy song to /tmp then extract cover
#using FFMPEG
if [ -z '$coverExtractingPackage' ]
then
  #USE FFMPEG AND THE COPY SONG TO TEMP TECHNIQUE
  # having issues escaping spaces in the path
  cp "$MPD_MUSIC_PATH/$(mpc --format %file% current)" "$temp_song"

  ffmpeg \
    -hide_banner \
    -loglevel 0 \
    -y \
    -i "$temp_song" \
    -vf scale=300:-1 \
    "$TMP_COVER_PATH" > /dev/null 2>&1

  rm "$temp_song"

  eval "kitty +kitten icat --clear"
  eval "kitty +kitten icat --transfer-mode stream --place 25x25@0x0 $TMP_COVER_PATH"
  Album-Cover-Notif
else

  #USE EXIFTOOL COMMAND TO EXTRACT IMAGE
  exiftool -b -Picture "$MPD_MUSIC_PATH/$(mpc -p 6600 --format "%file%" current)" > "$TMP_COVER_PATH"
  eval "kitty +kitten icat --clear"
  eval "kitty +kitten icat --transfer-mode stream --place 25x25@0x0 $TMP_COVER_PATH"
  Album-Cover-Notif
fi
