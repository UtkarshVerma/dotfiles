#!/bin/sh

[ -n "$NO_RELOAD" ] && exit

printf "Reloading UI"

xdotool key Super_L+Shift_L+F5
pkill dunst
[ "$TERMINAL" = "st" ] && killall -USR1 st
