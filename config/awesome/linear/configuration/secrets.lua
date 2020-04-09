
-- Credentials Manager

-- How to get a valid credentials for email widget?
-- The widget uses an IMAP. 
-- So it means any email service provider that provides an IMAP support is supported by the widget.
--    First, you need an email_address. 
--    Second, you must generate an app password for your account. Your account password WILL NOT WORK!
--        Just search in the internet on how to generate for your email service provider.
--        For example `create app password for gmail account`
--    Third, you need an imap_server.
--        Just get your email service provider's imap server. Gmail's imap server is `imap.gmail.com`
--    Fourth, provide the port.
--        Just search it in the internet. Gmail's port is `993`



--  How to get a credentials for weather widget?
--  OpenWeatherMap is our weather provider. So go to `https://home.openweathermap.org/`
--  Register, log-in, and then go to `https://home.openweathermap.org/api_keys`
--  You can create your API keys there.
--  For `units`, you have to choose for yourself. 
--    `metric` or 'imperial'
--        metric uses °C, while imperial uses °F


return {

	email  = {

		address       = '',
		app_password  = '',
		imap_server   = 'imap.gmail.com',
		port          = '993'

	},

	weather = {

		key           = '',
		city_id       = '',
		units         = 'metric'

	}
}