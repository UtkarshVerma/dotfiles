#!/bin/sh
# Display disk usage for both `/` and `/home`.

case $BLOCK_BUTTON in
    6) terminal -e "$EDITOR" "$0" ;;
esac

. sb-theme

disk_usage() {
    used_bytes="$(df --output=avail "$1" | tail -n 1)"
    used_gibs="$(echo "scale=1; $used_bytes / 1024 / 1024" | bc)"

    percent_used="$(df --output=pcent "$1" | tail -n 1 | grep -o '[[:digit:]]\+')"
    [ "$percent_used" -le 10 ] && color=10

    display "${used_gibs}G" "$color"
}

echo "$(display "󰋊") $(disk_usage "/")$(display "|")$(disk_usage "/home")"
