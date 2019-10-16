-- TO GENERATE MENU YOU NEED TO INSTALL XDG-MENU
-- IF YOURE USING ARCH IT IS CALLED `archlinux-xdg-menu`
-- THEN EXECUTE
-- xdg_menu --format awesome --root-menu /etc/xdg/menus/arch-applications.menu >~/.config/awesome/archmenu.lua
-- IT WILL GENERATE A MENU LIST IN archmenu.lua
-- Just substitute or transfer the generated list to this module.

local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local apps = require('configuration.apps')
local hotkeys_popup = require('awful.hotkeys_popup').widget

terminal = apps.default.terminal
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor


-- Theming Menu
beautiful.menu_font = "SFNS Display Regular 10"
beautiful.menu_submenu = '' -- ➤

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
  { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "Edit config", editor_cmd .. " " .. awesome.conffile },
  { "Restart", awesome.restart },
  { "Quit", function() awesome.quit() end },
}

local menu98edb85b00d9527ad5acebe451b3fae6 = {
    {"Archive Manager", "file-roller "},
    {"Atom", "env ATOM_DISABLE_SHELLING_OUT_FOR_ENVIRONMENT=false /usr/bin/atom " },
    {"Calculator", "gnome-calculator"},
    {"Document Viewer", "xreader " },
    {"Nemo", "nemo "},
    {"Neovim", "xterm -e nvim " },
    {"Redshift", "redshift-gtk"},
    {"compton", "compton" },
}

local menu251bd8143891238ecedc306508e29017 = {
    {"SuperTuxKart", "supertuxkart" },
}

local menud334dfcea59127bedfcdbe0a3ee7f494 = {
    {"GNU Image Manipulation Program", "gimp-2.10 " },
    {"Inkscape", "inkscape " },
}

local menuc8205c7636e728d448c2774e6a4a944b = {
    {"Avahi SSH Server Browser", "/usr/bin/bssh"},
    {"Avahi VNC Server Browser", "/usr/bin/bvnc"},
    {"Firefox", "/usr/lib/firefox/firefox " },
    {"Transmission", "transmission-gtk " },
}

local menue6f43c40ab1c07cd29e4e83e4ef6bf85 = {
    {"Atom", "env ATOM_DISABLE_SHELLING_OUT_FOR_ENVIRONMENT=false /usr/bin/atom " },
    {"Electron 4", "electron4" },
}

local menu52dd1c847264a75f400961bfb4d1c849 = {
    {"Cheese", "cheese"},
    {"PulseAudio Volume Control", "pavucontrol"},
    {"PulseEffects", "pulseeffects"},
    {"Qt V4L2 test Utility", "qv4l2" },
    {"Qt V4L2 video capture utility" },
    {"SimpleScreenRecorder", "simplescreenrecorder --logfile" },
    {"Sound Recorder", "gnome-sound-recorder"},
    {"Spotify", "spotify " },
    {"VLC media player", "/usr/bin/vlc --started-from-file" },
    {"flowblade", "env GDK_BACKEND=x11 flowblade " },
}

local menuee69799670a33f75d45c57d1d1cd0ab3 = {
    {"Avahi Zeroconf Browser", "/usr/bin/avahi-discover"},
    {"Oracle VM VirtualBox", "VirtualBox "},
    {"System Monitor", "gnome-system-monitor"},
    {"UXTerm", "uxterm"},
    {"XTerm", "xterm"},
    {"dconf Editor", "dconf-editor"},
    {"kitty", "kitty"},
}

local terminal = {
  {"kitty", "kitty"},
  {"xterm", "xterm"},
}

mymainmenu = awful.menu({
  items = {
    {"Terminal", terminal},
    {"Accessories", menu98edb85b00d9527ad5acebe451b3fae6},
    {"Games", menu251bd8143891238ecedc306508e29017},
    {"Graphics", menud334dfcea59127bedfcdbe0a3ee7f494},
    {"Internet", menuc8205c7636e728d448c2774e6a4a944b},
    {"Programming", menue6f43c40ab1c07cd29e4e83e4ef6bf85},
    {"Sound & Video", menu52dd1c847264a75f400961bfb4d1c849},
    {"System Tools", menuee69799670a33f75d45c57d1d1cd0ab3},
    {"Awesome", myawesomemenu, beautiful.awesome_icon },
    {"End Session", function() _G.exit_screen_show() end},
  }
})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- Embed mouse bindings
root.buttons(gears.table.join(awful.button({ }, 3, function () mymainmenu:toggle() end)))
