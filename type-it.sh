#!/bin/bash
#bind this to a keyboard key for best results.
#set primary clipboard contents to variable 
info=`xsel -o`
sleep 1
#type it into current window
xdotool type --clearmodifiers --delay 1 -- "$info"
xdotool key Return
