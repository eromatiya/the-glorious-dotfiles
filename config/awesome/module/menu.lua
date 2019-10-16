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
beautiful.menu_bg_focus = '#8AB4F8AA'
beautiful.menu_bg_normal = '#00000044'
beautiful.menu_submenu = '➤'
beautiful.menu_border_width = 20
beautiful.menu_border_color = '#00000075'

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
    {"Atom", "env ATOM_DISABLE_SHELLING_OUT_FOR_ENVIRONMENT=false /usr/bin/atom ", "/usr/share/icons/hicolor/16x16/apps/atom.png" },
    {"Calculator", "gnome-calculator"},
    {"Document Viewer", "xreader ", "/usr/share/icons/hicolor/16x16/apps/xreader.png" },
    {"Nemo", "nemo "},
    {"Neovim", "xterm -e nvim ", "/usr/share/pixmaps/nvim.png" },
    {"Redshift", "redshift-gtk"},
    {"compton", "compton", "/usr/share/icons/hicolor/48x48/apps/compton.png" },
}

local menu251bd8143891238ecedc306508e29017 = {
    {"SuperTuxKart", "supertuxkart", "/usr/share/icons/hicolor/48x48/apps/supertuxkart.png" },
}

local menud334dfcea59127bedfcdbe0a3ee7f494 = {
    {"GNU Image Manipulation Program", "gimp-2.10 ", "/usr/share/icons/hicolor/16x16/apps/gimp.png" },
    {"Inkscape", "inkscape ", "/usr/share/icons/hicolor/16x16/apps/inkscape.png" },
}

local menuc8205c7636e728d448c2774e6a4a944b = {
    {"Avahi SSH Server Browser", "/usr/bin/bssh"},
    {"Avahi VNC Server Browser", "/usr/bin/bvnc"},
    {"Firefox", "/usr/lib/firefox/firefox ", "/usr/share/icons/hicolor/16x16/apps/firefox.png" },
    {"Transmission", "transmission-gtk ", "/usr/share/icons/hicolor/16x16/apps/transmission.png" },
}

local menue6f43c40ab1c07cd29e4e83e4ef6bf85 = {
    {"Atom", "env ATOM_DISABLE_SHELLING_OUT_FOR_ENVIRONMENT=false /usr/bin/atom ", "/usr/share/icons/hicolor/16x16/apps/atom.png" },
    {"Electron 4", "electron4 ", "/usr/share/pixmaps/electron4.png" },
}

local menu52dd1c847264a75f400961bfb4d1c849 = {
    {"Cheese", "cheese"},
    {"PulseAudio Volume Control", "pavucontrol"},
    {"PulseEffects", "pulseeffects"},
    {"Qt V4L2 test Utility", "qv4l2", "/usr/share/icons/hicolor/16x16/apps/qv4l2.png" },
    {"Qt V4L2 video capture utility", "qvidcap", "/usr/share/icons/hicolor/16x16/apps/qvidcap.png" },
    {"SimpleScreenRecorder", "simplescreenrecorder --logfile", "/usr/share/icons/hicolor/16x16/apps/simplescreenrecorder.png" },
    {"Sound Recorder", "gnome-sound-recorder"},
    {"Spotify", "spotify ", "/usr/share/pixmaps/spotify-client.png" },
    {"VLC media player", "/usr/bin/vlc --started-from-file ", "/usr/share/icons/hicolor/16x16/apps/vlc.png" },
    {"flowblade", "env GDK_BACKEND=x11 flowblade ", "/usr/share/icons/hicolor/128x128/apps/io.github.jliljebl.Flowblade.png" },
}

local menuee69799670a33f75d45c57d1d1cd0ab3 = {
    {"Avahi Zeroconf Browser", "/usr/bin/avahi-discover"},
    {"Oracle VM VirtualBox", "VirtualBox ", "/usr/share/icons/hicolor/16x16/mimetypes/virtualbox.png" },
    {"System Monitor", "gnome-system-monitor"},
    {"UXTerm", "uxterm", "/usr/share/pixmaps/xterm-color_48x48.xpm" },
    {"XTerm", "xterm", "/usr/share/pixmaps/xterm-color_48x48.xpm" },
    {"dconf Editor", "dconf-editor", "/usr/share/icons/hicolor/16x16/apps/ca.desrt.dconf-editor.png" },
    {"kitty", "kitty", "/usr/share/icons/hicolor/256x256/apps/kitty.png" },
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
