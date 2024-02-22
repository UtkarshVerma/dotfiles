#!/bin/sh
# Change working dir in shell to last dir in yazi on exit.

ya() {
    tmp="$(mktemp -t "yazi-cwd.XXXXX")"
    yazi "$@" --cwd-file="$tmp"

    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd "$cwd" || exit
    fi

    rm -f "$tmp"
}
