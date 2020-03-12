#!/bin/bash

NETWORK=$(echo $(iwgetid -r))


if [[ ! -z $NETWORK ]]; then
	dunstify -r 777 '' $NETWORK
else
	dunstify -r 555 '' "You're not connected to any wireless network."
fi