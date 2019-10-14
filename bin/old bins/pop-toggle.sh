#!/bin/bash

toggle=$(<$HOME/.toggle)				#Read the value of file .toggle


if [[ $toggle -eq 1 ]]; then								#if toggle is equals to 1 then show hidden polybar
	sh $HOME/.config/polybar/polybar-scripts/hidemusic.sh -s
	echo "0" > $HOME/.toggle

else														#else hide hidden bar
	sh $HOME/.config/polybar/polybar-scripts/hidemusic.sh -h
	echo "1" > $HOME/.toggle
fi

