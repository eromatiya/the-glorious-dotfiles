local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local naughty = require('naughty') 

local watch = awful.widget.watch
local dpi = require('beautiful').xresources.apply_dpi

local apps = require('configuration.apps')
local clickable_container = require('widget.clickable-container')

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/wifi/icons/'

local interface = 'wlp3s0'
local connected = false
local status = nil
local start_up = true
local essid = 'N/A'
local wifi_strength = 0
local show_no_internet_access = true


local return_button = function()

	local widget =
		wibox.widget {
		{
			id = 'icon',
			image = widget_icon_dir .. 'wifi-strength-off' .. '.svg',
			widget = wibox.widget.imagebox,
			resize = true
		},
		layout = wibox.layout.align.horizontal
	}

	local widget_button = wibox.widget {
		{
			widget,
			margins = dpi(7),
			widget = wibox.container.margin
		},
		widget = clickable_container
	}
	
	widget_button:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					awful.spawn(apps.default.network_manager, false)
				end
			)
		)
	)

	-- Tooltip
	awful.tooltip(
		{
			objects = {widget_button},
			mode = 'outside',
			align = 'right',
			timer_function = function()
				if connected then

					return 'Connected to: ' .. essid .. 
						'\nWiFi-strength: ' .. tostring(wifi_strength) .. '%'
				else

					return 'Wireless network is disconnected'
				end
			end,
			preferred_positions = {'right', 'left', 'top', 'bottom'},
			margin_leftright = dpi(8),
			margin_topbottom = dpi(8)
		}
	)

	local get_essid = function()
		if connected then
			awful.spawn.easy_async_with_shell(
				'iw dev ' .. interface .. ' link',
				function(stdout)
					essid = stdout:match('SSID: (.-)\n')
					if (essid == nil) then
						essid = 'N/A'
					end
				end
			)
		end
	end

	local notify_connection = function()
		if status ~= connected then
			status = connected
			if start_up == false then
				if connected == true then
					-- Update SSID
					awful.spawn.easy_async_with_shell(
						'iw dev ' .. interface .. ' link',
						function(stdout)
							essid = stdout:match('SSID: (.-)\n')
							if essid then
								-- Notify that you're already connected
								naughty.notification({ 
									message = "You are now connected to <b>\"" .. essid .. "\"</b>",
									title = "Connection Established",
									app_name = 'System notification',
									icon = widget_icon_dir .. 'wifi.svg'
								})
								-- Send signals to update wifi and email widget
								awesome.emit_signal('system::wifi_connected')
							end
						end
					)
				else
					-- Notify that you have been disconnected from Wi-Fi
					naughty.notification({ 
						message = "The network connection has been disconnected",
						title = "Connection Disconnected",
						app_name = "System Notification",
						icon = widget_icon_dir .. 'wifi-off.svg'
					})
				end
			end
		end 
	end

	watch(
		[[
		awk 'NR==3 {printf "%3.0f" ,($3/70)*100}' /proc/net/wireless
		]], 
		5,
		function(_, stdout)

			local widget_icon_name = 'wifi-strength'
			
			wifi_strength = tonumber(stdout)

			if (wifi_strength ~= nil) then
				connected = true
				notify_connection()
				local wifi_strength_rounded = math.floor(wifi_strength / 25 + 0.5)
				awful.spawn.easy_async_with_shell(
					[[
					ping -q -w 2 -c2 8.8.8.8 | grep -o "100% packet loss"
					]],
					function(stdout)
						widget_icon_name = widget_icon_name .. '-' .. wifi_strength_rounded
						if stdout and stdout ~= '' then
							widget_icon_name = 'wifi-strength-alert'
							if show_no_internet_access then
								naughty.notification({ 
									message = "Wi-Fi has no internet access",
									title = "Connection Status",
									app_name = "System Notification",
									icon = widget_icon_dir .. widget_icon_name .. '.svg'
								})
								show_no_internet_access = false
							end
						else
							show_no_internet_access = true
						end

						widget.icon:set_image(widget_icon_dir .. widget_icon_name .. '.svg')
					
					end
				)
			else
				connected = false
				notify_connection()
				widget.icon:set_image(widget_icon_dir .. widget_icon_name .. '-off' .. '.svg')
			end

			-- Update essid
			if (connected and (essid == 'N/A' or essid == nil)) then
				get_essid()
			end

			-- Using this as condition for notify_connection()
			-- So we don't have a notification every after awesome (re)-start
			if start_up then
				start_up = false
			end
			collectgarbage('collect')
		end
	)

	widget:connect_signal(
		'mouse::enter',
		function()
			get_essid()
		end
	)

	return widget_button

end


return return_button