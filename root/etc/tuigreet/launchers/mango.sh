#!/bin/sh

export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=mango

exec zsh --login -c mango
