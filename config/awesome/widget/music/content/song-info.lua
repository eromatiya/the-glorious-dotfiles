local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi


local song_info = {}


music_title = wibox.widget {
    layout = wibox.layout.align.horizontal,
    expand = 'none',
    nil,
	{
		{
			id = 'title',
			text = 'The song title is here',
			font = 'SF Pro Text Bold 12',
			align  = 'center',
			valign = 'center',
			ellipsize = 'end',
			widget = wibox.widget.textbox
		},
		id = 'scroll_container',
        max_size = 345,
        speed = 75,
        expand = true,
        direction = 'h',
        step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
        layout = wibox.container.scroll.horizontal,
        fps = 60
	},
	nil
}


music_artist = wibox.widget {
    layout = wibox.layout.align.horizontal,
    expand = 'none',
    nil,
	{
		{
			id = 'artist',
			text = 'The artist name is here',
			font = 'SF Pro Text 9',
			align  = 'center',
			valign = 'center',
			widget = wibox.widget.textbox
		},
		id = 'scroll_container',
        max_size = 345,
        speed = 75,
        expand = true,
        direction = 'h',
        step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
        layout = wibox.container.scroll.horizontal,
        fps = 60
	},
	nil,
}


music_info = wibox.widget {
	expand = 'none',
	layout = wibox.layout.fixed.vertical,
	music_title,
	music_artist,
}


song_info.music_title = music_title
song_info.music_artist = music_artist
song_info.music_info = music_info


return song_info