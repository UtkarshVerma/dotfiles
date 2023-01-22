#!/bin/sh

alias | awk -F '[ =]' '{print $1}'
