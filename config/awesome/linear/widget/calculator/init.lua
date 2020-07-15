----------------------------------------------------------------------------
--- Basic Calculator Widget
--
-- 
-- For more details check my repos README.md
--
--
-- @author manilarome &lt;gerome.matilla07@gmail.com&gt;
-- @copyright 2019 manilarome
-- @widget calculator
----------------------------------------------------------------------------

-- A basic calculator widget
-- Supports keyboard input!
--  Just hover your cursor above the calculator widget and start typing
--  Stop keygrabbing by leaving the calculator

local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widget.clickable-container')

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/calculator/icons/'

local calculator_screen = wibox.widget {
	{
		id = 'calcu_screen',
		text = '0',
		font = 'Inter Regular 20',
		align = 'right',
		valign = 'center',
		widget = wibox.widget.textbox,
	},
	margins = dpi(5),
	widget = wibox.container.margin
}

-- Evaluate
local calculate = function ()

	local calcu_screen = calculator_screen.calcu_screen

	local string_expression = calcu_screen:get_text()

	if string_expression:sub(-1):match('[%+%-%/%*%^%.]') then
		return
	end


	local func = assert(load('return ' .. string_expression))
	local ans = tostring(func())
		
	-- Convert -nan to undefined
	if ans == '-nan' then
		calcu_screen:set_text('undefined')
		return
	end

	-- Set the answer in textbox
	calcu_screen:set_text(ans)

end

local txt_on_screen = function()
	
	screen_text = calculator_screen.calcu_screen:get_text()

	return screen_text == 'inf' or screen_text == 'undefined' or screen_text == 'SYNTAX ERROR' or #screen_text == 1
end

-- Delete the last digit in screen

local delete_value = function()

	calcu_screen = calculator_screen.calcu_screen

	-- Set the screen text to 0 if conditions met
	if txt_on_screen() then
		calcu_screen:set_text('0')
	else
		-- Delete the last digit
		calcu_screen:set_text(calcu_screen:get_text():sub(1, -2))
	end
end

-- Clear screen
local clear_screen = function()

	calculator_screen.calcu_screen:set_text('0')
end

-- The one that filters and checks the user input to avoid errors and bugs
local format_screen = function(value)

	local calcu_screen = calculator_screen.calcu_screen

	-- If the screen has only 0
	if calcu_screen:get_text() == '0' then

		-- Check if the button pressed sends a value of either +, -, /, *, ^, .

		if value:sub(-1):match('[%+%/%*%^%.]') then

			calcu_screen:set_text(calcu_screen:get_text() .. tostring(value))

		else

			calcu_screen:set_text(value)

		end

	elseif calcu_screen:get_text() == 'inf' or 
		calcu_screen:get_text() == 'undefined' or
		calcu_screen:get_text() == 'SYNTAX ERROR' then

		-- Clear screen if an operator is selected
		if value:sub(-1):match('[%+%/%*%^%.]') then
			clear_screen()

		else
			-- Replace screen txt with the number value pressed
			clear_screen()
			calcu_screen:set_text(tostring(value))
		end

	else

		-- Don't let the user to input two or more consecutive arithmetic operators and decimals
		if calcu_screen:get_text():sub(-1):match('[%+%-%/%*%^%.]') and value:sub(-1):match('[%+%-%/%*%^%.%%]') then
			
			-- Get the operator from button pressed
			local string_eval = calcu_screen:get_text():sub(-1):gsub('[%+%-%/%*%^%.]', value)

			-- This will prevent the user to input consecutive operators and decimals
			-- It will replace the previous operator with the value of input
			calcu_screen:set_text(calcu_screen:get_text():sub(1, -2))

			-- Concatenate the value operator to the screen string to replace the deleted operator
			calcu_screen:set_text(calcu_screen:get_text() .. tostring(string_eval))
		
		else
			-- Concatenate the value to screen string
			calcu_screen:set_text(calcu_screen:get_text() .. tostring(value))
		
		end
	end

end

