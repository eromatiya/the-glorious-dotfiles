local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local icons = require('theme.icons')

local tags = {
	{
		icon = icons.terminal,
		type = 'terminal',
		default_app = 'kitty',
		screen = 1
	},
	{
		icon = icons.web_browser,
		type = 'internet',
		default_app = 'firefox',
		screen = 1
	},
	{
		icon = icons.text_editor,
		type = 'code',
		default_app = 'subl3',
		screen = 1
	},
	{
		icon = icons.file_manager,
		type = 'files',
		default_app = 'dolphin',
		screen = 1
	},
	{
		icon = icons.multimedia,
		type = 'music',
		default_app = 'vlc',
		screen = 1
	},
	{
		icon = icons.games,
		type = 'games',
		default_app = 'supertuxkart',
		screen = 1
	},
	{
		icon = icons.graphics,
		type = 'art',
		default_app = 'gimp-2.10',
		screen = 1
	},
	{
		icon = icons.sandbox,
		type = 'sandbox',
		default_app = 'virtualbox',
		screen = 1
	},
	{
		icon = icons.development,
		type = 'any',
		default_app = '',
		screen = 1
	}
	-- {
	--   icon = icons.social,
	--   type = 'social',
	--   default_app = 'discord',
	--   screen = 1
	-- }
}

tag.connect_signal(
	'request::default_layouts',
	function()
	    awful.layout.append_default_layouts({
			awful.layout.suit.spiral.dwindle,
			awful.layout.suit.tile,
			awful.layout.suit.floating,
			awful.layout.suit.max
	    })
	end
)

screen.connect_signal(
	'request::desktop_decoration',
	function(s)
		for i, tag in pairs(tags) do
			awful.tag.add(
				i,
				{
					icon = tag.icon,
					icon_only = true,
					layout = awful.layout.suit.spiral.dwindle,
					gap_single_client = true,
					gap = beautiful.useless_gap,
					screen = s,
					default_app = tag.default_app,
					selected = i == 1
				}
			)
		end
	end
)

-- Change tag's client's shape and gap on change
tag.connect_signal(
	'property::layout',
	function(t)
		local current_layout = awful.tag.getproperty(t, 'layout')
		if (current_layout == awful.layout.suit.max) then
			-- Set clients gap to 0 and shape to rectangle if maximized
			t.gap = 0
			for _, c in ipairs(t:clients()) do
				if not c.floating then
					c.shape = function(cr, width, height)
						gears.shape.rectangle(cr, width, height)
					end
				else
					c.shape = function(cr, width, height)
						gears.shape.rounded_rect(cr, width, height, beautiful.client_radius)
					end
				end
			end
		else
			-- Set clients gap and shape
			t.gap = beautiful.useless_gap
			for _, c in ipairs(t:clients()) do
				if not c.round_corners or c.maximized then return end
				c.shape = function(cr, width, height)
					gears.shape.rounded_rect(cr, width, height, beautiful.client_radius)
				end
			end
		end
	end
)

-- Focus on urgent clients
awful.tag.attached_connect_signal(
	s,
	'property::selected',
	function()
		local urgent_clients = function (c)
			return awful.rules.match(c, {urgent = true})
		end
		for c in awful.client.iterate(urgent_clients) do
			if c.first_tag == mouse.screen.selected_tag then
				client.focus = c
				c:raise()
			end
		end
	end
)
