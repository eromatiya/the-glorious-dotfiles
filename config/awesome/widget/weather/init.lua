local awful = require('awful')
local beautiful = require('beautiful')
local naughty = require('naughty')
local wibox = require('wibox')
local gears = require('gears')

local dpi = beautiful.xresources.apply_dpi

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/weather/icons/'

local clickable_container = require('widget.clickable-container')


-- Retrieve credentials
local secrets = require('configuration.secrets')

-- Credentials
local key       = secrets.weather.key        -- openweathermap_api_key
local city_id   = secrets.weather.city_id    -- openweathermap_city_id
local units     = secrets.weather.units      -- weather_units  metric(°C)/imperial(°F)


local weather_icon_widget = wibox.widget {
	{
		id = 'icon',
		image = widget_icon_dir .. 'weather-error' .. '.svg',
		resize = true,
		forced_height = dpi(45),
		forced_width = dpi(45),
		widget = wibox.widget.imagebox,
	},
	layout = wibox.layout.fixed.horizontal
}

local sunrise_icon_widget = wibox.widget {
	{
		id = 'sunrise_icon',
		image = widget_icon_dir .. 'sunrise' .. '.svg',
		resize = true,
		forced_height = dpi(17),
		forced_width = dpi(17),
		widget = wibox.widget.imagebox,
	},
	layout = wibox.layout.fixed.horizontal
}

local sunset_icon_widget = wibox.widget {
	{
		id = 'sunset_icon',
		image = widget_icon_dir .. 'sunset' .. '.svg',
		resize = true,
		forced_height = dpi(17),
		forced_width = dpi(17),
		widget = wibox.widget.imagebox,
	},
	layout = wibox.layout.fixed.horizontal
}

refresh_icon_widget = wibox.widget {
	{
		id = 'refresh_icon',
		image = widget_icon_dir .. 'refresh' .. '.svg',
		resize = true,
		forced_height = dpi(17),
		forced_width = dpi(17),
		widget = wibox.widget.imagebox,
	},
	layout = wibox.layout.fixed.horizontal
}

local refresh_button = clickable_container(refresh_icon_widget)
refresh_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				awesome.emit_signal('widget::weather_fetch')
			end
		)
	)
)

local refresh_widget = wibox.widget {
	refresh_button,
	bg = beautiful.transparent,
	shape = gears.shape.circle,
	widget = wibox.container.background
}

local weather_desc_temp = wibox.widget {
	text   = "dust & clouds, -1000°C",
	font   = 'SF Pro Text Bold 12',
	align  = 'left',
	valign = 'center',
	widget = wibox.widget.textbox
}

local weather_location = wibox.widget {
	text   = "Earth, Milky Way",
	font   = 'SF Pro Text Regular 12',
	align  = 'left',
	valign = 'center',
	widget = wibox.widget.textbox
}

