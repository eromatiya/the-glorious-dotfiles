
local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')

local dpi = require('beautiful').xresources.apply_dpi

local beautiful = require('beautiful')

local clickable_container = require('widget.clickable-container')

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/social-media/icons/'

local decorate_widget = function(widgets)

	return wibox.widget {
		widgets,
		bg = beautiful.groups_bg,
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, groups_radius) end,
		widget = wibox.container.background
	}

end


local build_social_button = function(website)

	local social_imgbox = wibox.widget {
		{
			id = 'icon',
			image = widget_icon_dir .. website .. '.svg',
			widget = wibox.widget.imagebox,
			resize = true,
			forced_height = dpi(35)
		},
		layout = wibox.layout.align.horizontal
	}

	local social_button = wibox.widget {
		{
			social_imgbox,
			margins = dpi(7),
			widget = wibox.container.margin
		},
		widget = clickable_container
	}

	social_button:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					local social_site = website
					
					if social_site == 'facebook' then
						awful.spawn.easy_async_with_shell("xdg-open https://facebook.com", function(stderr) end, false)
					elseif social_site == 'reddit' then
						awful.spawn.easy_async_with_shell("xdg-open https://reddit.com", function(stderr) end, false)
					elseif social_site == 'twitter' then
						awful.spawn.easy_async_with_shell("xdg-open https://twitter.com", function(stderr) end, false)
					elseif social_site == 'instagram' then
						awful.spawn.easy_async_with_shell("xdg-open https://instagram.com", function(stderr) end, false)
					end

				end
			)
		)
	)

	local social_name = website:gsub('%W','')
	social_name =  social_name:sub(1,1):upper()..social_name:sub(2)

	local social_tbox = wibox.widget {
		text = social_name,
		font = 'SF Pro Text Regular 10',
		align = 'center',
		valign = 'center',
		widget = wibox.widget.textbox
	}

	return wibox.widget {
		layout = wibox.layout.fixed.vertical,
		spacing = dpi(5),
		{
			layout = wibox.layout.align.horizontal,
			expand = 'none',
			nil,
			decorate_widget(social_button),
			nil
		},
		social_tbox
	}
end


local social_layout = wibox.widget {
	layout = wibox.layout.fixed.horizontal,
	spacing = dpi(5),
	build_social_button('facebook'),
	build_social_button('reddit'),
	build_social_button('twitter'),
	build_social_button('instagram'),
}

local social =  wibox.widget {
	expand = 'none',
	layout = wibox.layout.fixed.vertical,
	{
		{
			{
				expand = "none",
				layout = wibox.layout.align.horizontal,
				nil,
				social_layout,
				nil
			},
			margins = dpi(10),
			widget = wibox.container.margin,
		},
		forced_height = dpi(92),
		bg = beautiful.groups_bg,
		shape = function(cr, width, height)
			gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, beautiful.groups_radius) end,
		widget = wibox.container.background
	},
}

return social
