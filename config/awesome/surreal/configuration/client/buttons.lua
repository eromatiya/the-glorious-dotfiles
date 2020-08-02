local awful = require('awful')
local modkey = require('configuration.keys.mod').mod_key

return awful.util.table.join(
	awful.button(
		{},
		1,
		function(c)
			client.focus = c
			c:raise()
		end
	),
	awful.button({modkey}, 1, awful.mouse.client.move),
	awful.button({modkey}, 3, awful.mouse.client.resize),
	awful.button(
		{modkey},
		4,
		function()
			awful.layout.inc(1)
		end
	),
	awful.button(
		{modkey},
		5,
		function()
			awful.layout.inc(-1)
		end
	)
)
