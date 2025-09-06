#!/bin/sh

export XDG_SESSION_TYPE="wayland"
# Hyprland sets XDG_CURRENT_DESKTOP itself.

exec zsh --login -c Hyprland
