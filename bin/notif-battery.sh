#!/bin/bash
status="$(< /sys/class/power_supply/BAT0/status)"
capacity="$(< /sys/class/power_supply/BAT0/capacity)"

dunstify -r 100 "Your Lovely Battery! :)" "Battery percentage is $capacity% and is currenly $status."