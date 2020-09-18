local wibox = require('wibox')
local dpi = require('beautiful').xresources.apply_dpi

local song_info = {}

song_info.music_title = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    expand = 'none',
	{
		{
			id = 'title',
			text = 'title',
			font = 'Inter Bold 10',
			align  = 'left',
			valign = 'center',
			ellipsize = 'end',
			widget = wibox.widget.textbox
		},
		id = 'scroll_container',
        max_size = 150,
        speed = 75,
        expand = true,
        direction = 'h',
        step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
        fps = 60,
        layout = wibox.container.scroll.horizontal
	}
}

song_info.music_artist = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    expand = 'none',
	{
		{
			id = 'artist',
			text = 'artist',
			font = 'Inter Regular 10',
			align  = 'left',
			valign = 'center',
			widget = wibox.widget.textbox
		},
		id = 'scroll_container',
        max_size = 150,
        speed = 75,
        expand = true,
        direction = 'h',
        step_function = wibox.container.scroll
        				.step_functions.waiting_nonlinear_back_and_forth,
        fps = 60,
        layout = wibox.container.scroll.horizontal
	}
}

song_info.music_info = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		layout = wibox.layout.fixed.vertical,
		song_info.music_title,
		song_info.music_artist
	},
	nil
}

return song_info
