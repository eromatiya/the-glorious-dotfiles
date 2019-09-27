local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local apps = require('configuration.apps')
local hotkeys_popup = require('awful.hotkeys_popup').widget

terminal = apps.default.terminal
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor




-- Theming Menu
beautiful.menu_font = "Google Sans Bold 10"
beautiful.menu_height = 28
beautiful.menu_width = 180
beautiful.menu_bg_focus = '#8AB4F8AA'
beautiful.menu_bg_normal = '#00000044'
beautiful.menu_submenu = ''

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
  { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "Edit config", editor_cmd .. " " .. awesome.conffile },
  { "Restart", awesome.restart },
  { "Quit", function() awesome.quit() end },
}

myterminalmenu = {
  { "URxvt", function() awful.spawn('urxvt') end },
  { "XTerm", function() awful.spawn('xterm') end },
  { "UXTerm", function() awful.spawn('uxterm') end }
}
mybrowsermenu = {
  { "Firefox", function() awful.spawn('firefox') end}
}
myeditorsmenu = {
  { "Atom", function() awful.spawn('atom') end }
}
myfilemanagermenu = {
  { "Nemo", function() awful.spawn('nemo') end },
  { "File-Roller", function() awful.spawn('file-roller') end }
}
mymultimediamenu = {
  { "VLC Media Player",  function() awful.spawn('vlc') end },
  { "Spotify",  function() awful.spawn('spotify') end }
}
mygamesmenu = {
  { "SuperTuxKart", function() awful.spawn('supertuxkart') end }
}
myeditingtoolsmenu = {
  { "GIMP",  function() awful.spawn('gimp-2.10') end },
  { "Inkscape", function() awful.spawn('inkscape') end }
}

mymainmenu = awful.menu({
  items = {
                                  { "Terminals", myterminalmenu, beautiful.awesome_icon },
                                  { "Browsers", mybrowsermenu, beautiful.awesome_icon },
                                  { "Text Editors", myeditorsmenu, beautiful.awesome_icon },
                                  { "File Manager", myfilemanagermenu, beautiful.awesome_icon },
                                  { "Multimedia", mymultimediamenu, beautiful.awesome_icon },
                                  { "Games", mygamesmenu, beautiful.awesome_icon },
                                  { "Editors", myeditingtoolsmenu, beautiful.awesome_icon },
                                  { "Awesome Settings", myawesomemenu, beautiful.awesome_icon },
  }
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- Embed mouse bindings
root.buttons(gears.table.join(awful.button({ }, 3, function () mymainmenu:toggle() end)))
