#!/bin/sh

export XDG_SESSION_TYPE=wayland
# KDE sets XDG_CURRENT_DESKTOP itself.

exec zsh --login -c startplasma-wayland
