local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')
local naughty = require('naughty')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/weather/icons/'
local clickable_container = require('widget.clickable-container')
local json = require('library.json')
local secrets = require('configuration.secrets')

local key     = secrets.weather.key
local city_id = secrets.weather.city_id
local units   = secrets.weather.units

local update_interval = 1200

local weather_header = wibox.widget {
	text   = 'Weather Forecast',
	font   = 'Inter Bold 14',
	align  = 'left',
	valign = 'center',
	widget = wibox.widget.textbox
}

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
				awesome.emit_signal('widget::forecast_fetch')
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
		markup = 'Dust and clouds, -1000°C',
		font   = 'Inter Regular 10',
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
		font   = 'Inter Regular 10',
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
	markup = '00:00',
	font   = 'Inter Regular 10',
	align  = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

local weather_sunset = wibox.widget {
	markup = '00:00',
	font   = 'Inter Regular 10',
	align  = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

local weather_data_time = wibox.widget {
	markup = '00:00',
	font   = 'Inter Regular 10',
	align  = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

local weather_forecast_tooltip = awful.tooltip {
	text = 'Loading...',
	objects = {weather_icon_widget},
	mode = 'outside',
	align = 'right',
	preferred_positions = {'left', 'right', 'top', 'bottom'},
	margin_leftright = dpi(8),
	margin_topbottom = dpi(8)
}

local weather_report =  wibox.widget {
	{
		{
			layout = wibox.layout.fixed.vertical,
			spacing = dpi(10),
			weather_header,
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
			}
		},
		margins = dpi(10),
		widget = wibox.container.margin
	},
	forced_height = dpi(110),
	bg = beautiful.groups_bg,
	shape = function(cr, width, height)
		gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, beautiful.groups_radius) 
	end,
	widget = wibox.container.background	
}

-- Return weather symbol
local get_weather_symbol = function()
	local symbol_tbl = {
		['metric'] = '°C',
		['imperial'] = '°F'
	}

	return symbol_tbl[units]
end

-- Create openweathermap script based on pass mode
-- Mode must be `forecast` or `weather`
local create_weather_script = function(mode)
	local weather_script = [[
		KEY="]] .. key .. [["
		CITY="]] .. city_id .. [["
		UNITS="]] .. units .. [["

		weather=$(curl -sf "http://api.openweathermap.org/data/2.5/]] .. mode .. [[?APPID="${KEY}"&id="${CITY}"&units="${UNITS}"")

		if [ ! -z "$weather" ]; then
			printf "${weather}"
		else
			printf "error"
		fi
	]]

	return weather_script
end

awesome.connect_signal(
	'widget::forecast_fetch',
	function()
		awful.spawn.easy_async_with_shell(
			create_weather_script('forecast'),
			function(stdout)
				if stdout:match('error') then
					weather_forecast_tooltip:set_markup('Can\'t retrieve data!')
				else
					local forecast_data = json.parse(stdout)
					local forecast = ''

					for i = 8, 40, 8 do
						local day = os.date('%A @ %H:%M', forecast_data.list[i].dt)
						local temp = math.floor(forecast_data.list[i].main.temp + 0.5)
						local feels_like = math.floor(forecast_data.list[i].main.feels_like + 0.5)
						local weather = forecast_data.list[i].weather[1].description

						-- Capitalize weather description
						weather = weather:sub(1, 1):upper() .. weather:sub(2)

						forecast = forecast .. '<b>' .. day .. '</b>\n' ..
						'Weather: ' .. weather .. '\n' ..
						'Temperature: ' .. temp .. get_weather_symbol() .. '\n' ..
						'Feels like: ' .. feels_like .. get_weather_symbol() .. '\n\n'

						weather_forecast_tooltip:set_markup(forecast:sub(1, -2))
					end
				end
			end
		)
	end
)

awesome.connect_signal(
	'widget::weather_fetch',
	function() 

		awful.spawn.easy_async_with_shell(
			create_weather_script('weather'),
			function(stdout)
				if stdout:match('error') then
					awesome.emit_signal(
						'widget::weather_update', 
						'...', 
						'Dust and clouds, -1000°C', 
						'Earth, Milky Way', 
						'00:00', 
						'00:00', 
						'00:00'
					)
				else
					-- Parse JSON string
					local weather_data = json.parse(stdout)

					-- Process weather data
					local location = weather_data.name
					local country = weather_data.sys.country
					local sunrise = os.date('%H:%M', weather_data.sys.sunrise)
					local sunset = os.date('%H:%M', weather_data.sys.sunset)
					local refresh = os.date('%H:%M', weather_data.dt)
					local temperature = math.floor(weather_data.main.temp + 0.5)
					local weather = weather_data.weather[1].description
					local weather_icon = weather_data.weather[1].icon

					-- Capitalize weather description
					local weather = weather:sub(1, 1):upper() .. weather:sub(2)

					-- Contantenate weather description and symbol
					local weather_description = weather .. ', ' .. temperature .. get_weather_symbol()

					-- Contantenate city and country
					local weather_location = location .. ', ' .. country

					awesome.emit_signal(
						'widget::weather_update', 
						weather_icon, 
						weather_description, 
						weather_location, 
						sunrise, 
						sunset, 
						refresh
					)
				end
				collectgarbage('collect')
			end
		)
	end
)

local update_widget_timer = gears.timer {
	timeout = update_interval,
	autostart = true,
	call_now  = true,
	single_shot = false,
	callback  = function()
		awesome.emit_signal('widget::weather_fetch')
		awesome.emit_signal('widget::forecast_fetch')
	end
}

awesome.connect_signal(
	'system::network_connected',
	function() 
		gears.timer.start_new(
			5,
			function() 
				awesome.emit_signal('widget::weather_fetch')
				awesome.emit_signal('widget::forecast_fetch')
			end
		)
	end
)

awesome.connect_signal(
	'widget::weather_update', 
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
