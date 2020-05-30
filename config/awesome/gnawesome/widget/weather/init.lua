local awful = require('awful')
local beautiful = require('beautiful')
local naughty = require('naughty')
local wibox = require('wibox')
local gears = require('gears')

local dpi = beautiful.xresources.apply_dpi

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/weather/icons/'

local clickable_container = require('widget.clickable-container')

local secrets = require('configuration.secrets')

local key     = secrets.weather.key
local city_id = secrets.weather.city_id
local units   = secrets.weather.units

local update_interval = 1200

local weather_icon_widget = wibox.widget {
	{
		id = 'icon',
		image = widget_icon_dir .. 'weather-error.svg',
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
		image = widget_icon_dir .. 'sunrise.svg',
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
		image = widget_icon_dir .. 'sunset.svg',
		resize = true,
		forced_height = dpi(18),
		forced_width = dpi(18),
		widget = wibox.widget.imagebox,
	},
	layout = wibox.layout.fixed.horizontal
}

local refresh_icon_widget = wibox.widget {
	{
		id = 'refresh_icon',
		image = widget_icon_dir .. 'refresh.svg',
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
	{
		id 	   = 'description',
		markup = 'dust and clouds, -1000°C',
		font   = 'SF Pro Text Bold 12',
		align  = 'left',
		valign = 'center',
		widget = wibox.widget.textbox
	},
	id = 'scroll_container',
	max_size = 345,
	speed = 75,
	expand = true,
	direction = 'h',
	step_function = wibox.container.scroll
					.step_functions.waiting_nonlinear_back_and_forth,
	fps = 30,
	layout = wibox.container.scroll.horizontal,
}

local weather_location = wibox.widget {
	{
		id 	   = 'location',
		markup = 'Earth, Milky Way',
		font   = 'SF Pro Text Regular 12',
		align  = 'left',
		valign = 'center',
		widget = wibox.widget.textbox
	},
	id = 'scroll_container',
	max_size = 345,
	speed = 75,
	expand = true,
	direction = 'h',
	step_function = wibox.container.scroll
					.step_functions.waiting_nonlinear_back_and_forth,
	fps = 30,
	layout = wibox.container.scroll.horizontal,
}

local weather_sunrise = wibox.widget {
	markup = "00:00",
	font   = 'SF Pro Text Regular 10',
	align  = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

local weather_sunset = wibox.widget {
	markup = "00:00",
	font   = 'SF Pro Text Regular 10',
	align  = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

local weather_data_time = wibox.widget {
	markup = "00:00",
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
		gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, beautiful.groups_radius) 
	end,
	widget = wibox.container.background	
}

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

awesome.connect_signal(
	'widget::weather_fetch',
	function() 

		awful.spawn.easy_async_with_shell(
			weather_details_script,
			function(stdout)

				local weather_data_tbl = {}

				for data in stdout:gmatch("[^\n]+") do
					local key = data:match("(.*)=")
					local value = data:match("=(.*)")
					weather_data_tbl[key] = value
				end

				local icon_code = weather_data_tbl['icon']

				if icon_code == '...' then

					awesome.emit_signal("widget::weather_update", 
						icon_code, 
						'dust and clouds, -1000°C', 
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

					local description = details:sub(1, 1):upper() .. details:sub(2)
					local weather_description = description .. ', ' .. temperature .. weather_temperature_symbol
					local weather_location = location .. ', ' .. country
					
					awesome.emit_signal("widget::weather_update", 
						icon_code, 
						weather_description, 
						weather_location, 
						sunrise, 
						sunset, 
						update_time
					)
				end
				collectgarbage('collect')
		end
	)
end)

local update_widget_timer = gears.timer {
	timeout = update_interval,
	autostart = true,
	call_now  = true,
	single_shot = false,
	callback  = function()
		awesome.emit_signal('widget::weather_fetch')
	end
}

awesome.connect_signal(
	'system::wifi_connected',
	function() 
		gears.timer.start_new(
			5,
			function() 
				awesome.emit_signal('widget::weather_fetch')
			end
		)
	end
)

awesome.connect_signal(
	"widget::weather_update", 
	function(code, desc, location, sunrise, sunset, data_receive)
		local widget_icon_name = 'weather-error'

		local icon_tbl = {
			['01d'] = 'sun_icon.svg',
			['01n'] = 'moon_icon.svg',
			['02d'] = 'dfew_clouds.svg',
			['02n'] = 'nfew_clouds.svg',
			['03d'] = 'dscattered_clouds.svg',
			['03n'] = 'nscattered_clouds.svg',
			['04d'] = 'dbroken_clouds.svg',
			['04n'] = 'nbroken_clouds.svg',
			['09d'] = 'dshower_rain.svg',
			['09n'] = 'nshower_rain.svg',
			['10d'] = 'd_rain.svg',
			['10n'] = 'n_rain.svg',
			['11d'] = 'dthunderstorm.svg',
			['11n'] = 'nthunderstorm.svg',
			['13d'] = 'snow.svg',
			['13n'] = 'snow.svg',
			['50d'] = 'dmist.svg',
			['50n'] = 'nmist.svg',
			['...'] = 'weather-error.svg'
		}

		widget_icon_name = icon_tbl[code]

		weather_icon_widget.icon:set_image(widget_icon_dir .. widget_icon_name)
		weather_icon_widget.icon:emit_signal('widget::redraw_needed')
		
		weather_desc_temp.description:set_markup(desc)
		weather_location.location:set_markup(location)
		weather_sunrise:set_markup(sunrise)
		weather_sunset:set_markup(sunset)
		weather_data_time:set_markup(data_receive)

	end
)

return weather_report
