#!/bin/sh
# Display RAM usage.

case "$BLOCK_BUTTON" in
    6) terminal -e "$EDITOR" "$0" ;;
esac

free_mib="$(free --mebi | grep '^Mem:' | tr -s ' ' | cut -d' ' -f3)"
free_gib="$(echo "scale=2; $free_mib / 1024" | bc)"

. sb-theme
display " $(printf "%.2f" "$free_gib")G"
