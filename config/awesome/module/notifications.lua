local naughty = require('naughty')
local beautiful = require('beautiful')
local gears = require('gears')
local wibox = require('wibox')
local awful = require('awful')
local ruled = require('ruled')

local dpi = require('beautiful').xresources.apply_dpi

-- Defaults
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(32)
naughty.config.defaults.timeout = 5
naughty.config.defaults.title = 'System Notification'
naughty.config.defaults.margin = dpi(16)
naughty.config.defaults.border_width = 0
naughty.config.defaults.position = 'top_right'
naughty.config.defaults.shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(6)) end

-- Apply theme variables

naughty.config.padding = 8
naughty.config.spacing = 8
naughty.config.icon_dirs = {
	"/usr/share/icons/la-capitaine-icon-theme/",
	"/usr/share/icons/Papirus/",
	"/usr/share/pixmaps/"
}
naughty.config.icon_formats = {	"png", "svg", "jpg" }


-- Presets / rules

ruled.notification.connect_signal('request::rules', function()
	
	-- Critical notifs
	ruled.notification.append_rule {
		rule       = { urgency = 'critical' },
		properties = { 
			font        		= 'SF Pro Text Bold 10',
			bg 					= '#ff0000', 
			fg 					= '#ffffff',
			margin 				= dpi(16),
			position 			= 'top_right',
			timeout 			= 0,
			implicit_timeout	= 0
		}
	}

	-- Normal notifs
	ruled.notification.append_rule {
		rule       = { urgency = 'normal' },
		properties = {
			font        		= 'SF Pro Text Regular 10',
			bg      			= beautiful.background, 
			fg 					= beautiful.fg_normal,
			margin 				= dpi(16),
			position 			= 'top_right',
			timeout 			= 5,
			implicit_timeout 	= 5
		}
	}

	-- Low notifs
	ruled.notification.append_rule {
		rule       = { urgency = 'low' },
		properties = { 
			font        		= 'SF Pro Text Regular 10',
			bg     				= beautiful.background,
			fg 					= beautiful.fg_normal,
			margin 				= dpi(16),
			position 			= 'top_right',
			timeout 			= 5,
			implicit_timeout	= 5
		}
	}
end)


-- Error handling
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message,
        app_name = 'System Notification',
        icon = beautiful.awesome_icon
    }
end)


naughty.connect_signal("request::display", function(n)

	-- naughty.actions template
	local actions_template = wibox.widget {
		notification = n,
		base_layout = wibox.widget {
			spacing        = dpi(0),
			layout         = wibox.layout.flex.horizontal
		},
		widget_template = {
			{
				{
					{
						id     = 'text_role',
						font   = 'SF Pro Text Regular 10',
						widget = wibox.widget.textbox
					},
						widget = wibox.container.place
				},
				bg                 = beautiful.groups_bg,
				shape              = gears.shape.rounded_rect,
				forced_height      = 30,
				widget             = wibox.container.background,
			},
			margins = 4,
			widget  = wibox.container.margin,
		},
		style = { underline_normal = false, underline_selected = true },
		widget = naughty.list.actions,
	}

	-- Custom notification layout
	naughty.layout.box {
		notification = n,
		type = "utility",
		screen = awful.screen.focused(),
		shape = gears.shape.rectangle,
		widget_template = {
			{
				{
					{
						{
							{
								{
									{
										{
											{
												{
													{
														markup = n.app_name or 'System Notification',
														font = 'SF Pro Text Bold 10',
														align = 'center',
														valign = 'center',
														widget = wibox.widget.textbox

													},
													margins = beautiful.notification_margin,
													widget  = wibox.container.margin,
												},
												bg = '#000000'.. '44',
												widget  = wibox.container.background,
											},
											{
												{
													{
														resize_strategy = 'center',
														widget = naughty.widget.icon,
													},
													margins = beautiful.notification_margin,
													widget  = wibox.container.margin,
												},
												{
													{
														layout = wibox.layout.align.vertical,
														expand = 'none',
														nil,
														{
															{
																align = 'left',
																widget = naughty.widget.title
															},
															{
																align = "left",
																widget = naughty.widget.message,
															},
															layout = wibox.layout.fixed.vertical
														},
														nil
													},
													margins = beautiful.notification_margin,
													widget  = wibox.container.margin,
												},
												layout = wibox.layout.fixed.horizontal,
											},
											fill_space = true,
											spacing = beautiful.notification_margin,
											layout  = wibox.layout.fixed.vertical,
										},
										-- Margin between the fake background
										-- Set to 0 to preserve the 'titlebar' effect
										margins = dpi(0),
										widget  = wibox.container.margin,
									},
									bg = beautiful.transparent,
									widget  = wibox.container.background,
								},
								-- Notification action list
								-- naughty.list.actions,
								actions_template,
								spacing = dpi(4),
								layout  = wibox.layout.fixed.vertical,
							},
							bg     = beautiful.transparent,
							id     = "background_role",
							widget = naughty.container.background,
						},
						strategy = "min",
						width    = dpi(160),
						widget   = wibox.container.constraint,
					},
					strategy = "max",
					width    = beautiful.notification_max_width or dpi(500),
					widget   = wibox.container.constraint,
				},
				-- Anti-aliasing container
				-- Real BG
				bg = beautiful.background,
				-- This will be the anti-aliased shape of the notification
				shape = gears.shape.rounded_rect,
				widget = wibox.container.background
			},
			-- Margin of the fake BG to have a space between notification and the screen edge
			margins = dpi(5),--beautiful.notification_margin,
			widget  = wibox.container.margin
		}
	
	}

	-- Destroy popups if dont_disturb mode is on
	-- Or if the right_panel is visible
	local focused = awful.screen.focused()
	if _G.dont_disturb or (focused.right_panel and focused.right_panel.visible) then
		naughty.destroy_all_notifications()
	end

end)
