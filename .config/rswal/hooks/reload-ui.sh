#!/bin/sh

[ -n "$NO_RELOAD" ] && exit

hex_to_xparsecolor() {
    hex="$1"

    red="$(echo "$hex" | cut -c 2-3)"
    green="$(echo "$hex" | cut -c 4-5)"
    blue="$(echo "$hex" | cut -c 6-7)"

    printf "rgb:%s/%s/%s" "$red" "$green" "$blue"
}

osc_send_command() {
    # POSIX shells do not support hex.
    printf "\033]%s;%s\033\\" "$1" "$2"
}

update_terminal_colors() {
    . ~/.cache/rswal/colors.sh

    colors=""
    for i in $(seq 0 15); do
        colors="$colors${colors:+;}$i;$(hex_to_xparsecolor "$(get_color "$i")")"
    done
    osc_send_command 4 "$colors"
    unset colors

    osc_send_command 10 "$(hex_to_xparsecolor "$(get_color foreground)")"
    osc_send_command 11 "$(hex_to_xparsecolor "$(get_color background)")"
    osc_send_command 12 "$(hex_to_xparsecolor "$(get_color cursor)")"
}

printf "Reloading UI"

case "$XDG_SESSION_TYPE" in
    x11)
        xdotool key Super_L+Shift_L+F5
        pkill dunst
        [ "$TERMINAL" = "st" ] && killall -USR1 st

        exit
        ;;
    wayland)
        find /dev/pts/ -group tty |
            while read -r pts; do
                update_terminal_colors >"$pts"
            done
        ;;
esac
