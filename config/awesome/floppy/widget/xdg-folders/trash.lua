local wibox = require('wibox')
local awful = require('awful')
local naughty = require('naughty')
local gears = require('gears')

local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/xdg-folders/icons/'

local create_widget = function()
	local trash_widget = wibox.widget {
		{
			id = 'trash_icon',
			image = widget_icon_dir .. 'user-trash-empty.svg',
			resize = true,
			widget = wibox.widget.imagebox
		},
		layout = wibox.layout.align.horizontal
	}

	local trash_menu = awful.menu({
		items = {
			{
				'Open trash',
				function()
					awful.spawn.easy_async_with_shell(
						'gio open trash:///', 
						function(stdout) end,
						1
					) 
				end,
				widget_icon_dir .. 'open-folder.svg'
			},
			{
				'Delete forever', 
				{
					{
						'Yes',
						function()
							awful.spawn.easy_async_with_shell(
								'gio trash --empty',
								function(stdout) 
								end,
								1
							)
						end,
						widget_icon_dir .. 'yes.svg'
					},
					{
						'No',
						'',
						widget_icon_dir .. 'no.svg'
					}
				},
				widget_icon_dir .. 'user-trash-empty.svg'
			},
		}
	})

	local trash_button = wibox.widget {
		{
			trash_widget,
			margins = dpi(10),
			widget = wibox.container.margin
		},
		widget = clickable_container
	}

	-- Tooltip for trash_button
	trash_tooltip = awful.tooltip {
		objects = {trash_button},
		mode = 'outside',
		align = 'right',
		markup = 'Trash',
		margin_leftright = dpi(8),
		margin_topbottom = dpi(8),
		preferred_positions = {'top', 'bottom', 'right', 'left'}
	}

	-- Mouse event for trash_button
	trash_button:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					awful.spawn({'gio', 'open', 'trash:///'}, false)
				end
			),
			awful.button(
				{},
				3,
				nil,
				function()
					trash_menu:toggle() 
					trash_tooltip.visible = not trash_tooltip.visible
				end
			)
		)
	)

	-- Update icon on changes
	local check_trash_list = function()
		awful.spawn.easy_async_with_shell(
			'gio list trash:/// | wc -l',
			function(stdout) 
				if tonumber(stdout) > 0 then
					trash_widget.trash_icon:set_image(widget_icon_dir .. 'user-trash-full.svg')

					awful.spawn.easy_async_with_shell(
						'gio list trash:///',
						function(stdout)
							trash_tooltip.markup = '<b>Trash contains:</b>\n' .. stdout:gsub('\n$', '')
						end
					)
				else
					trash_widget.trash_icon:set_image(widget_icon_dir .. 'user-trash-empty.svg')
					trash_tooltip.markup = 'Trash empty'
				end
			end
		)
	end

	-- Check trash on awesome (re)-start
	check_trash_list()

	-- Kill the old process of gio monitor trash:///
	awful.spawn.easy_async_with_shell(
		'ps x | grep \'gio monitor trash:///\' | grep -v grep | awk \'{print  $1}\' | xargs kill',
		function() 
			awful.spawn.with_line_callback(
				'gio monitor trash:///',
				{
					stdout = function(_)
						check_trash_list()
					end
				}
			)
		end
	)

	return trash_button
end

return create_widget
