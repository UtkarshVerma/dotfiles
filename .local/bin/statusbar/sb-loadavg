#!/bin/sh
# Display the average CPU load.

case "$BLOCK_BUTTON" in
    6) terminal -e "$EDITOR" "$0" ;;
esac

THRESHOLD=5

load=$(cut -d' ' -f1 /proc/loadavg)

is_threshold_exceeded="$(echo "$load > $THRESHOLD" | bc)"
[ "$is_threshold_exceeded" -eq 1 ] && color=9

. sb-theme
display " $load" "$color"
