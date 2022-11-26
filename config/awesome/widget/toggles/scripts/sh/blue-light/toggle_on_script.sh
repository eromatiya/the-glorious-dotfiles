CONFIG_PATH=$(ps aux | grep -i picom | grep -Po '(?<=config).*') 
killall picom 
picom -b --experimental-backends --blur-method "dual_kawase" --dbus --config $CONFIG_PATH
