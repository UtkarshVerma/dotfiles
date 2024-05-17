#!/bin/sh

hyprpaper_ipc() {
    hyprctl hyprpaper "$@" >/dev/null
}

set_hyprland_wallpaper() {
    preloaded=0
    for wallpaper in $(hyprctl hyprpaper listloaded); do
        if [ "$wallpaper" = "$WALLPAPER" ]; then
            preloaded=1
            continue
        fi

        hyprpaper_ipc unload "$wallpaper" >/dev/null
    done

    [ $preloaded -eq 0 ] && hyprpaper_ipc preload "$WALLPAPER"
    hyprpaper_ipc wallpaper ",$WALLPAPER"
}

printf "Setting wallpaper"

[ ! -f "$WALLPAPER" ] &&
    WALLPAPER="$(find ~/pictures/wallpapers/ -type f ! -path '*/.git/*' | shuf -n 1)"

case "$XDG_SESSION_TYPE" in
    x11)
        feh --no-fehbg --bg-scale "$WALLPAPER"
        exit
        ;;
    wayland)
        case "$XDG_CURRENT_DESKTOP" in
            Hyprland) set_hyprland_wallpaper ;;
        esac
        ;;
esac