local weather_sunrise = wibox.widget {
	text   = "00:00AM",
	font   = 'SF Pro Text Regular 10',
	align  = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

local weather_sunset = wibox.widget {
	text   = "00:00PM",
	font   = 'SF Pro Text Regular 10',
	align  = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

local weather_data_time = wibox.widget {
	text   = "00:00AM",
	font   = 'SF Pro Text Regular 10',
	align  = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

local weather_report =  wibox.widget {
	{
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(10),
			{
				layout = wibox.layout.align.vertical,
				expand = 'none',
				nil,
				weather_icon_widget,
				nil
			},
			{
				layout = wibox.layout.align.vertical,
				expand = 'none',
				nil,
				{
					layout = wibox.layout.fixed.vertical,
					spacing = dpi(3),
					weather_location,
					weather_desc_temp,
					{
						layout = wibox.layout.fixed.horizontal,
						spacing = dpi(7),
						{
							layout = wibox.layout.fixed.horizontal,
							spacing = dpi(3),
							sunrise_icon_widget,
							weather_sunrise
						},
						{
							layout = wibox.layout.fixed.horizontal,
							spacing = dpi(3),
							sunset_icon_widget,
							weather_sunset
						},
						{
							layout = wibox.layout.fixed.horizontal,
							spacing = dpi(3),
							refresh_widget,
							weather_data_time
						}
					}
				},
				nil				
			}
		},
		margins = dpi(10),
		widget = wibox.container.margin
	},
	forced_height = dpi(92),
	bg = beautiful.groups_bg,
	shape = function(cr, width, height)
	gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, beautiful.groups_radius) end,
	widget = wibox.container.background	
}


--  #     #                                          
--  #     # #####  #####    ##   ##### ###### #####  
--  #     # #    # #    #  #  #    #   #      #    # 
--  #     # #    # #    # #    #   #   #####  #    # 
--  #     # #####  #    # ######   #   #      #####  
--  #     # #      #    # #    #   #   #      #   #  
--   #####  #      #####  #    #   #   ###### #    # 



-- Don't update too often, because your requests might get blocked for 24 hours
local update_interval = 1200

-- Check units
if units == "metric" then
		weather_temperature_symbol = "°C"
elseif units == "imperial" then
		weather_temperature_symbol = "°F"
end

--  Weather script using your API KEY
local weather_details_script = [[
KEY="]]..key..[["
CITY="]]..city_id..[["
UNITS="]]..units..[["

weather=$(curl -sf "http://api.openweathermap.org/data/2.5/weather?APPID=$KEY&id=$CITY&units=$UNITS")

if [ ! -z "$weather" ]; then
	weather_location=$(echo "$weather" | jq -r ".name")
	weather_country=$(echo "$weather" | jq -r ".sys.country")
	weather_sunrise=$(echo "$weather" | jq -r ".sys.sunrise" | xargs -0 -L1 -I '$' echo '@$' | xargs date +"%I:%M%p" -d)
	weather_sunset=$(echo "$weather" | jq -r ".sys.sunset" | xargs -0 -L1 -I '$' echo '@$' | xargs date +"%I:%M%p" -d)
	weather_data_time=$(echo "$weather" | jq -r ".dt" | xargs -0 -L1 -I '$' echo '@$' | xargs date +"%I:%M%p" -d)
	weather_temp=$(echo "$weather" | jq ".main.temp" | cut -d "." -f 1)
	weather_icon=$(echo "$weather" | jq -r ".weather[].icon" | head -1)
	weather_description=$(echo "$weather" | jq -r ".weather[].description" | head -1)

	echo "^${weather_icon}^" ">>${weather_description}"@@"${weather_temp}<<" "::${weather_location}, ${weather_country}::" "||${weather_sunrise}&&${weather_sunset}||" "//${weather_data_time}//"

else
	echo "..."
fi	
]]

awesome.connect_signal('widget::weather_fetch', function() 

	awful.spawn.easy_async_with_shell(weather_details_script, function(stdout)

		local fetch_icon_code = stdout:match('^(.*)^')
		
		-- No internet / no credentials
		if fetch_icon_code == "..." then

			awesome.emit_signal("widget::weather_update", 
				fetch_icon_code, 
				'dust & clouds, -1000°C', 
				'Earth, Milky Way', 
				'00:00AM', 
				'00:00PM', 
				'00:00PM'
			)
			
		else
			
			local weather_details = stdout:match('>>(.*)<<')

			weather_details = string.gsub(weather_details, '^%s*(.-)%s*$', '%1')
			-- Relocations "-0" with "0" degrees
			weather_details = string.gsub(weather_details, '%-0', '0')
			-- Capitalize first letter of the description
			weather_details = weather_details:sub(1,1):upper()..weather_details:sub(2)

			local fetch_description = weather_details:match('(.*)@@')
			local fetch_temperature = weather_details:match('@@(.*)')

			local fetch_description = fetch_description .. ', ' .. fetch_temperature .. weather_temperature_symbol

			if #fetch_description >= 33 then
				weather_desc_temp:set_font('SF Pro Text Bold 11')
			else
				weather_desc_temp:set_font('SF Pro Text Bold 12')
			end

			local fetch_location = stdout:match('::(.*)::')

			local fetch_sun_routine = stdout:match('||(.*)||')
			local fetch_sunrise = fetch_sun_routine:match('(.*)&&')
			local fetch_sunset = fetch_sun_routine:match('&&(.*)')


			local fetch_data_receive = stdout:match('//(.*)//')

			-- Pass: temperature, description, icon_code, location, sunrise, sunset, weather_data_receive, 
			awesome.emit_signal("widget::weather_update", 
				fetch_icon_code, 
				fetch_description, 
				fetch_location, 
				fetch_sunrise, 
				fetch_sunset, 
				fetch_data_receive
			)

		end

		collectgarbage('collect')
	end)
end)


-- Update weather every after update_interval seconds
gears.timer {
	timeout = update_interval,
	autostart = true,
	call_now  = true,
	single_shot = false,
	callback  = function()

		awesome.emit_signal('widget::weather_fetch')
	end
}

-- Update widget if connecte to wifi
awesome.connect_signal('system::wifi_connected', function() 
	-- Add a delay of 3 seconds
	gears.timer.start_new(3, function() 
		awesome.emit_signal('widget::weather_fetch')
	end)
end)

awesome.connect_signal("widget::weather_update", 
	function(code, desc, location, sunrise, sunset, data_receive)
		local icon
		local color
		local widget_icon_name
		-- Set icon and color depending on icon_code
		if string.find(code, "01d") then
				-- icon = sun_icon
				-- color = beautiful.xcolor3
				widget_icon_name = 'sun_icon'
		elseif string.find(code, "01n") then
				-- icon = moon_icon
				-- color = beautiful.xcolor4
				widget_icon_name = 'moon_icon'
		elseif string.find(code, "02d") then
				-- icon = dcloud_icon
				-- color = beautiful.xcolor3
				widget_icon_name = 'dcloud_icon'
		elseif string.find(code, "02n") then
				-- icon = ncloud_icon
				-- color = beautiful.xcolor6
				widget_icon_name = 'ncloud_icon'
		elseif string.find(code, "03") or string.find(code, "04") then
				-- icon = cloud_icon
				-- color = beautiful.xcolor1
				widget_icon_name = 'cloud_icon'
		elseif string.find(code, "09") or string.find(code, "10") then
				-- icon = rain_icon
				-- color = beautiful.xcolor4
				widget_icon_name = 'rain_icon'
		elseif string.find(code, "11") then
				-- icon = storm_icon
				-- color = beautiful.xcolor1
				widget_icon_name = 'storm_icon'
		elseif string.find(code, "13") then
				-- icon = snow_icon
				-- color = beautiful.xcolor6
				widget_icon_name = 'snow_icon'
		elseif string.find(code, "50") or string.find(code, "40") then
				-- icon = mist_icon
				-- color = beautiful.xcolor5
				widget_icon_name = 'mist_icon'
		else
				-- icon = whatever_icon
				-- color = beautiful.xcolor2
				widget_icon_name = 'weather-error'
		end

		-- Update data
		weather_icon_widget.icon:set_image(widget_icon_dir .. widget_icon_name .. '.svg')
		weather_desc_temp:set_text(desc)
		weather_location:set_text(location)
		weather_sunrise:set_text(sunrise)
		weather_sunset:set_text(sunset)
		weather_data_time:set_text(data_receive)
end)


return weather_report
