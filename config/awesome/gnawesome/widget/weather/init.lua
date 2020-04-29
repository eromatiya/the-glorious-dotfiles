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
local city_id  = secrets.weather.city_id    -- openweathermap_city_id
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
		forced_height = dpi(18),
		forced_width = dpi(18),
		widget = wibox.widget.imagebox,
	},
	layout = wibox.layout.fixed.horizontal
}

local sunset_icon_widget = wibox.widget {
	{
		id = 'sunset_icon',
		image = widget_icon_dir .. 'sunset' .. '.svg',
		resize = true,
		forced_height = dpi(18),
		forced_width = dpi(18),
		widget = wibox.widget.imagebox,
	},
	layout = wibox.layout.fixed.horizontal
}

refresh_icon_widget = wibox.widget {
	{
		id = 'refresh_icon',
		image = widget_icon_dir .. 'refresh' .. '.svg',
		resize = true,
		forced_height = dpi(18),
		forced_width = dpi(18),
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
	text   = "00:00",
	font   = 'SF Pro Text Regular 10',
	align  = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

local weather_sunset = wibox.widget {
	text   = "00:00",
	font   = 'SF Pro Text Regular 10',
	align  = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

local weather_data_time = wibox.widget {
	text   = "00:00",
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

weather=$(curl -sf "http://api.openweathermap.org/data/2.5/weather?APPID="${KEY}"&id="${CITY}"&units="${UNITS}"")

if [ ! -z "$weather" ]; then
	weather_icon="icon=$(printf "$weather" | jq -r ".weather[].icon" | head -1)"
	
	weather_location="location=$(printf "$weather" | jq -r ".name")"
	weather_country="country=$(printf "$weather" | jq -r ".sys.country")"
	
	weather_sunrise="sunrise=$(printf "$weather" | jq -r ".sys.sunrise" | xargs -0 -L1 -I '$' echo '@$' | xargs date +"%H:%M" -d)"
	weather_sunset="sunset=$(printf "$weather" | jq -r ".sys.sunset" | xargs -0 -L1 -I '$' echo '@$' | xargs date +"%H:%M" -d)"
	
	weather_data_time="update=$(printf "$weather" | jq -r ".dt" | xargs -0 -L1 -I '$' echo '@$' | xargs date +"%H:%M" -d)"
	
	weather_temp="temperature=$(printf "$weather" | jq ".main.temp" | cut -d "." -f 1)"
	
	weather_description="details=$(printf "$weather" | jq -r ".weather[].description" | head -1)"

	DATA="${weather_icon}\n${weather_location}\n${weather_country}\n${weather_sunrise}\n${weather_sunset}\n${weather_data_time}\n${weather_temp}\n${weather_description}\n"
	printf "${DATA}"

else
	printf "icon=..."
fi	
]]

awesome.connect_signal('widget::weather_fetch', function() 

	awful.spawn.easy_async_with_shell(weather_details_script, function(stdout)

		local weather_data_tbl = {}

		-- Populate weather_data_tbl
		for data in stdout:gmatch("[^\n]+") do
			local key = data:match("(.*)=")
			local value = data:match("=(.*)")
			weather_data_tbl[key] = value
		end

		local icon_code = weather_data_tbl['icon']

		-- No internet / no credentials
		if icon_code == '...' then

			awesome.emit_signal("widget::weather_update", 
				icon_code, 
				'dust & clouds, -1000°C', 
				'Earth, Milky Way', 
				'00:00', 
				'00:00', 
				'00:00'
			)
			
		else

			local location = weather_data_tbl['location']
			local country = weather_data_tbl['country']
			local sunrise = weather_data_tbl['sunrise']
			local sunset = weather_data_tbl['sunset']
			local update_time = weather_data_tbl['update']
			local temperature = weather_data_tbl['temperature']
			local details = weather_data_tbl['details']

			local weather_description = details .. ', ' .. temperature .. weather_temperature_symbol
			
			if #weather_description >= 33 then
				weather_desc_temp:set_font('SF Pro Text Bold 11')
			else
				weather_desc_temp:set_font('SF Pro Text Bold 12')
			end

			awesome.emit_signal("widget::weather_update", 
				icon_code, 
				weather_description, 
				location, 
				sunrise, 
				sunset, 
				update_time
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
		local widget_icon_name = 'weather-error'

		-- Yes, I'm learning Lua tables
		local icon_tbl = {
			['01d'] = 'sun_icon',
			['01n'] = 'moon_icon',
			['02d'] = 'dfew_clouds',
			['02n'] = 'nfew_clouds',
			['03d'] = 'dscattered_clouds',
			['03n'] = 'nscattered_clouds',
			['04d'] = 'dbroken_clouds',
			['04n'] = 'nbroken_clouds',
			['09d'] = 'dshower_rain',
			['09n'] = 'nshower_rain',
			['10n'] = 'drain_icon',
			['10d'] = 'nrain_icon',
			['11d'] = 'dthunderstorm',
			['11n'] = 'nhunderstorm',
			['13d'] = 'snow',
			['13n'] = 'snow',
			['50d'] = 'dmist',
			['50n'] = 'nmist',
			['...'] = 'weather-error'
		}

		widget_icon_name = icon_tbl[code]

		weather_icon_widget.icon:set_image(widget_icon_dir .. widget_icon_name .. '.svg')
		weather_desc_temp:set_text(desc)
		weather_location:set_text(location)
		weather_sunrise:set_text(sunrise)
		weather_sunset:set_text(sunset)
		weather_data_time:set_text(data_receive)

end)


return weather_report