-- Shape generator
local build_shape = function (position, radius)
	
	-- Position represents the position of rounded corners
	if position == 'top' then
		return function(cr, width, height)
			gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, radius)
		end

	elseif position == 'top_left' then
		return function(cr, width, height)
			gears.shape.partially_rounded_rect(cr, width, height, true, false, false, false, radius)
		end

	elseif position == 'top_right' then
		return function(cr, width, height)
			gears.shape.partially_rounded_rect(cr, width, height, false, true, false, false, radius)
		end

	elseif position == 'bottom_right' then
		return function(cr, width, height)
			gears.shape.partially_rounded_rect(cr, width, height, false, false, true, false, radius)
		end

	elseif position == 'bottom_left' then
		return function(cr, width, height)
			gears.shape.partially_rounded_rect(cr, width, height, false, false, false, true, radius)
		end

	else
		return function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, radius)
		end

	end
end

-- Themes widgets
local decorate_widget = function(widget_arg, pos, rad)
	return wibox.widget {
		widget_arg,
		bg = beautiful.groups_bg,
		border_width = dpi(1),
		border_color = beautiful.groups_title_bg,
		shape = build_shape(pos, rad),
		widget = wibox.container.background
	}
end

-- Build a button
local build_button_widget = function(text, rcp, rad)

	local value = text

	local build_textbox = wibox.widget {
		{
			id = 'btn_name',
			text =  value,
			font = 'Inter 12',
			align = 'center',
			valign = 'center',
			widget = wibox.widget.textbox,
		},
		margins = dpi(5),
		widget = wibox.container.margin
	}

	local build_button = wibox.widget {
		{
			build_textbox,
			margins = dpi(7),
			widget = wibox.container.margin
		},
		widget = clickable_container
	}

	build_button:buttons(
		gears.table.join(
			awful.button(
				{}, 
				1, 
				nil, 
				function ()

					if value == 'C' then
						clear_screen()

					elseif value == '=' then
						-- Calculate and error handling
						if not pcall(calculate) then
							calculator_screen.calcu_screen:set_text('SYNTAX ERROR')
						end

					elseif value == 'DEL' then
						delete_value()

					else
						format_screen(value)

					end
				end
			)
		)
	)

	return decorate_widget(build_button, rcp, rad)

end

local keygrab_running = false

local kb_imagebox = wibox.widget {
	
	id = 'kb_icon',
	image = widget_icon_dir .. 'kb-off' .. '.svg',
	resize = true,
	forced_height = dpi(15),
	widget = wibox.widget.imagebox
}

local kb_button_widget = wibox.widget {
	{
		{
			{
				layout = wibox.layout.align.horizontal,
				expand = 'none',
				nil,
				kb_imagebox,
				nil
			},
			margins = dpi(10),
			widget = wibox.container.margin
		},
		widget = clickable_container
	},
	bg = beautiful.groups_bg,
	shape = build_shape('bottom_left', beautiful.groups_radius),
	widget = wibox.container.background
}

local toggle_btn_keygrab = function()

	if keygrab_running then
		kb_imagebox:set_image(widget_icon_dir .. 'kb-off' .. '.svg')
		awesome.emit_signal('widget::calc_stop_keygrab')
		keygrab_running = false
	else
		kb_imagebox:set_image(widget_icon_dir .. 'kb' .. '.svg')
		awesome.emit_signal('widget::calc_start_keygrab')
		keygrab_running = true
	end

end

local kb_button = kb_button_widget

kb_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				toggle_btn_keygrab()
			end
		)
	)
)

