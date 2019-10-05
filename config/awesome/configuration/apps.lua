local filesystem = require('gears.filesystem')

return {
  -- List of apps to start by default on some actions
  default = {
    terminal = 'kitty',
    editor = 'atom',
    rofi = 'rofi -show drun -theme ' .. filesystem.get_configuration_dir() .. '/configuration/rofi/sidebar/rofi.rasi',
    rofiappmenu = 'rofi -show drun -theme ' .. filesystem.get_configuration_dir() .. '/configuration/rofi/appmenu/drun.rasi',
    lock = 'dm-tool lock' --[['i3lock-fancy-rapid 5 3 -k --timecolor=ffffffff --datecolor=ffffffff']],
    quake = 'kitty --title QuakeTerminal'
  },
  -- List of apps to start once on start-up
  run_on_start_up = {
    'compton --config ' .. filesystem.get_configuration_dir() .. '/configuration/compton.conf',
    'blueman-applet', -- Bluetooth tray icon
    'xfce4-power-manager', -- Power manager
    '/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)', -- credential manager
    'xfsettingsd', -- Settings
    'nitrogen --restore', -- Wallpaper
    'xrdb $HOME/.Xresources',
    'nm-applet',
    'mpd',
    'redshift-gtk -l 14.45:121.05'
  }
}
