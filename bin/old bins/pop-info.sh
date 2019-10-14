#!/bin/bash

toggle=$(<$HOME/.toggleinfo)				#Read the value of file .toggle


if [[ $toggle -eq 1 ]]; then								#if toggle is equals to 1 then show hidden polybar
	sh $HOME/.config/polybar/polybar-scripts/hidesysinfo.sh -s
	echo "0" > $HOME/.toggleinfo

else														#else hide hidden bar
	sh $HOME/.config/polybar/polybar-scripts/hidesysinfo.sh -h
	echo "1" > $HOME/.toggleinfo
fi

