local naughty = require('naughty')
local awful = require('awful')
local gears = require('gears')

return function(mode)
	awful.spawn.with_line_callback('xdg-user-dir PICTURES', {
		stdout = function(line)
			local screenshot_dir = line .. '/Screenshots/'
			local file_loc = screenshot_dir .. os.date("%Y-%m-%d_%T") .. '.png'
			local maim_command, notif_message

			if (gears.filesystem.dir_readable(screenshot_dir) == nil) then
				gears.filesystem.make_directories(screenshot_dir)
			end

			if (mode == 'full') then
				maim_command = 'maim -u -m 1 '
				notif_message = "Full screenshot saved and copied to clipboard!"

			elseif (mode == 'window') then
				maim_command = 'maim -u -B -i $(xdotool getactivewindow) -m 1 '
				notif_message = "Current window screenshot saved and copied to clipboard!"

			elseif (mode == 'area') then
				maim_command = 'maim -u -s -n -m 1 '
				notif_message = "Area screenshot saved and copied to clipboard!"

			else
				notif_message = "Wrong Argument Used!"
			end

			awful.spawn.easy_async_with_shell(maim_command .. file_loc, function()

				if (gears.filesystem.file_readable(file_loc)) then

					awful.spawn('xclip -selection clipboard -t image/png -i ' .. file_loc)

					local open_image = naughty.action {
						name = 'Open',
							icon_only = false,
					}

					local open_folder = naughty.action {
						name = 'Folder',
							icon_only = false,
					}

					local delete_image = naughty.action {
						name = 'Delete',
							icon_only = false,
					}

					-- Execute the callback when 'Open' is pressed
					open_image:connect_signal('invoked', function()
						awful.spawn('xdg-open ' .. file_loc, false)
					end)

					open_folder:connect_signal('invoked', function()
						awful.spawn('xdg-open ' .. screenshot_dir, false)
					end)

					-- Execute the callback when 'Delete' is pressed
					delete_image:connect_signal('invoked', function()
						awful.spawn('gio trash ' .. file_loc, false)
					end)

					-- Show notification
					naughty.notification ({
						app_name = 'Screenshot Tool',
						icon = file_loc,
						timeout = 10,
						title = '<b>Snap!</b>',
						message = notif_message,
						actions = { open_image, open_folder, delete_image }
					})
					
				end

			end)

		end,
	})

end