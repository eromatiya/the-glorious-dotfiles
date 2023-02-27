local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local icons = require("theme." .. THEME .. ".icons")
local tag_list = require("widget.tag-list")
local clickable_container = require("widget.clickable-container")
local search_apps = require("widget.search-apps")
local xdg_folders_builder = require("widget.xdg-folders.builder")

return function(s, panel, action_bar_width)
  local menu_icon = wibox.widget({
    {
      id = "menu_btn",
      image = icons.menu,
      resize = true,
      widget = wibox.widget.imagebox,
    },
    margins = dpi(10),
    widget = wibox.container.margin,
  })

  local open_dashboard_button = wibox.widget({
    {
      menu_icon,
      widget = clickable_container,
    },
    bg = beautiful.background .. "66",
    widget = wibox.container.background,
  })

  open_dashboard_button:buttons(gears.table.join(awful.button({}, 1, nil, function()
    panel:toggle()
  end)))

  panel:connect_signal("opened", function()
    menu_icon.menu_btn:set_image(gears.surface(icons.close_small))
  end)

  panel:connect_signal("closed", function()
    menu_icon.menu_btn:set_image(gears.surface(icons.menu))
  end)

  return wibox.widget({
    id = "action_bar",
    layout = wibox.layout.align.vertical,
    forced_width = action_bar_width,
    {
      search_apps(),
      tag_list(s),
      xdg_folders_builder
          :with_separator()
          :with_home()
          :with_downloads()
          :with_documents()
          :with_separator()
          :with_trash()
          :vertical()
          :build(),
      layout = wibox.layout.fixed.vertical,
    },
    nil,
    open_dashboard_button,
  })
end
