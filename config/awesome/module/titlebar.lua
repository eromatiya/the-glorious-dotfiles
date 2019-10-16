local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local theme_name = "macos-small" -- Change Titlebar buttons theme here.
local titlebar_icon_path = os.getenv("HOME") .. "/.config/awesome/theme/barthemes/" .. theme_name .. "/titlebar/"
local tip = titlebar_icon_path --alias to save time/space
local titlebars = {}
local theme = {}
local dpi = require('beautiful').xresources.apply_dpi


local roundCorners = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 12)
end

-- Titlebar Colors
beautiful.titlebar_bg_focus = '#000000'
beautiful.titlebar_bg_normal = '#000000'
beautiful.titlebar_fg_focus = '#ffffff00'
beautiful.titlebar_fg_normal = '#00000000'
local titleBarSize = 30


-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {position = 'left', size = titleBarSize}) : setup {
        { -- Top
            awful.titlebar.widget.closebutton    (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.minimizebutton (c),

            layout  = wibox.layout.fixed.vertical
        },
          nil,
        { -- Bottom
			      awful.titlebar.widget.floatingbutton (c),
            layout = wibox.layout.fixed.vertical()
        },
        layout = wibox.layout.align.vertical
    }
end)



-- Define the images to load
beautiful.titlebar_close_button_normal = tip .. "close_normal.svg"
beautiful.titlebar_close_button_focus  = tip .. "close_focus.svg"
beautiful.titlebar_minimize_button_normal = tip .. "minimize_normal.svg"
beautiful.titlebar_minimize_button_focus  = tip .. "minimize_focus.svg"
beautiful.titlebar_ontop_button_normal_inactive = tip .. "ontop_normal_inactive.svg"
beautiful.titlebar_ontop_button_focus_inactive  = tip .. "ontop_focus_inactive.svg"
beautiful.titlebar_ontop_button_normal_active = tip .. "ontop_normal_active.svg"
beautiful.titlebar_ontop_button_focus_active  = tip .. "ontop_focus_active.svg"
beautiful.titlebar_sticky_button_normal_inactive = tip .. "sticky_normal_inactive.svg"
beautiful.titlebar_sticky_button_focus_inactive  = tip .. "sticky_focus_inactive.svg"
beautiful.titlebar_sticky_button_normal_active = tip .. "sticky_normal_active.svg"
beautiful.titlebar_sticky_button_focus_active  = tip .. "sticky_focus_active.svg"
beautiful.titlebar_floating_button_normal_inactive = tip .. "floating_normal_inactive.svg"
beautiful.titlebar_floating_button_focus_inactive  = tip .. "floating_focus_inactive.svg"
beautiful.titlebar_floating_button_normal_active = tip .. "floating_normal_active.svg"
beautiful.titlebar_floating_button_focus_active  = tip .. "floating_focus_active.svg"
beautiful.titlebar_maximized_button_normal_inactive = tip .. "maximized_normal_inactive.svg"
beautiful.titlebar_maximized_button_focus_inactive  = tip .. "maximized_focus_inactive.svg"
beautiful.titlebar_maximized_button_normal_active = tip .. "maximized_normal_active.svg"
beautiful.titlebar_maximized_button_focus_active  = tip .. "maximized_focus_active.svg"
-- hover
beautiful.titlebar_close_button_normal_hover = tip .. "close_normal_hover.svg"
beautiful.titlebar_close_button_focus_hover  = tip .. "close_focus_hover.svg"
beautiful.titlebar_minimize_button_normal_hover = tip .. "minimize_normal_hover.svg"
beautiful.titlebar_minimize_button_focus_hover  = tip .. "minimize_focus_hover.svg"
beautiful.titlebar_ontop_button_normal_inactive_hover = tip .. "ontop_normal_inactive_hover.svg"
beautiful.titlebar_ontop_button_focus_inactive_hover  = tip .. "ontop_focus_inactive_hover.svg"
beautiful.titlebar_ontop_button_normal_active_hover = tip .. "ontop_normal_active_hover.svg"
beautiful.titlebar_ontop_button_focus_active_hover  = tip .. "ontop_focus_active_hover.svg"
beautiful.titlebar_sticky_button_normal_inactive_hover = tip .. "sticky_normal_inactive_hover.svg"
beautiful.titlebar_sticky_button_focus_inactive_hover  = tip .. "sticky_focus_inactive_hover.svg"
beautiful.titlebar_sticky_button_normal_active_hover = tip .. "sticky_normal_active_hover.svg"
beautiful.titlebar_sticky_button_focus_active_hover  = tip .. "sticky_focus_active_hover.svg"
beautiful.titlebar_floating_button_normal_inactive_hover = tip .. "floating_normal_inactive_hover.svg"
beautiful.titlebar_floating_button_focus_inactive_hover  = tip .. "floating_focus_inactive_hover.svg"
beautiful.titlebar_floating_button_normal_active_hover = tip .. "floating_normal_active_hover.svg"
beautiful.titlebar_floating_button_focus_active_hover  = tip .. "floating_focus_active_hover.svg"
beautiful.titlebar_maximized_button_normal_inactive_hover = tip .. "maximized_normal_inactive_hover.svg"
beautiful.titlebar_maximized_button_focus_inactive_hover  = tip .. "maximized_focus_inactive_hover.svg"
beautiful.titlebar_maximized_button_normal_active_hover = tip .. "maximized_normal_active_hover.svg"
beautiful.titlebar_maximized_button_focus_active_hover  = tip .. "maximized_focus_active_hover.svg"


