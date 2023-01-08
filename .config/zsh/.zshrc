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

#-------------------------------------------------------------------------------
# Key bindings
#-------------------------------------------------------------------------------
# Use emacs key bindings
bindkey -e

bindkey '\e[5~' up-line-or-history          # PageUp: Up a line of history
bindkey '\e[6~' down-line-or-history        # PageDown: Down a line of history

# Start typing + Up-Arrow: fuzzy find history forward
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey '\e[A' up-line-or-beginning-search

# Start typing + Down-Arrow: fuzzy find history backward
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

bindkey '\e[H' beginning-of-line        # Home: Go to beginning of line
bindkey '\e[4~' end-of-line				# End: Go to end of line
bindkey '\e[Z' reverse-menu-complete	# Shift-Tab: move through the completion menu backwards
bindkey '\b' backward-delete-char		# Backspace: delete backward
bindkey '\e[3~' delete-char				# Delete: delete forward
bindkey '\e[M' kill-word				# Ctrl-Delete: delete whole forward-word
bindkey '\e[127;5u' backward-kill-word  # Ctrl-Backspace: delete whole word backward
bindkey '\e[1;5C' forward-word			# Ctrl-RightArrow: move forward one word
bindkey '\e[1;5D' backward-word			# Ctrl-LeftArrow: move backward one word

bindkey '\ew' kill-region				            # Esc-w: Kill from the cursor to the mark
bindkey '\C-r' history-incremental-search-backward	# Ctrl-r: Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.
bindkey ' ' magic-space					            # Space: don't do history expansion

# Ctrl-e: Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-e' edit-command-line

# Ctrl-o: Open a directory using lf
case "$FILE_MANAGER" in
    lf*)
        (( $+functions[lfcd] )) &>/dev/null &&
            bindkey -s '\C-o' 'lfcd\r'
        ;;
    nnn*)
        (( $+functions[nnncd] )) &>/dev/null &&
            bindkey -s '\C-o' 'nnncd\r'
        ;;
esac
