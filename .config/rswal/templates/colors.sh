#!/bin/sh

get_color() {
    case "$1" in
        0) color="{{colors.normal.black}}" ;;
        1) color="{{colors.normal.red}}" ;;
        2) color="{{colors.normal.green}}" ;;
        3) color="{{colors.normal.yellow}}" ;;
        4) color="{{colors.normal.blue}}" ;;
        5) color="{{colors.normal.magenta}}" ;;
        6) color="{{colors.normal.cyan}}" ;;
        7) color="{{colors.normal.white}}" ;;
        8) color="{{colors.bright.black}}" ;;
        9) color="{{colors.bright.red}}" ;;
        10) color="{{colors.bright.green}}" ;;
        11) color="{{colors.bright.yellow}}" ;;
        12) color="{{colors.bright.blue}}" ;;
        13) color="{{colors.bright.magenta}}" ;;
        14) color="{{colors.bright.cyan}}" ;;
        15) color="{{colors.bright.white}}" ;;

        background) color="{{colors.special.background}}" ;;
        foreground) color="{{colors.special.foreground}}" ;;
        cursor) color="{{colors.special.cursor}}" ;;
    esac

    echo "$color"
}
