#!/bin/bash

BRIGHTNESS=$(</sys/class/backlight/intel_backlight/brightness)
MAXBRIGHTNES=$(</sys/class/backlight/intel_backlight/max_brightness)
PERCENT=$(echo "scale=2; $BRIGHTNESS/$MAXBRIGHTNES*100" | bc )
#dunstify -r 200 "Brightness" "$(printf "%.0f\n" "$PERCENT")%"
PERCENT=$(printf "%.0f\n" "$PERCENT")

#printf "%.0f\n" "$PERCENT"


if [[ $PERCENT -ge 0 && $PERCENT -le 17 ]]; then
	dunstify -r 200 "" "Brightness is $PERCENT%"



elif [[ $PERCENT -ge 18 && $PERCENT -le 37 ]]; then
	dunstify -r 200 "" "Brightness is $PERCENT%"


elif [[ $PERCENT -ge 38 && $PERCENT -le 57 ]]; then
	dunstify -r 200 "" "Brightness is $PERCENT%"


elif [[ $PERCENT -ge 58 && $PERCENT -le 77 ]]; then
	dunstify -r 200 "" "Brightness is $PERCENT%"

else	
	dunstify -r 200 "" "Brightness is $PERCENT%"

fi

