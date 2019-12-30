-- Update Music info using mpd/mpc
-- Depends mpd, mpc

local gears = require('gears')
local awful = require('awful')

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/music/icons/'

local album_cover = require('widget.music.content.album-cover')
local prog_bar = require('widget.music.content.progress-bar')
local track_time = require('widget.music.content.track-time')
local song_info = require('widget.music.content.song-info')
local vol_slider = require('widget.music.content.volume-slider')

local mpd_updater = {}

local apps = require('configuration.apps')


-- Update progress bar script
local update_progressbar = "echo $(mpc status " .. " | " .. " awk 'NR==2 { split($4, a); " .. " print a[1]}') " .. " | " .. " tr -d '[\\%\\(\\)]'"


-- Update track_time
local check_music_progress = "echo $(mpc status " .. " | " ..
" awk 'NR==2 { split($3, a," .. ' "/"' .. "); " ..
" print a[1]}') " ..
" | " .. " tr -d '[\\%\\(\\)]'"

-- Check time duration
local check_music_duration = "mpc --format %time% current"

-- Check repeat status
local check_repeat_mode = "mpc status | sed -n '/random/p' | cut -c23-24 | sed 's/^[ \\t]*//'"

-- Check random status
local check_random_mode = " mpc status | sed -n '/random/p' | cut -c37-38 | sed 's/^[ \\t]*//'"


-- Album cover

update_cover = function()

	-- Extract album cover from song
	apps.bins.coverUpdate()


	local cmd = "if [[ -f /tmp/cover.jpg ]]; then print exists; fi"
		awful.spawn.easy_async_with_shell(cmd, function(stdout)
			if (stdout:match("%W")) then
				gears.timer {
					timeout = 1,
					autostart = true,
					call_now = true,
					single_shot = true,
					callback  = function()
						album_cover.cover:set_image(gears.surface.load_uncached('/tmp/cover.jpg'))
					end
				}
			else
				gears.timer {
					timeout = 1,
					autostart = true,
					call_now = true,
					single_shot = true,
					callback  = function()
						album_cover.cover:set_image(gears.surface.load_uncached(PATH_TO_ICONS .. 'vinyl' .. '.svg'))
					end
				}
			end
			collectgarbage('collect')
		end)
	end

-- Update cover every 10 seconds
album_updater = gears.timer {
	timeout = 10,
	autostart = true,
	call_now = true,
	callback  = function()
	update_cover()
	end
}


-- Get the progress percentage of music
update_progress_bar = function()
	awful.spawn.easy_async_with_shell(update_progressbar, function( stdout )
		if stdout ~= nil then
			prog_bar.music_bar:set_value(tonumber(stdout))
		else
			prog_bar.music_bar:set_value(0)
		end
	end)
end


update_time_progress = function()
	-- Update time progress every 5 seconds
	awful.spawn.easy_async_with_shell(check_music_progress, function( stdout )
		if stdout ~= nil then
			track_time.time_status.text = tostring(stdout)
		else
			track_time.time_status.text = tostring("00:00")
		end
	end)

end



update_time_duration = function()
	-- Update time duration on song change
	awful.spawn.easy_async_with_shell(check_music_duration, function( stdout )
		if stdout ~= nil then
			track_time.time_duration.text = tostring(stdout)
		else
			track_time.time_duration.text = tostring("99:59")
		end
	end)
end


update_time_duration = function()
	-- Update time duration on song change
	awful.spawn.easy_async_with_shell(check_music_duration, function( stdout )
		if stdout ~= nil then
			track_time.time_duration.text = tostring(stdout)
		else
			track_time.time_duration.text = tostring("99:59")
		end
	end)
end

update_file = function()
	-- Save the output of "mpc -f %file% current" into a variable after new lines removal
	-- Update file
	awful.spawn.easy_async_with_shell('mpc -f %file% current', function( stdout )
	-- Remove new lines
	file = stdout:gsub('%\n','')
	end)
	-- Return the variable
	return file
end

update_title = function()
	-- Update title
	awful.spawn.easy_async_with_shell('mpc -f %title% current', function( stdout )
    -- Remove new lines
    local title = stdout:gsub('%\n','')
    -- Check if there's alphanumeric characters
		if (stdout:match("%W")) then
		  -- Truncate string
		  if(title:len() > 1) then
				-- Trim file to 26 characters
				title = title:sub(1,26) .. ''
				-- Set title
				song_info.music_title.title:set_text(title)
			else
				-- Define file into a variable
				local file = update_file()
				-- Cut the .mp3 ending
				file = file:sub(1, title:len() - 5) .. ''
				-- Trim file to 26 characters
				file = file:sub(1,26) .. ''
				-- Set title and artist
				song_info.music_title.title:set_text(file)
		  end
		  
		else
			-- Set title
			song_info.music_title.title:set_text("Play Some Music!")
		end
	end)
