#!/bin/sh

printf "Setting wallpaper"

[ ! -f "$WALLPAPER" ] &&
    WALLPAPER="$(find ~/pictures/wallpapers/ -type f ! -path '*/.git/*' | shuf -n 1)"

feh --no-fehbg --bg-scale "$WALLPAPER"
