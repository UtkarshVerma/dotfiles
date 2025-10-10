#!/bin/bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ $DISPLAY ]] && shopt -s checkwinsize

PS1='[\u@\h \W]\$ '

case ${TERM} in
    xterm* | rxvt* | Eterm | aterm | kterm | gnome*)
        PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
        ;;
    screen*)
        PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
        ;;
esac

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Do not clutter user home directory
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}"/bash/history

# User config
BASHRC="${XDG_CONFIG_HOME:-$HOME/.config}"/bash/bashrc
if [ -f "$BASHRC" ]; then
    . "$BASHRC"
fi
unset BASHRC