end

update_artist = function()
	-- Update Artist
	awful.spawn.easy_async_with_shell('mpc -f %artist% current', function( stdout )
		if (stdout:match("%W")) then
      -- Remove new lines
			song_info.music_artist.artist:set_text(stdout:gsub('%\n',''))
		else
			song_info.music_artist.artist:set_text("or play some porn?")
		end
	end)
end


update_volume_slider = function()
  -- mpd volume is set to N/A if `mpc stop` or every after login
  -- so lets call this when play button is pressed to update the value of slider
  awful.spawn.easy_async_with_shell('mpc volume', function(stdout) 
    -- Get the current mpd volume
    vol_slider.vol_slider.value = tonumber(stdout:match('%d+'))
    vol_slider.vol_slider:get_children_by_id('sliderbar')[1].value = tonumber(stdout:match('%d+'))
  end)
end


update_all_content = function()
		
	-- Update progress bar
	update_progress_bar()

	-- Update time progress
	update_time_progress()

	-- Update time duration
	update_time_duration()

	-- Update title
	update_title()

	-- Update artist
	update_artist()

	-- Update album
	update_cover()
end



-- Media Buttons

-- Change Play/Pause Button
-- Check if the song is playing or paused
check_if_playing = function()
  awful.spawn.easy_async_with_shell("mpc status | awk 'NR==2' | grep -o playing", function( stdout )
    if (stdout:match("%W")) then
      require('widget.music.content.media-buttons').play_button_image.play:set_image(gears.surface.load_uncached(PATH_TO_ICONS .. 'pause.svg'))

      -- Update volume slider value
      update_volume_slider()
      
    else
      require('widget.music.content.media-buttons').play_button_image.play:set_image(gears.surface.load_uncached(PATH_TO_ICONS .. 'play.svg'))
    end
  end)
end


check_repeat_status = function()
  -- Update repeat status if it was changed outside the widget
  awful.spawn.easy_async_with_shell(check_repeat_mode, function( stdout )
    if stdout:match("on") then
      require('widget.music.content.media-buttons').repeat_button_image.rep:set_image(gears.surface.load_uncached(PATH_TO_ICONS .. 'repeat-on.svg'))
    else
      require('widget.music.content.media-buttons').repeat_button_image.rep:set_image(gears.surface.load_uncached(PATH_TO_ICONS .. 'repeat-off.svg'))
    end
  end)
end

check_random_status = function()
  -- Update repeat status if it was changed outside the widget
  awful.spawn.easy_async_with_shell(check_random_mode, function( stdout )
    if stdout:match("on") then
      require('widget.music.content.media-buttons').random_button_image.rand:set_image(gears.surface.load_uncached(PATH_TO_ICONS .. 'random-on.svg'))
    else
      require('widget.music.content.media-buttons').random_button_image.rand:set_image(gears.surface.load_uncached(PATH_TO_ICONS .. 'random-off.svg'))
    end
  end)
end



-- Volume slider 
vol_slider.vol_slider:connect_signal(
  'property::value',
  function()
    awful.spawn('mpc volume ' .. vol_slider.vol_slider.value)
    vol_slider.vol_slider_bar:get_children_by_id('sliderbar')[1].value  = tonumber(vol_slider.vol_slider.value)
  end
)


music_play_pause = function()
	awful.spawn('mpc toggle', false)
	check_if_playing()
end

music_next = function()
	awful.spawn('mpc next', false)
end

music_prev = function()
	awful.spawn('mpc prev', false)
end

music_rep = function()
  awful.spawn('mpc repeat', false)
  check_repeat_status()
end

music_rand = function()
  awful.spawn('mpc random', false)
  check_random_status()
end

-- Update time progress every 5 seconds
local update_music_info = gears.timer {
	timeout = 7,
	autostart = true,
	call_now = true,
	callback  = function()

		-- Update progress bar
		update_progress_bar()

		-- Update time progress
		update_time_progress()

		-- Update time duration
		update_time_duration()

		-- Update title
		update_title()

		-- Update artist
		update_artist()

    -- Check if playing or paused
    check_if_playing()

    -- Check repeat status
    check_repeat_status()

    -- Check random status
    check_random_status()

    
	collectgarbage('collect')

end
}



mpd_updater.music_play_pause = music_play_pause
mpd_updater.music_next = music_next
mpd_updater.music_prev = music_prev
mpd_updater.music_rep = music_rep
mpd_updater.music_rand = music_rand
mpd_updater.update_all_content = update_all_content

return mpd_updater
