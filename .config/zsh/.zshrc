#!/bin/zsh
#-------------------------------------------------------------------------------
# Initialize stuff
#-------------------------------------------------------------------------------
## Instant prompt
if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
fi

## History file
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000000
SAVEHIST=10000000
[ -d "$(dirname $HISTFILE)" ] || mkdir -p "$(dirname $HISTFILE)"

export GPG_TTY="$TTY"

## Initialize completions
autoload -U compinit
fpath=("$XDG_DATA_HOME/zsh/completions" $fpath)
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
_comp_options+=(globdots)       # Include hidden files

## Retain scrollback history on Ctrl+l
if [[ "$TERM" =~ "^foot" ]]; then
    clear-screen-keep-sb() {
        printf "%$((LINES-1))s" | tr ' ' '\n'
        zle .clear-screen
    }
    zle -N clear-screen clear-screen-keep-sb
fi

setopt hist_ignore_all_dups
setopt posixbuiltins

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------
plugins=(
    "https://github.com/romkatv/powerlevel10k"
    "https://github.com/zsh-users/zsh-autosuggestions"
    "https://github.com/zsh-users/zsh-syntax-highlighting"
)

for plugin in $plugins; do
    basename="${plugin##*/}"
    dir="$XDG_DATA_HOME/zsh/plugins/$basename"
    if [[ ! -d "$dir" ]]; then
        git clone --depth=1 "$plugin" "$dir"
    fi

    source "$dir/$basename".(zsh|zsh-theme)
done
unset plugins plugin basename dir

#-------------------------------------------------------------------------------
# Source configurations
#-------------------------------------------------------------------------------
configs=(
    "$XDG_CONFIG_HOME/shellrc"  # common shell config
    "$ZDOTDIR/.p10k.zsh"        # p10k config
)

for config in $configs; do
    if [[ -f "$config" ]]; then
        source "$config"
    fi
done
unset configs config

# Add direnv hook for loading project-specific configurations, if present
if command -v direnv >/dev/null 2>&1; then
    export DIRENV_LOG_FORMAT=""             # Silence direnv
    eval "$(direnv hook zsh)"
fi


#-------------------------------------------------------------------------------
# Vi mode
#-------------------------------------------------------------------------------
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select

zle-line-init() {
    # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    zle -K viins
    echo -ne "\e[5 q"
}
zle -N zle-line-init

echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

#-------------------------------------------------------------------------------
# Key bindings
#-------------------------------------------------------------------------------
bindkey -v  # Use vim bindings

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

bindkey ' ' magic-space                 # Space: don't do history expansion

# Ignore Shift key when combined with backspace/space
bindkey -s '\e[127;2u' '^?'             # Shift-Backspace
bindkey -s '\e[32;2u' ' '               # Shift-Space

# Ctrl-e: Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-e' edit-command-line

# Ctrl-f: cd fzf-selected directory
bindkey -s '\C-f' '^ucd "$(dirname "$(fzf)")"\n'

# Ctrl-o: Open a directory using $FILE_MANAGER
local file_manager_cmd=""
case "$FILE_MANAGER" in
    yazi) file_manager_cmd="ya" ;;
    lf) file_manager_cmd="lf" ;;
esac

if [[ -n "$file_manager_cmd" ]] &&
    (( $+functions[$file_manager_cmd] )) &>/dev/null; then
    bindkey -s '\C-o' '^u'"$file_manager_cmd"'\r'
fi
unset file_manager_cmd
