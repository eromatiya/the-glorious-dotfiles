local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi
local song_info = {}

song_info.music_title = wibox.widget {
    layout = wibox.layout.align.horizontal,
    expand = 'none',
    nil,
	{
		{
			id = 'title',
			text = 'The song title is here',
			font = 'Inter Bold 12',
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
        step_function = wibox.container.scroll
        					.step_functions.waiting_nonlinear_back_and_forth,
        fps = 60,
        layout = wibox.container.scroll.horizontal
	},
	nil
}

song_info.music_artist = wibox.widget {
    layout = wibox.layout.align.horizontal,
    expand = 'none',
    nil,
	{
		{
			id = 'artist',
			text = 'The artist name is here',
			font = 'Inter 10',
			align  = 'center',
			valign = 'center',
			widget = wibox.widget.textbox
		},
		id = 'scroll_container',
        max_size = 345,
        speed = 75,
        expand = true,
        direction = 'h',
        step_function = wibox.container.scroll
        					.step_functions.waiting_nonlinear_back_and_forth,
        layout = wibox.container.scroll.horizontal,
        fps = 60
	},
	nil
}

song_info.music_info = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	song_info.music_title,
	song_info.music_artist
}

return song_info
