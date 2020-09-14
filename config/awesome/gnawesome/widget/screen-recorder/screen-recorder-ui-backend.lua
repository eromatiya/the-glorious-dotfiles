local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')
local naughty = require('naughty')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/screen-recorder/icons/'

-- The screen-recorders scripting 
local screen_rec_backend = require('widget.screen-recorder.screen-recorder-scripts')

-- The screen-recorder's UI
local screen_rec_ui = require('widget.screen-recorder.screen-recorder-ui')

-- User Preferences 
local sr_user_resolution = screen_rec_backend.user_resolution
local sr_user_offset = screen_rec_backend.user_offset
local sr_user_audio = screen_rec_backend.user_audio
local sr_user_update = screen_rec_backend.update_user_settings

-- Panel UIs
local sr_toggle_imgbox = screen_rec_ui.screen_rec_toggle_imgbox
local sr_toggle_button = screen_rec_ui.screen_rec_toggle_button
local sr_countdown_text = screen_rec_ui.screen_rec_countdown_txt
local sr_main_imgbox = screen_rec_ui.screen_rec_main_imgbox
local sr_main_button = screen_rec_ui.screen_rec_main_button
local sr_audio_imgbox = screen_rec_ui.screen_rec_audio_imgbox
local sr_audio_button = screen_rec_ui.screen_rec_audio_button
local sr_settings_button = screen_rec_ui.screen_rec_settings_button
local sr_close_button = screen_rec_ui.screen_rec_close_button


-- Settings UIs
local sr_back_button = screen_rec_ui.screen_rec_back_button
local sr_resolution_box = screen_rec_ui.screen_rec_res_txtbox
local sr_offset_box = screen_rec_ui.screen_rec_offset_txtbox
local sr_resolution_tbox = sr_resolution_box:get_children_by_id('res_tbox')[1]
local sr_offset_tbox = sr_offset_box:get_children_by_id('offset_tbox')[1]


-- Main Scripts
local sr_start_recording = screen_rec_backend.start_recording
local sr_stop_recording = screen_rec_backend.stop_recording

-- Active Screen Recorder
local sr_screen = nil

-- Active textbox
local sr_active_tbox = nil


-- Status variables
local status_countdown = false
local status_recording = false
local status_audio = sr_user_audio


-- Update UI on startup using the user config
sr_resolution_tbox:set_markup('<span foreground="#FFFFFF66">' .. sr_user_resolution .. "</span>")
sr_offset_tbox:set_markup('<span foreground="#FFFFFF66">' .. sr_user_offset .. "</span>")

local sr_res_default_markup = sr_resolution_tbox:get_markup()
local sr_offset_default_markup = sr_offset_tbox:get_markup()


if status_audio then
	sr_audio_button.bg = '#EE4F84' .. '66'
else
	sr_audio_button.bg = beautiful.groups_bg
end

-- Textbox ui manipulators
local emphasize_inactive_tbox = function()
	if sr_active_tbox == 'res_tbox' then
		sr_resolution_box.shape_border_width = dpi(0)
		sr_resolution_box.shape_border_color = beautiful.transparent
	elseif sr_active_tbox == 'offset_tbox' then
		sr_offset_box.shape_border_width = dpi(0)
		sr_offset_box.shape_border_color = beautiful.transparent
	end
	sr_active_tbox = nil
end

local emphasize_active_tbox = function()
	if sr_active_tbox == 'res_tbox' then
		sr_resolution_box.border_width = dpi(1)
		sr_resolution_box.border_color = '#F2F2F2AA'
	elseif sr_active_tbox == 'offset_tbox' then
		sr_offset_box.border_width = dpi(1)
		sr_offset_box.border_color = '#F2F2F2AA'
	end
end

-- Delete, reset and write to the textbox
local write_to_textbox = function(char)
	if sr_active_tbox == 'res_tbox' and (char:match('%d') or char == 'x') then
		if sr_resolution_tbox:get_markup() == sr_res_default_markup then
			sr_resolution_tbox:set_text('')
		end
		if tonumber(#sr_resolution_tbox:get_text()) <= 8 then
			sr_resolution_tbox:set_text(sr_resolution_tbox:get_text() .. char)
		end
	elseif sr_active_tbox == 'offset_tbox' and (char:match('%d') or char == ',') then
		if sr_offset_tbox:get_markup() == sr_offset_default_markup then
			sr_offset_tbox:set_text('')
		end
		sr_offset_tbox:set_text(sr_offset_tbox:get_text() .. char)
	end
end

local reset_textbox = function()
	if sr_active_tbox == 'res_tbox' then
		sr_resolution_tbox:set_markup(sr_res_default_markup)
	elseif sr_active_tbox == 'offset_tbox' then
		sr_offset_tbox:set_markup(sr_offset_default_markup)
	end
	emphasize_inactive_tbox()
end

-- Set audio mode
local sr_audio_mode = function()
	if not status_recording and not status_countdown then
		if status_audio then
			status_audio = false
			sr_audio_button.bg = beautiful.groups_bg
		else
			status_audio = true
			sr_audio_button.bg = '#EE4F84' .. '66'
		end
	end
end

local delete_key = function()
	if sr_active_tbox == 'res_tbox' then
		if tonumber(#sr_resolution_tbox:get_text()) == 1 then
			reset_textbox()
			return
		end
		sr_resolution_tbox:set_text(sr_resolution_tbox:get_text():sub(1, -2))
	elseif sr_active_tbox == 'offset_tbox' then
		if tonumber(#sr_offset_tbox:get_text()) == 1 then
			reset_textbox()
			return
		end
		sr_offset_tbox:set_text(sr_offset_tbox:get_text():sub(1, -2))
	end
end

local apply_new_settings = function()	

	-- Get the text on texbox
	sr_user_resolution = sr_resolution_tbox:get_text()
	sr_user_offset = sr_offset_tbox:get_text()

	-- Apply new settings
	sr_user_update(sr_user_resolution, sr_user_offset, status_audio)

	-- Debugger
	screen_rec_backend.check_settings()
end

-- Settings Key grabber
local settings_updater = awful.keygrabber {
	auto_start          = true,
	stop_event          = 'release',
	keypressed_callback = function(self, mod, key, command)
		if key == 'BackSpace' then
			delete_key()
		end
	end,
	keyreleased_callback = function(self, mod, key, command)
		if key == 'Return' then
			apply_new_settings()
			self:stop()
		end

		if key == 'Escape' then
			self:stop()
			reset_textbox()
		end

		if key:match('%d') or key == 'x' or key == ',' then
			write_to_textbox(key)
		end

	end
}

-- Textboxes
sr_resolution_tbox:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				emphasize_inactive_tbox()
				sr_active_tbox = 'res_tbox'
				emphasize_active_tbox()
				settings_updater:start()
			end
		)
	)
)

