local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widget.material.clickable-container')


--##########
-- UI formatting
--##########

-- Return shape to widget_wrapper()
-- Position represents the position of rounded corners
local gen_shape = function (position, radius)
  if position == 'top_left_right' then
    return function(cr, width, height) gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, radius) end
  elseif position == 'top_left' then
    return function(cr, width, height) gears.shape.partially_rounded_rect(cr, width, height, true, false, false, false, radius) end
  elseif position == 'top_right' then
    return function(cr, width, height) gears.shape.partially_rounded_rect(cr, width, height, false, true, false, false, radius) end
  elseif position == 'bottom_right' then
    return function(cr, width, height) gears.shape.partially_rounded_rect(cr, width, height, false, false, true, false, radius) end
  elseif position == 'bottom_left' then
    return function(cr, width, height) gears.shape.partially_rounded_rect(cr, width, height, false, false, false, true, radius) end
  else
    return function(cr, width, height) gears.shape.rounded_rect(cr, width, height, radius) end
  end
end


-- Themes button and screens
local widget_wrapper = function(widget_arg, pos, rad)
  return wibox.widget {
    widget_arg,
    bg = beautiful.bg_modal,
    shape = gen_shape(pos, rad),
    widget = wibox.container.background
  }
end

--##########
-- SCREEN
--##########
local calculator_screen = wibox.widget {
  {
    id = 'calcu_screen',
    text = '0',
    font = 'SFNS Display 20',
    align = 'right',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(5),
  widget = wibox.container.margin
}


--##########
-- Functions
--##########

-- The place where magic happens
-- It calculates/evaluates the arithmetic expression
local calculate = function ()
  -- If the last digit in screen is an operator, do not evaluate to avoid errors
  if not string.match(string.sub(calculator_screen.calcu_screen.text, -1), "[%+%-%/%*%^%.]") then
    local string_expression = calculator_screen.calcu_screen.text
    func = assert(load("return " .. string_expression))
    ans = func()
    -- Set the answer in textbox
    calculator_screen.calcu_screen:set_text(ans)
  end
end

-- Delete the last digit in screen
local delete_value = function()
  -- Check string length to prevent emptying the textbox(making it nil) or if inf
  if calculator_screen.calcu_screen.text == 'inf' or tonumber(string.len(calculator_screen.calcu_screen.text)) == 1 then
    calculator_screen.calcu_screen:set_text('0')
  else
    -- Delete the last digit in screen
    calculator_screen.calcu_screen:set_text(calculator_screen.calcu_screen.text:sub(1, -2))
  end
end

-- Clear screen, return to 0
-- Gold Experience Requiem
local clear_screen = function()
  calculator_screen.calcu_screen:set_text('0')
end


-- The one that filters and checks the user input to avoid errors and bugs
local format_screen = function(value)
  -- If the screen has only 0
  if calculator_screen.calcu_screen.text == '0' then
    -- Check if the button pressed sends a value of either +, -, /, *, ^, .
    if string.match(string.sub(value, -1), "[%+%/%*%^%.]") then
      -- If the operators above are detected then concatenate it to 0
      calculator_screen.calcu_screen:set_text(calculator_screen.calcu_screen.text .. tostring(value))
    else
      -- Else, it detects a number so overwrite the 0 with the value
      calculator_screen.calcu_screen:set_text(value)
    end

  elseif  calculator_screen.calcu_screen.text == 'inf' then

    -- Clear screen if an operator is selected
    if string.match(string.sub(value, -1), "[%+%-%/%*%^%.]") then
      clear_screen()
    else
      -- Replace inf to the number value pressed
      clear_screen()
      calculator_screen.calcu_screen:set_text(tostring(value))
    end

  else
    -- Don't let the user to input two or more consecutive arithmetic operators and decimals
    if string.match(string.sub(calculator_screen.calcu_screen.text, -1), "[%+%-%/%*%^%.]") and string.match(string.sub(value, -1), "[%+%-%/%*%^%.%%]") then
      local string_eval
      -- Get the operator from button pressed
      string_eval = string.gsub(string.sub(calculator_screen.calcu_screen.text, -1), "[%+%-%/%*%^%.]", value)
      -- This will prevent the user to input consecutive operators and decimals
      -- It will replace the previous operator with the value of input
      calculator_screen.calcu_screen:set_text(calculator_screen.calcu_screen.text:sub(1, -2))
      -- Concatenate the value operator to the screen string to replace the deleted operator
      calculator_screen.calcu_screen:set_text(calculator_screen.calcu_screen.text .. tostring(string_eval))
    else
      -- Concatenate the value to screen string
      calculator_screen.calcu_screen:set_text(calculator_screen.calcu_screen.text .. tostring(value))
    end
  end

end


--##########
-- BODY
--##########

-- TOP ROW
local c_widget = wibox.widget {
  wibox.widget {
    text = 'C',
    font = 'SFNS Display 12',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(5),
  widget = wibox.container.margin
  -- layout = wibox.layout.fixed
}
local c_widget_button = clickable_container(wibox.container.margin(c_widget, dpi(7), dpi(7), dpi(7), dpi(7)))
c_widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        clear_screen()
      end
    )
  )
)

