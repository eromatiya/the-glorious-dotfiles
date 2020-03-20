local awful = require('awful')
local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')
local naughty = require('naughty')

local watch = awful.widget.watch

local apps = require('configuration.apps')

local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/battery/icons/'


local return_button = function()

	local battery_imagebox = wibox.widget {
		nil,
		{
			id = 'icon',
			image = widget_icon_dir .. 'battery-standard' .. '.svg',
			widget = wibox.widget.imagebox,
			resize = true
		},
		nil,
		expand = 'none',
		layout = wibox.layout.align.vertical
	}

	local battery_percentage_text = wibox.widget {
		id = 'percent_text',
		text = '100%',
		font = 'SF Pro Text Bold 11',
		align = 'center',
		valign = 'center',
		visible = false,
		widget = wibox.widget.textbox
	}


	local battery_widget = wibox.widget {
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(0),
		battery_imagebox,
		battery_percentage_text
	}


	local battery_button = wibox.widget {
		{
			battery_widget,
			margins = dpi(7),
			widget = wibox.container.margin
		},
		widget = clickable_container
	}

	battery_button:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					awful.spawn(apps.default.power_manager , false)
				end
			)
		)
	)

	local battery_tooltip =  awful.tooltip
	{
		objects = {battery_button},
		text = 'None',
		mode = 'outside',
		align = 'right',
		margin_leftright = dpi(8),
		margin_topbottom = dpi(8),
		preferred_positions = {'right', 'left', 'top', 'bottom'}
	}

	-- Get battery info script
	local get_battery_info = function()
		awful.spawn.easy_async_with_shell('upower -i $(upower -e | grep BAT)', function(stdout)

			if not stdout:match('%W') then
				battery_tooltip:set_text('No battery detected!')
				return
			end

			-- Remove new line from the last line
			battery_tooltip:set_text(stdout:sub(1, -2))
		end)
	end

	-- Update tooltip on startup
	get_battery_info()

	-- Update tooltip on hover
	battery_widget:connect_signal('mouse::enter', function() 
		get_battery_info()
	end)


	local check_percentage_cmd = [[
	upower -i $(upower -e | grep BAT) | grep percentage | awk '{print $2}' | tr -d '\n%'
	]]

	local check_status_cmd = [[bash -c "
	upower -i $(upower -e | grep BAT) | grep state | awk '{print $2}' | tr -d '\n'
	"]]

	local last_battery_check = os.time()
	local notify_critcal_battery = true

    local function show_battery_warning()
        naughty.notification ({
            icon = widget_icon_dir .. 'battery-alert.svg',
            app_name = 'System notification',
            title = 'Battery is dying!',
            message = 'Hey, I think we have a problem here. Save your work before reaching the oblivion.',
            urgency = 'critical'
        })
    end

	local update_battery = function(status)

		local status = status:gsub('%\n', '')

		awful.spawn.easy_async_with_shell(check_percentage_cmd, function(stdout)

			local battery_percentage = tonumber(stdout)

			battery_widget.spacing = dpi(5)
			battery_percentage_text.visible = true
			battery_percentage_text:set_text(battery_percentage .. '%')

			local icon_name = 'battery'


			if status:match('discharging') then

				if battery_percentage >= 0 and battery_percentage < 10 then

					icon_name = icon_name .. '-' .. 'alert-red'

					if os.difftime(os.time(), last_battery_check) > 300 or notify_critcal_battery then
						last_battery_check = os.time()
						notify_critcal_battery = false
						show_battery_warning()
					end
				 
				elseif battery_percentage > 10 and battery_percentage < 20 then

					icon_name = icon_name .. '-' .. '10'

				elseif battery_percentage >= 20 and battery_percentage < 30 then

					icon_name = icon_name .. '-' .. '20'

				elseif battery_percentage >= 30 and battery_percentage < 50 then

					icon_name = icon_name .. '-' .. '30'

				elseif battery_percentage >= 50 and battery_percentage < 60 then

					icon_name = icon_name .. '-' .. '50'

				elseif battery_percentage >= 60 and battery_percentage < 80 then

					icon_name = icon_name .. '-' .. '60'

				elseif battery_percentage >= 80 and battery_percentage < 90 then

					icon_name = icon_name .. '-' .. '80'

				elseif battery_percentage >= 90 and battery_percentage < 100 then

					icon_name = icon_name .. '-' .. '90'

				elseif battery_percentage == 100 then

					icon_name = icon_name .. '-' .. status .. battery_percentage
				end

			elseif status:match('charging') or status:match('fully') then

				if battery_percentage > 0 and battery_percentage < 20 then

					icon_name = icon_name .. '-' .. status .. '-' .. '10'

				elseif battery_percentage >= 20 and battery_percentage < 30 then

					icon_name = icon_name .. '-' .. status .. '-' .. '20'

				elseif battery_percentage >= 30 and battery_percentage < 50 then

					icon_name = icon_name .. '-' .. status .. '-' .. '30'

				elseif battery_percentage >= 50 and battery_percentage < 60 then

					icon_name = icon_name .. '-' .. status .. '-' .. '50'

				elseif battery_percentage >= 60 and battery_percentage < 80 then

					icon_name = icon_name .. '-' .. status .. '-' .. '60'

				elseif battery_percentage >= 80 and battery_percentage < 90 then

					icon_name = icon_name .. '-' .. status .. '-' .. '80'

				elseif battery_percentage >= 90 and battery_percentage < 100 then

					icon_name = icon_name .. '-' .. status .. '-' .. '90'

				elseif battery_percentage == 100 then

					icon_name = icon_name .. '-' .. status
				end

			end

			-- Debugger ;)
			-- naughty.notification({message=widget_icon_dir .. icon_name .. '.svg'})

			battery_imagebox.icon:set_image(gears.surface.load(widget_icon_dir .. icon_name .. '.svg'))

			collectgarbage('collect')
		end)
	end

	-- Watch status if charging, discharging, fully-charged
	watch(check_status_cmd, 5, function(widget, stdout)

		-- If no output or battery detected
		if not stdout:match('%W') then

			battery_widget.spacing = dpi(0)
			battery_percentage_text.visible = false

			battery_tooltip:set_text('No battery detected!')
			battery_imagebox.icon:set_image(gears.surface.load(widget_icon_dir .. 'battery-unknown' .. '.svg'))
			
			return
		
		end

		update_battery(stdout)

	end)

	return battery_button


end


return return_button