sr_offset_tbox:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				emphasize_inactive_tbox()
				sr_active_tbox = 'offset_tbox'
				emphasize_active_tbox()
				settings_updater:start()
			end
		)
	)
)

-- UI switcher
local sr_navigation_reset = function()
	if sr_screen then
		local recorder_panel = sr_screen:get_children_by_id('recorder_panel')[1]
		local recorder_settings = sr_screen:get_children_by_id('recorder_settings')[1]
		recorder_settings.visible = false
		recorder_panel.visible = true
	end
end

local sr_navigation = function()
	if sr_screen then
		local recorder_panel = sr_screen:get_children_by_id('recorder_panel')[1]
		local recorder_settings = sr_screen:get_children_by_id('recorder_settings')[1]
		if recorder_panel.visible then
			recorder_panel.visible = false
			recorder_settings.visible = true
		else
			recorder_settings.visible = false
			recorder_panel.visible = true
		end
	end
end

sr_settings_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				if not status_recording and not status_countdown then
					sr_navigation()
				end
			end
		)
	)
)

sr_back_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()

				-- Save settings
				apply_new_settings()

				-- Reset textbox UI
				emphasize_inactive_tbox()

				-- Go back to UI Panel
				sr_navigation()
			end
		)
	)
)

-- Close button functions and buttons
local screen_rec_close = function()

	for s in screen do
		s.recorder_screen.visible = false
	end
	settings_updater:stop()
	sr_navigation_reset()
	sr_screen = nil
end

sr_close_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				screen_rec_close()
			end
		)
	)
)

-- Right click to exit
local screen_close_on_rmb = function(widget)
	widget:buttons(
		gears.table.join(
			awful.button(
				{},
				3,
				nil,
				function()
					screen_rec_close()
				end
			)
		)
	)
end

-- Open recorder screen
sr_toggle_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				for s in screen do
					s.recorder_screen.visible = false
				end
				sr_screen = awful.screen.focused().recorder_screen
				screen_close_on_rmb(sr_screen)
				sr_screen.visible = not sr_screen.visible
			end
		)
	)
)

-- Start Recording
local sr_recording_start = function()
	status_countdown = false
	status_recording = true
	local sr_screen = awful.screen.focused().recorder_screen

	-- Hide recorder screen
	sr_screen.visible = false

	-- Manipulate UIs
	sr_toggle_imgbox:set_image(widget_icon_dir .. 'recording-button' .. '.svg')
	sr_main_imgbox:set_image(widget_icon_dir .. 'recorder-on' .. '.svg')

	sr_start_recording(status_audio)
end

-- Stop Recording
local sr_recording_stop = function()
	status_recording = false
	status_audio = false

	-- Manipulate UIs
	sr_toggle_imgbox:set_image(widget_icon_dir .. 'start-recording-button' .. '.svg')
	sr_main_imgbox:set_image(widget_icon_dir .. 'recorder-off' .. '.svg')
	sr_stop_recording()
end

awesome.connect_signal(
	'widget::screen_recorder',
	function()
		sr_recording_stop()
	end
)

-- Countdown timer functions
local countdown_timer = nil
local counter_timer = function()
	status_countdown = true
	local seconds = 3
	countdown_timer = gears.timer.start_new(
		1, 
		function()
			if seconds == 0 then
				sr_countdown_text.opacity = 0.0

				--  Start recording function
				sr_recording_start()
				sr_countdown_text:emit_signal('widget::redraw_needed')
				return false 
			else
				sr_main_imgbox:set_image(widget_icon_dir .. 'recorder-countdown' .. '.svg')
				sr_countdown_text.opacity = 1.0
				sr_countdown_text:set_text(tostring(seconds))
				sr_countdown_text:emit_signal('widget::redraw_needed')
			end
			seconds = seconds - 1
			return true
		end
	)
end

-- Stop Countdown timer
local sr_countdown_stop = function()
	countdown_timer:stop()
	status_countdown = false
	sr_main_imgbox:set_image(widget_icon_dir .. 'recorder-off' .. '.svg')
	sr_countdown_text.opacity = 0.0
	sr_countdown_text:emit_signal('widget::redraw_needed')
end

sr_audio_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				sr_audio_mode()
			end
		)
	)
)

-- Main button functions and buttons
local status_checker = function()
	if status_recording and not status_countdown then

		-- Stop recording
		sr_recording_stop()
		return
	elseif not status_recording and status_countdown then
		
		-- Stop timer
		sr_countdown_stop()
		return
	end

	-- Start counting down
	counter_timer()
end

sr_main_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				status_checker()
			end
		)
	)
)