local calcu_keygrabber = awful.keygrabber {
	
	auto_start          = true,
	stop_event          = 'release',
	start_callback      = function()

		keygrab_running = true
		kb_imagebox:set_image(widget_icon_dir .. 'kb' .. '.svg')

	end,
	stop_callback = function() 

		keygrab_running = false
		kb_imagebox:set_image(widget_icon_dir .. 'kb-off' .. '.svg')

	end,
	keypressed_callback = function(self, mod, key, command) 

		if #key == 1 and (key:match('%d+') or key:match('[%+%-%/%*%^%.]')) then
			format_screen(key)

		elseif key == 'BackSpace' then
			delete_value()

		elseif key == 'Escape' then
			clear_screen()

		elseif key == 'x' then
			awesome.emit_signal('widget::calc_stop_keygrab')

		elseif key == '=' or key == 'Return' then
			-- Calculate
			if not pcall(calculate) then
				calculator_screen.calcu_screen:set_text('SYNTAX ERROR')
			end

		end

	end,
}

local calculator_body = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	spacing = dpi(1),
	{
		spacing = dpi(1),
		layout = wibox.layout.flex.horizontal,
		decorate_widget(calculator_screen, 'top', beautiful.groups_radius),
	},
	{
		spacing = dpi(1),
		layout = wibox.layout.flex.horizontal,
		build_button_widget('C', 'flat' , 0),
		build_button_widget('^', 'flat', 0),
		build_button_widget('/', 'flat', 0),
		build_button_widget('DEL', 'flat', 0),
	},
	{
		spacing = dpi(1),
		layout = wibox.layout.flex.horizontal,
		build_button_widget('7', 'flat', 0),
		build_button_widget('8', 'flat', 0),
		build_button_widget('9', 'flat', 0),
		build_button_widget('*', 'flat', 0),
	},
	{
		spacing = dpi(1),
		layout = wibox.layout.flex.horizontal,
		build_button_widget('4', 'flat', 0),
		build_button_widget('5', 'flat', 0),
		build_button_widget('6', 'flat', 0),
		build_button_widget('-', 'flat', 0),
	},
	{
		spacing = dpi(1),
		layout = wibox.layout.flex.horizontal,
		build_button_widget('1', 'flat', 0),
		build_button_widget('2', 'flat', 0),
		build_button_widget('3', 'flat', 0),
		build_button_widget('+', 'flat', 0),
	},
	{
		spacing = dpi(1),
		layout = wibox.layout.flex.horizontal,
		kb_button,
		build_button_widget('0', 'flat', 0),
		build_button_widget('.', 'flat', 0),
		build_button_widget('=', 'bottom_right', beautiful.groups_radius)
	},
}

calculator_body:connect_signal(
	'mouse::enter',
	function() 
		-- Start keygrabbing
		calcu_keygrabber:start()
	end
)

calculator_body:connect_signal(
	'mouse::leave',
	function()
		-- Stop keygrabbing
		calcu_keygrabber:stop()
	end
)

awesome.connect_signal(
	'widget::calc_start_keygrab',
	function() 
		-- Stop keygrabbing
		calcu_keygrabber:start()
	end
)

awesome.connect_signal(
	'widget::calc_stop_keygrab',
	function() 
		-- Stop keygrabbing
		calcu_keygrabber:stop()
	end
)

local calcu_tooltip = awful.tooltip {

	objects = {kb_button},
	mode = 'outside',
	align = 'right',
	delay_show = 1,
	preferred_positions = {'right', 'left', 'top', 'bottom'},
	margin_leftright = dpi(8),
	margin_topbottom = dpi(8),
	markup = [[
	<b>Tips:</b>
	Enable keyboard support by hovering your mouse above the calculator.
	Or toggle it on/off by pressing the keyboard button.
	Only numbers, arithmetic operators, and decimal point is accepted.

	<b>Keyboard bindings:</b>
	<b>=</b> and <b>Return</b> to get the answer.
	<b>BackSpace</b> to delete the last digit.
	<b>Escape</b> clears the screen.
	<b>x</b> stops keygrabbing.

	<b>Note:</b>
	While in keygrabbing mode, your keyboard's focus will be on the calculator.
	So you're AwesomeWM keybinding will stop working. 

	<b>Stopping the keygrabbing mode:</b>
	* Move away your cursor from the calculator. 
	* Toggle it off using the keyboard button.
	* Press <b>x</b>.
	]]
}

return calculator_body
