-- Load these libraries (if you haven't already)
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

-- Create the box
local anti_aliased_wibox = wibox({visible = true, ontop = true, type = "normal", height = 100, width = 100})

-- Place it at the center of the screen
awful.placement.centered(anti_aliased_wibox)

-- Set transparent bg
anti_aliased_wibox.bg = "#00000000"

-- Put its items in a shaped container
anti_aliased_wibox:setup {
    -- Container
    {
        -- Items go here
        --wibox.widget.textbox("Hello!"),
        awful.spawn('urxvt'),
        -- ...
        layout = wibox.layout.fixed.vertical
    },
    -- The real background color
    bg = "#111111",
    -- The real, anti-aliased shape
    shape = gears.shape.rounded_rect,
    widget = wibox.container.background()
}
