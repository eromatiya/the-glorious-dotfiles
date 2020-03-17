-------------------------------------------------
-- WiFi Widget for Awesome Window Manager
-- Shows the wifi status using some magic
-- Make sure to change the wireless interface
-- See `ifconfig` or `iwconfig`
-------------------------------------------------

local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local naughty = require('naughty') 

local watch = awful.widget.watch

local apps = require('configuration.apps')

local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widget.clickable-container')

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/wifi/icons/'

local interface = 'wlp3s0'
local connected = false
local status = nil
local start_up = true
local essid = 'N/A'
local wifi_strength = 0


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

	-- Get ESSID
	local get_essid = function()
		if connected then
			awful.spawn.easy_async(
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


	-- Notify the change in connection status
	local notify_connection = function()

		if status ~= connected then
			status = connected

			if start_up == false then
				if connected == true then

					-- Update SSID
					awful.spawn.easy_async(
						'iw dev ' .. interface .. ' link',
						function(stdout)
							essid = stdout:match('SSID: (.-)\n')
							if essid then

								-- Notify that you're already connected
								naughty.notification({ 
									message = 'You are now connected to the Wi-Fi network:\n<b>"' .. essid .. '"</b>.',
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

					-- Notify that you're currently disconnected
					naughty.notification({ 
						message = "The network connection has been disconnected.",
						title = "WiFi Connection",
						app_name = "System Notification",
						icon = widget_icon_dir .. 'wifi-off.svg'
					})
				end
			end
		end 
	end


	-- Get wifi strenth bash script
	local get_wifi_strength = [[
	awk 'NR==3 {printf "%3.0f" ,($3/70)*100}' /proc/net/wireless
	]]

	watch(
		get_wifi_strength, 
		5,
		function(_, stdout)
			local widget_icon_name = 'wifi-strength'
			
			wifi_strength = tonumber(stdout)

			if (wifi_strength ~= nil) then
				connected = true
			
				-- Create a notification
				notify_connection()
			
				-- Get wifi wifi_strength
				local wifi_strength_rounded = math.floor(wifi_strength / 25 + 0.5)
				widget_icon_name = widget_icon_name .. '-' .. wifi_strength_rounded
			
				-- Update wifi strength icon
				widget.icon:set_image(widget_icon_dir .. widget_icon_name .. '.svg')
			
			else
				connected = false
			
				-- Create a notification
				notify_connection()
			
				-- Update wifi strength to off
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

			-- Cleanup memory
			collectgarbage('collect')
		end
	)

	-- Tooltip text update
	widget:connect_signal(
		'mouse::enter',
		function()
			get_essid()
		end
	)

	return widget_button

end


return return_button