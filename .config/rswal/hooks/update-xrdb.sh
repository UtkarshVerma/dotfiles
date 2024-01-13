#!/bin/sh

printf "Updating xrdb"

xrdb -merge ~/.config/X11/Xresources/main
