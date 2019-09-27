#!/usr/bin/env bash



#Keyboard Shortcut
sxhkd &



#xfce goodies
run_once xfce4-session &




#dpi
#xrandr --dpi 125.37




#Restore cursor theme
xsetroot -cursor_name left_ptr


#WAL
#run_once wal -Rn &





#XWINWRAP
#run_once winwrap &






#Restore wallpaper
nitrogen --restore
#feh --bg-scale ~/Pictures/Wallpapers/pink-house.jpg






#Music is layf
run_once mpd &








#Notification
pkill dunst
run_once dunst &



 




#Compositor
run_once compton &






#Enable tap
#run_once synclient TapButton1=1 





#flashfocus
#pkill flashfocus
#flashfocus &






## hides mouse when you are not using it. When mouse is hidden, rootmenu considers mouse on desktop, so actions can be triggered.
run_once unclutter &





#Termial Emulator
run_once urxvtd &


#Tint2
sh $HOME/.config/tint2/launchtint.sh &
sleep 3



#lock in idle
#xautolock -time 1 -locker "run_once betterlockscreen -l &"





#Snowwwww
#pkill xsnow
#xsnow -nosanta -notrees -norudolf -xspeed 10 -windtimer 5



#Auto-hide sys-tray
#pkill hideIt.sh
#sleep 5
#hideIt.sh --name '^Polybar tray window$' --signal --peek 0 --direction right




#Conky
#sh $HOME/.config/conky/launch.sh  &


#Polybar
sh $HOME/.config/polybar/launch.sh
#sh $HOME/.config/polybar/launch2.sh



run_once xdo raise -N Plank



bottint