-- CUSTOM TITLEBAR FOR TERMINALS
-- You need XPROP for this to work
local kittyBar = function(c)

  if c.class == "kitty" or c.class == "XTerm" then
      awful.titlebar(c, {position = "left", bg = '#000000AA', size = titleBarSize}) : setup {
          { -- Top
              awful.titlebar.widget.closebutton    (c),
              awful.titlebar.widget.maximizedbutton(c),
              awful.titlebar.widget.minimizebutton (c),

              layout  = wibox.layout.fixed.vertical
          },
            nil,
          { -- Bottom

              awful.titlebar.widget.floatingbutton (c),
              layout = wibox.layout.fixed.vertical()
          },
          layout = wibox.layout.align.vertical
      }
  end
end


client.connect_signal("request::titlebars", function(c)
  kittyBar(c)
end)


-- Show the titlebar if it's not maximized layout
_G.tag.connect_signal("property::layout", function(t)
    local clients = t:clients()
    for k,c in pairs(clients) do
        if c.first_tag.layout.name ~= "max" then
            awful.titlebar.show(c, 'left')
        else
            awful.titlebar.hide(c, 'left')
        end
    end
end)


-- On Spawn
_G.client.connect_signal("manage", function(c)
    if c.first_tag.layout.name ~= "max" then
        awful.titlebar.show(c, 'left')
    else
        awful.titlebar.hide(c, 'left')
    end
end)


-- This is a messy script on manipulating titlebars and window shape.
-- If you can fixed it please send a PR HAHAHA
-- Plan: If first_tag.layout.name is not max and tiled_clients >1 : Show Titlebars and make client shape rounded ? Hide and make the c.shape rectangle
_G.screen.connect_signal("arrange", function(s)

  for _, c in pairs(s.clients) do
    if #s.tiled_clients >= 0 and (c.floating or c.first_tag.layout.name == 'floating') then
      awful.titlebar.show(c, 'left')
      c.shape = roundCorners
    elseif #s.tiled_clients == 1 and c.fullscreen == true then
      awful.titlebar.show(c, 'left')
      c.shape = function(cr, w, h)
        gears.shape.rectangle(cr, w, h)
      end
    elseif #s.tiled_clients >= 1 and c.fullscreen == true then
      awful.titlebar.show(c, 'left')
      c.shape = function(cr, w, h)
        gears.shape.rectangle(cr, w, h)
      end
    elseif #s.tiled_clients >= 1 and c.maximized == true then
      if c.maximized then
      awful.titlebar.show(c, 'left')
      c.shape = function(cr, w, h)
        gears.shape.rectangle(cr, w, h)
      end
    end
    elseif #s.tiled_clients == 1 and c.first_tag.layout.name == 'dwindle' then
      awful.titlebar.hide(c, 'left')
      c.shape = function(cr, w, h)
        gears.shape.rectangle(cr, w, h)
      end
    elseif #s.tiled_clients > 1 and c.first_tag.layout.name == 'dwindle' then
      awful.titlebar.show(c, 'left')
      c.shape = roundCorners
    elseif #s.tiled_clients == 1 and c.first_tag.layout.name == 'tile' then
      awful.titlebar.hide(c, 'left')
      c.shape = function(cr, w, h)
        gears.shape.rectangle(cr, w, h)
      end
    elseif #s.tiled_clients > 1 and c.first_tag.layout.name == 'tile' then
      awful.titlebar.show(c, 'left')
      c.shape = roundCorners

    end

  end

end)


_G.client.connect_signal("property::floating", function(c)
    if c.floating then
      awful.titlebar.show(c, 'left')
      awful.placement.centered(c)

    else
      awful.titlebar.hide(c, 'left')
    end
end)



return beautiful
