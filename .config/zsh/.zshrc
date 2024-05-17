#!/bin/zsh

# Early loading ---------------------------------------------------------------
function _set_cursor() {
    case "$1" in
        block) code=1 ;;
        beam) code=5 ;;
    esac
    printf "\033[%d q" "$code"
}

_set_cursor beam            # Set cursor on startup.
export GPG_TTY="$TTY"

# Initialize powerlevel10k instant prompt.
if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Plugins ---------------------------------------------------------------------
ZINIT_HOME="$XDG_DATA_HOME/zsh/zinit"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$ZINIT_HOME"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab

zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# Configurations --------------------------------------------------------------
# Load external configurations.
typeset -A assoc configs=(
    # Path                     Launch as POSIX shell
    "$XDG_CONFIG_HOME/shellrc" true
    "$ZDOTDIR/.p10k.zsh"       false
)
for config as_posix in ${(@kv)configs}; do
    if [[ -f "$config" ]]; then
        if [[ $as_posix ]]; then
            . "$config"
        else
            source "$config"
        fi
    fi
done
unset configs config

# Completions
autoload -U compinit
fpath=("$XDG_DATA_HOME/zsh/completions" $fpath)
zmodload zsh/complist
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
_comp_options+=(globdots)       # Include hidden files.
zinit cdreplay -q               # Run compdefs cached by zinit.

# Completion styling
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true

# History
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

history_dir="${HISTFILE%/*}"
[ -d "$history_dir" ] || mkdir -p "$history_dir"
unset history_dir

# Retain scrollback history on Ctrl+l
if [[ "$TERM" =~ "^foot" ]]; then
    clear-screen-keep-sb() {
        printf "%$((LINES-1))s" | tr ' ' '\n'
        zle .clear-screen
    }
    zle -N clear-screen clear-screen-keep-sb
fi

# ZSH options.
setopt hist_ignore_all_dups
setopt posixbuiltins

# Vi mode ---------------------------------------------------------------------
bindkey -v  # Use vim bindings.
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case "$KEYMAP" in
        vicmd) _set_cursor block ;;
        viins|main) _set_cursor beam ;;
    esac
}
zle -N zle-keymap-select

# Keybinds --------------------------------------------------------------------
# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Start typing + Up-Arrow: fuzzy find history forward
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey '\e[A' up-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search

# Start typing + Down-Arrow: fuzzy find history backward
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '\e[B' down-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

bindkey '\C-w' backward-kill-word       # Ctrl-w: delete whole word backword
bindkey '\e[Z' reverse-menu-complete    # Shift-Tab: move through the completion menu backwards
bindkey '\b' backward-delete-char       # Backspace: delete backward
bindkey '\e[3~' delete-char             # Delete: delete forward
bindkey '\e[M' kill-word                # Ctrl-Delete: delete whole forward-word
bindkey '\e[127;5u' backward-kill-word  # Ctrl-Backspace: delete whole word backward
bindkey '\e[1;5C' forward-word          # Ctrl-RightArrow: move forward one word
bindkey '\e[1;5D' backward-word         # Ctrl-LeftArrow: move backward one word

# Ctrl-e: Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-e' edit-command-line

# Ctrl-f: cd fzf-selected directory
if command -v fzf >/dev/null 2>&1; then
    bindkey -s '\C-f' '^ucd "$(dirname "$(fzf)")"\n'
fi

# Ctrl-o: Open a directory using $FILE_MANAGER
if [[ -n "$FILE_MANAGER" ]] &&
    (( $+functions[$FILE_MANAGER] )) &>/dev/null; then
    bindkey -s '\C-o' '^u'"$FILE_MANAGER"'\r'
fi
