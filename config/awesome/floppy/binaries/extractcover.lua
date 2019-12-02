-- Extract album cover from song
-- Will used by music/mpd widget
-- Depends ffmpeg or perl-image-exiftool, song with hard-coded album cover

local awful = require('awful')

local extract = {}

local extract_cover = function()
  local extract_script = [[
  MPD_MUSIC_PATH="$HOME/Music"
  TMP_COVER_PATH="/tmp/cover.jpg"
  temp_song="/tmp/current-song"
  coverExtractingPackage=$(command -v exiftool)

  if [ -f $TMP_COVER_PATH]; then
    rm $TMP_COVER_PATH
  fi


  # NOTE: ALBUM COVER EXTRACTION WORKS ONLY with
  # MEDIA WITH HARDCODED ALBUM COVER

  # If you want to extract the song's image album cover
  # without copying the song to /tmp then use Exiftool
  # Package name Perl-Image-Exiftool in Arch
  # Else Use FFMpeg and copy song to /tmp then extract cover
  # using FFMPEG
  if [ -z '$coverExtractingPackage' ]
  then
    # USE FFMPEG AND THE COPY SONG TO TEMP TECHNIQUE
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
    
  else
    # USE EXIFTOOL COMMAND TO EXTRACT IMAGE
    exiftool -b -Picture "$MPD_MUSIC_PATH/$(mpc -p 6600 --format "%file%" current)" > "$TMP_COVER_PATH"

    # Resize image
    convert "$TMP_COVER_PATH" -resize 300x300! -quality 100 "$TMP_COVER_PATH"
  fi

  # Delete the cover.jpg if its 0KB (it means there's no extracted album cover)
  if [ 0 -eq $(wc -c < $TMP_COVER_PATH) ]; then
    rm $TMP_COVER_PATH
  fi

  ]]

  awful.spawn.easy_async_with_shell(extract_script, function(stderr) end, false)
end


extractit = function()
  extract_cover()
end

extract.extractalbum = extractit

return extract