local division_widget = wibox.widget {
  wibox.widget {
    text = '/',
    font = 'SFNS Display 12',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(5),
  widget = wibox.container.margin
}
local division_widget_button = clickable_container(wibox.container.margin(division_widget, dpi(7), dpi(7), dpi(7), dpi(7)))
division_widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        format_screen('/')
      end
    )
  )
)

local delete_widget = wibox.widget {
  wibox.widget {
    text = 'DEL',
    font = 'SFNS Display 12',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(5),
  widget = wibox.container.margin
}
local delete_widget_button = clickable_container(wibox.container.margin(delete_widget, dpi(7), dpi(7), dpi(7), dpi(7)))
delete_widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        delete_value()
      end
    )
  )
)



-- 2nd ROW

local seven_widget = wibox.widget {
  wibox.widget {
    text = '7',
    font = 'SFNS Display 12',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(5),
  widget = wibox.container.margin
  -- layout = wibox.layout.fixed
}
local seven_widget_button = clickable_container(wibox.container.margin(seven_widget, dpi(7), dpi(7), dpi(7), dpi(7)))
seven_widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        format_screen('7')
      end
    )
  )
)


local eight_widget = wibox.widget {
  wibox.widget {
    text = '8',
    font = 'SFNS Display 12',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(5),
  widget = wibox.container.margin
}
local eight_widget_button = clickable_container(wibox.container.margin(eight_widget, dpi(7), dpi(7), dpi(7), dpi(7)))
eight_widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        format_screen('8')
      end
    )
  )
)

local nine_widget = wibox.widget {
  wibox.widget {
    text = '9',
    font = 'SFNS Display 12',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(5),
  widget = wibox.container.margin
}
local nine_widget_button = clickable_container(wibox.container.margin(nine_widget, dpi(7), dpi(7), dpi(7), dpi(7)))
nine_widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        format_screen('9')
      end
    )
  )
)

local multiplication_widget = wibox.widget {
  wibox.widget {
    text = '*',
    font = 'SFNS Display 12',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(5),
  widget = wibox.container.margin
}
local multiplication_widget_button = clickable_container(wibox.container.margin(multiplication_widget, dpi(7), dpi(7), dpi(7), dpi(7)))
multiplication_widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        format_screen('*')
      end
    )
  )
)




-- 3rd ROW

local four_widget = wibox.widget {
  wibox.widget {
    text = '4',
    font = 'SFNS Display 12',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(5),
  widget = wibox.container.margin
  -- layout = wibox.layout.fixed
}
local four_widget_button = clickable_container(wibox.container.margin(four_widget, dpi(7), dpi(7), dpi(7), dpi(7)))
four_widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        format_screen('4')
      end
    )
  )
)


local five_widget = wibox.widget {
  wibox.widget {
    text = '5',
    font = 'SFNS Display 12',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(5),
  widget = wibox.container.margin
}
local five_widget_button = clickable_container(wibox.container.margin(five_widget, dpi(7), dpi(7), dpi(7), dpi(7)))
five_widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        format_screen('5')
      end
    )
  )
)

local six_widget = wibox.widget {
  wibox.widget {
    text = '6',
    font = 'SFNS Display 12',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(5),
  widget = wibox.container.margin
}
local six_widget_button = clickable_container(wibox.container.margin(six_widget, dpi(7), dpi(7), dpi(7), dpi(7)))
six_widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        format_screen('6')
      end
    )
  )
)

local subtraction_widget = wibox.widget {
  wibox.widget {
    text = '-',
    font = 'SFNS Display 12',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(5),
  widget = wibox.container.margin
}
local subtraction_widget_button = clickable_container(wibox.container.margin(subtraction_widget, dpi(7), dpi(7), dpi(7), dpi(7)))
subtraction_widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        format_screen('-')
      end
    )
  )
)


-- 4th ROW

local one_widget = wibox.widget {
  wibox.widget {
    text = '1',
    font = 'SFNS Display 12',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(5),
  widget = wibox.container.margin
  -- layout = wibox.layout.fixed
}
local one_widget_button = clickable_container(wibox.container.margin(one_widget, dpi(7), dpi(7), dpi(7), dpi(7)))
one_widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        format_screen('1')
      end
    )
  )
)


local two_widget = wibox.widget {
  wibox.widget {
    text = '2',
    font = 'SFNS Display 12',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(5),
  widget = wibox.container.margin
}
local two_widget_button = clickable_container(wibox.container.margin(two_widget, dpi(7), dpi(7), dpi(7), dpi(7)))
two_widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        format_screen('2')
      end
    )
  )
)

