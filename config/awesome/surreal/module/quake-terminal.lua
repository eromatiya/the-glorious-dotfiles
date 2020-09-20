local gears = require('gears')
local spawn = require('awful.spawn')
local app = require('configuration.apps').default.quake
-- local awful = require('awful')

local quake_id = 'notnil'
local quake_client
local opened = false
function create_shell()
	quake_id =
		spawn(
		app,
		{
			skip_decoration = true,
			titlebars_enabled = false,
			switch_to_tags = false,
			opacity = 0.95,
			floating = true,
			skip_taskbar = true,
			ontop = true,
			above = true,
			sticky = true,
			hidden = not opened,
			maximized_horizontal = true,
			skip_center = true,
			round_corners = false,
			shape = function(cr, w, h)
				gears.shape.rectangle(cr, w, h)
			end
		}
	)
end

function open_quake()
	quake_client.hidden = false
	quake_client:emit_signal('request::activate')
end

function close_quake()
	quake_client.hidden = true
end

local toggle_quake = function()
	opened = not opened
	if not quake_client then
		create_shell()
	else
		if opened then
			open_quake()
		else
			close_quake()
		end
	end
end

awesome.connect_signal(
	'module::quake_terminal:toggle',
	function()
		toggle_quake();
	end
)

client.connect_signal(
	'manage',
	function(c)
		if c.pid == quake_id then
			quake_client = c
		end
	end
)

client.connect_signal(
	'unmanage',
	function(c)
		if c.pid == quake_id then
			opened = false
			quake_client = nil
		end
	end
)
