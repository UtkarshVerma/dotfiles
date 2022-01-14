#!/bin/sh

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
feh --no-fehbg --bg-scale --randomize -r ~/Pictures/Wallpapers &
picom --experimental-backends &
unclutter &
parcellite -n &
safeeyes -e &
dwmblocks &
dunst &
asus-fan-daemon &
nm-applet &

exec dwm
