local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local icons = require('theme.icons')

local tags = {
	{
		type = 'terminal',
		icon = icons.terminal,
		default_app = 'kitty',
		gap = beautiful.useless_gap,
		layout = awful.layout.suit.floating
	},
	{
		type = 'internet',
		icon = icons.web_browser,
		default_app = 'firefox',
		gap = beautiful.useless_gap
	},
	{
		type = 'code',
		icon = icons.text_editor,
		default_app = 'subl3',
		gap = beautiful.useless_gap
	},
	{
		type = 'files',
		icon = icons.file_manager,
		default_app = 'dolphin',
		gap = beautiful.useless_gap,
		layout = awful.layout.suit.tile
	},
	{
		type = 'music',
		icon = icons.multimedia,
		default_app = 'vlc',
		gap = beautiful.useless_gap,
		layout = awful.layout.suit.max,
		gap = 0
	},
	{
		type = 'games',
		icon = icons.games,
		default_app = 'supertuxkart',
		gap = beautiful.useless_gap,
		layout = awful.layout.suit.floating
	},
	{
		type = 'art',
		icon = icons.graphics,
		default_app = 'gimp-2.10',
		gap = beautiful.useless_gap
	},
	{
		type = 'sandbox',
		icon = icons.sandbox,
		default_app = 'virtualbox',
		layout = awful.layout.suit.max,
		gap = 0
	},
	{
		type = 'any',
		icon = icons.development,
		default_app = '',
		gap = beautiful.useless_gap,
		layout = awful.layout.suit.floating
	}
	-- {
	--   type = 'social',
	--   icon = icons.social,
	--   default_app = 'discord',
	--   gap = beautiful.useless_gap
	-- }
}

-- Set tags layout
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

-- Create tags for each screen
screen.connect_signal(
	'request::desktop_decoration',
	function(s)
		for i, tag in pairs(tags) do
			awful.tag.add(
				i,
				{
					icon = tag.icon,
					icon_only = true,
					layout = tag.layout or awful.layout.suit.spiral.dwindle,
					gap_single_client = true,
					gap = tag.gap,
					screen = s,
					default_app = tag.default_app,
					selected = i == 1
				}
			)
		end
	end
)

local update_gap_and_shape = function(t)
	-- Get current tag layout
	local current_layout = awful.tag.getproperty(t, 'layout')
	-- If the current layout is awful.layout.suit.max
	if (current_layout == awful.layout.suit.max) then
		-- Set clients gap to 0 and shape to rectangle if maximized
		t.gap = 0
		for _, c in ipairs(t:clients()) do
			if not c.floating or not c.round_corners or c.maximized then
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
		t.gap = beautiful.useless_gap
		for _, c in ipairs(t:clients()) do
			if not c.round_corners or c.maximized then
				c.shape = function(cr, width, height)
					gears.shape.rectangle(cr, width, height)
				end
			else
				c.shape = function(cr, width, height)
					gears.shape.rounded_rect(cr, width, height, beautiful.client_radius)
				end
			end
		end
	end
end

-- Change tag's client's shape and gap on change
tag.connect_signal(
	'property::layout',
	function(t)
		update_gap_and_shape(t)
	end
)

-- Change tag's client's shape and gap on move to tag
tag.connect_signal(
	'tagged',
	function(t)
		update_gap_and_shape(t)
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
