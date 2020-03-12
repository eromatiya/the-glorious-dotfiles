--  #                                                     
--  #       # #####  #####    ##   #####  # ######  ####  
--  #       # #    # #    #  #  #  #    # # #      #      
--  #       # #####  #    # #    # #    # # #####   ####  
--  #       # #    # #####  ###### #####  # #           # 
--  #       # #    # #   #  #    # #   #  # #      #    # 
--  ####### # #####  #    # #    # #    # # ######  ####  


local wibox = require('wibox')
local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')


--  #######                                          
--  #     # #####       # ######  ####  #####  ####  
--  #     # #    #      # #      #    #   #   #      
--  #     # #####       # #####  #        #    ####  
--  #     # #    #      # #      #        #        # 
--  #     # #    # #    # #      #    #   #   #    # 
--  ####### #####   ####  ######  ####    #    ####  


local dpi = require('beautiful').xresources.apply_dpi
local notifbox_layout = require('widget.notif-center.build-notifbox')
local builder = require('widget.notif-center.build-notifbox.ui-builder')


--  ######                                            
--  #     # #####   ####   ####  ######  ####   ####  
--  #     # #    # #    # #    # #      #      #      
--  ######  #    # #    # #      #####   ####   ####  
--  #       #####  #    # #      #           #      # 
--  #       #   #  #    # #    # #      #    # #    # 
--  #       #    #  ####   ####  ######  ####   ####  


-- Return time, accepts time format as arg
local return_date_time = function(format)
	return os.date(format)
end

-- Converts H:M:S to seconds
local parse_to_seconds = function(time)
	-- Convert HH in HH:MM:SS
	hourInSec = tonumber(string.sub(time, 1, 2)) * 3600

	-- Convert MM in HH:MM:SS
	minInSec = tonumber(string.sub(time, 4, 5)) * 60

	-- Get SS in HH:MM:SS
	getSec = tonumber(string.sub(time, 7, 8))

	return (hourInSec + minInSec + getSec)

end

-- Returns the notification box
notifbox_box = function(notif, icon, title, message, app, bgcolor)

	-- Get time with Hour:minute:seconds
	local time_of_pop = return_date_time('%H:%M:%S')

	-- Get time with `Hour:Minute (AM/PM)` format
	local exact_time = return_date_time('%I:%M %p')

	-- Get the time with the format of Month Day, Hour:Minute (AM/PM)
	local exact_date_time = return_date_time('%b %d, %I:%M %p')  

	-- Notification time pop container
	local notifbox_timepop =  wibox.widget {
		id = 'time_pop',
		text = nil,
		font = 'SF Pro Text Regular 10',
		align = 'left',
		valign = 'center',
		visible = true,
		widget = wibox.widget.textbox
	}

	-- Invoke a dismiss button
	local notifbox_dismiss = builder.notifbox_dismiss()

	-- Timer for notification time pop
	gears.timer {
		timeout   = 60,
		call_now  = true,
		autostart = true,
		callback  = function()

			local time_difference = nil

			-- Get the time difference
			time_difference = parse_to_seconds(return_date_time('%H:%M:%S')) - parse_to_seconds(time_of_pop)

			-- String to Number
			time_difference = tonumber(time_difference)

			-- If less than one minute
			if time_difference < 60 then
				notifbox_timepop.text = 'now'

			-- If greater than one minute and less than an hour
			elseif time_difference >= 60 and time_difference < 3600 then
				local time_in_minutes = math.floor(time_difference / 60)
				notifbox_timepop.text = time_in_minutes .. 'm ago'
				
			-- If greater than one hour and less than one day
			elseif time_difference >= 3600 and time_difference < 86400 then
				-- Use time of popup instead
				notifbox_timepop.text = exact_time

			-- If greater than 1 day
			elseif time_difference >= 86400 then
				notifbox_timepop.text = exact_date_time
				return false

			end

			collectgarbage('collect')
		end
	}

	-- Template of notification box
	local notifbox_template =  wibox.widget {
		id = 'notifbox_template',
		expand = 'none',
		{
			{
				layout = wibox.layout.fixed.vertical,
				spacing = dpi(5),
				{
					expand = 'none',
					layout = wibox.layout.align.horizontal,
					{
						layout = wibox.layout.fixed.horizontal,
						spacing = dpi(5),
						builder.notifbox_icon(icon),
						builder.notifbox_appname(app),
					},
					nil,
					{
						notifbox_timepop,
						notifbox_dismiss,
						layout = wibox.layout.fixed.horizontal
					}
				},
				{
					layout = wibox.layout.fixed.vertical,
					spacing = dpi(5),
					{
						builder.notifbox_title(title),
						builder.notifbox_message(message),
						layout = wibox.layout.fixed.vertical
					},
					builder.notifbox_actions(notif),
				},

			},
			margins = dpi(10),
			widget = wibox.container.margin
		},
		bg = bgcolor,
		shape = function(cr, width, height)
			gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, beautiful.groups_radius) end,
		widget = wibox.container.background,
	}

	-- Put the generated template to a container
	local notifbox = wibox.widget {
		notifbox_template,
		shape = function(cr, width, height)
			gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, beautiful.groups_radius) end,
		widget = wibox.container.background
	}

	-- Delete notification box
	local notifbox_delete = function()
		notifbox_layout:remove_widgets(notifbox, true)
	end

	-- Delete notifbox on LMB
	notifbox:buttons(
		awful.util.table.join(
			awful.button(
				{},
				1,
				function()
					if #notifbox_layout.children == 1 then
						reset_notifbox_layout()
					else
						notifbox_delete()
					end
					collectgarbage('collect')
				end
			)
		)
	)

	-- Add hover, and mouse leave events
	notifbox_template:connect_signal("mouse::enter", function() 
		notifbox.bg = beautiful.groups_bg
		notifbox_timepop.visible = false
		notifbox_dismiss.visible = true
	end)

	notifbox_template:connect_signal("mouse::leave", function() 
		notifbox.bg = beautiful.tranparent
		notifbox_timepop.visible = true
		notifbox_dismiss.visible = false
	end)


	collectgarbage('collect')
	
	-- Return	
	return notifbox
end


return notifbox_box