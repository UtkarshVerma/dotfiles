#!/bin/sh
# Have dbus and systemd, if present, inherit all environment variables, except a few.

if ! command -v dbus-update-activation-environment >/dev/null 2>&1; then
    exit
fi

unset XDG_SEAT
unset XDG_SESSION_ID
unset XDG_VTNR
dbus-update-activation-environment --systemd --all
