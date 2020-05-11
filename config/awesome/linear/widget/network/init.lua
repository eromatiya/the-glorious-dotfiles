----------------------------------------------------------------------------
--- Simple Network Widget
--
-- Depends: iproute2, iw
--
-- For more details check `man maim`
--
-- @author manilarome &lt;gerome.matilla07@gmail.com&gt;
-- @copyright 2020 manilarome
-- @widget network
----------------------------------------------------------------------------


local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local naughty = require('naughty') 

local dpi = require('beautiful').xresources.apply_dpi

local apps = require('configuration.apps')
local clickable_container = require('widget.clickable-container')

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/network/icons/'

local wlan_interface = 'wlp3s0'
local lan_interface = 'enp0s25'

local return_button = function()

	local wifi_strength = nil

	local connected_to_network = false
	local conn_status = 'disconnected'
	local essid = nil

	local update_notify_no_access = true
	local notify_no_access_quota = 0

	local startup = true
	local notify_new_wifi_conn = false

	local net_speed = 'N/A'

	local widget = wibox.widget {
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

	local notify_not_connected = function()
		local message = 'The network has been disconnected'
		local title = 'Connection Disconnected'

		if conn_status == 'wireless' then
			icon =  widget_icon_dir .. 'wifi-strength-off.svg'
		elseif conn_status == 'wired' then
			icon = widget_icon_dir .. 'wired-off.svg'
		else
			icon =  widget_icon_dir .. 'wifi-strength-off.svg'
		end

		naughty.notification({ 
			message = message,
			title = title,
			app_name = 'System Notification',
			icon = icon
		})

		conn_status = 'disconnected'
	end

	local update_disconnected = function()
		if conn_status == 'wireless' or conn_status == 'wired' then
			
			local widget_icon_name = nil
			
			connected_to_network = false
			notify_new_wifi_conn = true
			essid = nil
			update_notify_no_access = true

			if conn_status == 'wireless' then
				widget_icon_name = 'wifi-strength-off'
			elseif conn_status == 'wired' then
				widget_icon_name = 'wired-off'
			end

			notify_not_connected()
			widget.icon:set_image(widget_icon_dir .. widget_icon_name .. '.svg')
		end
	end

	local notify_no_access = function(strength)
		if conn_status == 'wireless' or conn_status == 'wired' then
						
			local message = 'Internet may not be available or it is too slow right now'

			if conn_status == 'wireless' then
				icon =  widget_icon_dir .. 'wifi-strength-' .. tostring(strength) .. '-alert.svg'
			elseif conn_status == 'wired' then
				icon = widget_icon_dir .. 'wired-off.svg'
			end

			naughty.notification({ 
				message = message,
				title = 'Connection Status',
				app_name = 'System Notification',
				icon = icon
			})

		end
	end

	local update_no_access = function(strength)

		if not update_notify_no_access then
			return
		end

		local widget_icon_name = nil

		if conn_status == 'wireless' then
			widget_icon_name = 'wifi-strength-' .. tostring(strength) .. '-alert'
		elseif conn_status == 'wired' then
			widget_icon_name = 'wired-alert'
		end
		notify_no_access(strength)
		widget.icon:set_image(widget_icon_dir .. widget_icon_name .. '.svg')

		update_notify_no_access = false

	end


	local notify_wifi_conn = function()
		if startup then
			startup = false
			return
		end

		if not notify_new_wifi_conn then
			return
		end

		local message = "You are now connected to <b>\"" .. essid .. "\"</b>"
		local title = "Connection Established"
		local app_name = "System Notification"
		local icon = widget_icon_dir .. 'wifi.svg'

		naughty.notification({ 
			message = message,
			title = title,
			app_name = app_name,
			icon = icon
		})

		notify_new_wifi_conn = false
	end


	local update_essid = function()
		if not essid and connected_to_network == true then
			awful.spawn.easy_async_with_shell(
				[[
				iw dev ]] .. wlan_interface .. [[ link
				]],
				function(stdout)
					essid = stdout:match('SSID: (.-)\n')
					if essid == nil then
						essid = 'N/A'
					end
					notify_wifi_conn()
				end
			)
		end
	end

	local check_internet_health = [[
	status_curl=0
	status_ping=0

	ip="$(curl --connect-timeout 5 ifconfig.co)"
	if expr "$ip" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' >/dev/null; 
	then
		status_curl=1
	else
		status_curl=0
	fi
	
	packets="$(ping -q -w4 -c4 1.1.1.1 | grep -o "100% packet loss")"
	if [ ! -z "${packets}" ];
	then
		status_ping=0
	else
		status_ping=1
	fi

	if [ $status_ping -eq 0 ] && [ $status_curl -eq 0 ];
	then
		echo 'noaccess'
	fi
	]]

	local update_net_speed = function()

		awful.spawn.easy_async_with_shell(
			'iw dev ' .. wlan_interface .. ' link',
			function(stdout)
				net_speed = stdout:match("tx bitrate: (.+/s)") or 'N/A'
			end
		)
	end

	local update_wireless = function()
		conn_status = 'wireless'
		connected_to_network = true
		
		awful.spawn.easy_async_with_shell(
			[[
			awk 'NR==3 {printf "%3.0f" ,($3/70)*100}' /proc/net/wireless
			]],
			function(stdout)

				if not tonumber(stdout) then
					return
				end

				local widget_icon_name = 'wifi-strength'

				wifi_strength = tonumber(stdout)
				
				local wifi_strength_rounded = math.floor(wifi_strength / 25 + 0.5)

				awful.spawn.easy_async_with_shell(
					check_internet_health,
					function(stdout)
						local widget_icon_name = widget_icon_name .. '-' .. wifi_strength_rounded
						if stdout:match('noaccess') then
							update_no_access(wifi_strength_rounded)
							return
						else
							update_net_speed()
							if startup then
								awesome.emit_signal('system::wifi_connected')
							end
							update_notify_no_access = true
						end
						widget.icon:set_image(widget_icon_dir .. widget_icon_name .. '.svg')
					end
				)
			end
		)
		update_essid()
	end

	local update_wired = function()
		conn_status = 'wired'
		connected_to_network = true

		awful.spawn.easy_async_with_shell(
			check_internet_health,
			function(stdout)
				widget_icon_name = 'wired'
				if stdout:match('fail') then
					update_no_access()
					return
				else
					if startup then
						awesome.emit_signal('system::wifi_connected')
						startup = false
					end
					update_notify_no_access = true
				end
				widget.icon:set_image(widget_icon_dir .. widget_icon_name .. '.svg')
			end
		)
		
	end

	awful.tooltip(
		{
			objects = {widget_button},
			mode = 'outside',
			align = 'right',
			timer_function = function()
				if connected_to_network then
					if conn_status == 'wireless' then
						return 'Wireless Interface: <b>' .. wlan_interface .. 
						'</b>\nConnected to: <b>' .. (essid or "*LOADING...*") .. 
						'</b>\nWiFi-Strength: <b>' .. tostring(wifi_strength) .. '%' ..
						'</b>\nBit rate: <b>' .. tostring(net_speed) .. '</b>'
					else
						return 'Ethernet Interface: <b>' .. lan_interface
					end
				else
					return 'Network is currently disconnected'
				end
			end,
			preferred_positions = {'left', 'right', 'top', 'bottom'},
			margin_leftright = dpi(8),
			margin_topbottom = dpi(8)
		}
	)

	gears.timer {
		timeout = 9,
		autostart = true,
		call_now = true,
		callback = function()
			awful.spawn.easy_async_with_shell(
				[[
				net_status="$(ip route get 8.8.8.8 2>&1 >/dev/null)"
				if ]] .. "[[ " .. [[ "$(echo ${net_status} |  awk -F ": " '{print $2}')" == *'unreachable'* ]] .. " ]];" .. [[
				then
					echo 'No internet connection'
					exit;
				fi

				net_status="$(ip route get 8.8.8.8 | grep -Po 'dev \K\w+' | grep -Ff - /proc/net/wireless)"

				if [ ! -z "${net_status}" ]
				then
					echo 'wireless'
				else
					echo 'wired'
				fi
				]],
				function(stdout)
					if stdout:match('No internet connection') then
						update_disconnected()
						return
					end

					if stdout:match('wireless') then
						update_wireless()
					elseif stdout:match('wired') then
						update_wired()
					end
				end
			)		
		end	
	}

	return widget_button

end

return return_button
