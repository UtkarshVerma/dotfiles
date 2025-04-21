#!/bin/sh

export XDG_SESSION_TYPE="wayland"
export XDG_CURRENT_DESKTOP="hyprland"

exec zsh --login -c Hyprland