local three_widget = wibox.widget {
  wibox.widget {
    text = '3',
    font = 'SFNS Display 12',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(5),
  widget = wibox.container.margin
}
local three_widget_button = clickable_container(wibox.container.margin(three_widget, dpi(7), dpi(7), dpi(7), dpi(7)))
three_widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        format_screen('3')
      end
    )
  )
)

local addition_widget = wibox.widget {
  wibox.widget {
    text = '+',
    font = 'SFNS Display 12',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(5),
  widget = wibox.container.margin
}
local addition_widget_button = clickable_container(wibox.container.margin(addition_widget, dpi(7), dpi(7), dpi(7), dpi(7)))
addition_widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        format_screen('+')
      end
    )
  )
)

-- LAST FUCKIN ROW

local zero_widget = wibox.widget {
  wibox.widget {
    text = '0',
    font = 'SFNS Display 12',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(5),
  widget = wibox.container.margin
}
local zero_widget_button = clickable_container(wibox.container.margin(zero_widget, dpi(7), dpi(7), dpi(7), dpi(7)))
zero_widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        format_screen('0')
      end
    )
  )
)

local exponent_widget = wibox.widget {
  wibox.widget {
    text = '^',
    font = 'SFNS Display 12',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(5),
  widget = wibox.container.margin
}
local exponent_widget_button = clickable_container(wibox.container.margin(exponent_widget, dpi(7), dpi(7), dpi(7), dpi(7)))
exponent_widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        format_screen('^')
      end
    )
  )
)

local decimal_widget = wibox.widget {
  wibox.widget {
    text = '.',
    font = 'SFNS Display 12',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(5),
  widget = wibox.container.margin
}
local decimal_widget_button = clickable_container(wibox.container.margin(decimal_widget, dpi(7), dpi(7), dpi(7), dpi(7)))
decimal_widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        format_screen('.')
      end
    )
  )
)

local equals_widget = wibox.widget {
  wibox.widget {
    text = '=',
    font = 'SFNS Display 12',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(5),
  widget = wibox.container.margin
}
local equals_widget_button = clickable_container(wibox.container.margin(equals_widget, dpi(7), dpi(7), dpi(7), dpi(7)))
equals_widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        -- format_screen('=')
        calculate()
      end
    )
  )
)



--##########
-- HEADER
--##########

local calculator_header = wibox.widget {
  wibox.widget {
    text = 'Calculator',
    font = 'SFNS Display 14',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
  },
  margins = dpi(10),
  widget = wibox.container.margin
}

--##########
-- LAYOUT
--##########

local calculator_body = wibox.widget {
  layout = wibox.layout.fixed.vertical,
  spacing = dpi(1),
  {
    {
      calculator_header,
      bg = beautiful.bg_modal_title,
      shape = function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, beautiful.modal_radius) end,
      widget = wibox.container.background,
    },
    layout = wibox.layout.flex.horizontal,
  },
  {
    spacing = dpi(1),
    layout = wibox.layout.flex.horizontal,
    widget_wrapper(calculator_screen, 'flat', 0),
  },
  {
    spacing = dpi(1),
    layout = wibox.layout.flex.horizontal,
    widget_wrapper(c_widget_button, 'flat', 0),
    widget_wrapper(exponent_widget_button, 'flat', 0),
    widget_wrapper(division_widget_button, 'flat', 0),
    widget_wrapper(delete_widget_button, 'flat', 0),
  },
  {
    spacing = dpi(1),
    layout = wibox.layout.flex.horizontal,
    widget_wrapper(seven_widget_button, 'flat', 0),
    widget_wrapper(eight_widget_button, 'flat', 0),
    widget_wrapper(nine_widget_button, 'flat', 0),
    widget_wrapper(multiplication_widget_button, 'flat', 0),
  },
  {
    spacing = dpi(1),
    layout = wibox.layout.flex.horizontal,
    widget_wrapper(four_widget_button, 'flat', 0),
    widget_wrapper(five_widget_button, 'flat', 0),
    widget_wrapper(six_widget_button, 'flat', 0),
    widget_wrapper(subtraction_widget_button, 'flat', 0),
  },
  {
    spacing = dpi(1),
    layout = wibox.layout.flex.horizontal,
    widget_wrapper(one_widget_button, 'flat', 0),
    widget_wrapper(two_widget_button, 'flat', 0),
    widget_wrapper(three_widget_button, 'flat', 0),
    widget_wrapper(addition_widget_button, 'flat', 0),
  },
  {
    spacing = dpi(1),
    layout = wibox.layout.flex.horizontal,
    widget_wrapper(zero_widget_button, 'bottom_left', 6),
    {
      spacing = dpi(1),
      layout = wibox.layout.flex.horizontal,
      widget_wrapper(decimal_widget_button, 'flat', 0),
      widget_wrapper(equals_widget_button, 'bottom_right', beautiful.modal_radius),
    },
  },
}

-- Return to right-panel
return calculator_body
