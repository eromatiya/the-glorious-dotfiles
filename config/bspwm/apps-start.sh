#!/usr/bin/env bash



# Keyboard Shortcut

sxhkd -c "${HOME}/.config/bspwm/configuration/sxhkd/sxhkdrc" &

# Restore cursor theme

xsetroot -cursor_name left_ptr

# Restore wallpaper

feh --bg-fill "${HOME}/Pictures/Wallpapers/no-mans-sky-8k-ultrawide-i3.jpg"

# Music is layf

mpd &>/dev/null

# Compositor

picom --experimental-backends --dbus --config ~/.config/bspwm/configuration/picom/picom.conf &

# Load Xresources

xrdb "${HOME}/.Xresources"

# nm-applet 

nm-applet &>/dev/null

# blueman applet

blueman-applet &>/dev/null

# Equalizer

pulseeffects --gapplication-service &>/dev/null

# Polkit

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &>/dev/null

# Keyring 

eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg) &>/dev/null