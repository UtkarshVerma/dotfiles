#!/bin/zsh
#--------------------------------------------------------------------------------------
# Initialize stuff
#--------------------------------------------------------------------------------------
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# History file
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
[ -d "$(dirname $HISTFILE)" ] || mkdir -p "$(dirname $HISTFILE)"

ZLE_RPROMPT_INDENT=0
export GPG_TTY=$TTY

## Enable p10k instant prompt
if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
fi

## Append commands to history after execution
setopt INC_APPEND_HISTORY

setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS

## Initialize completions
autoload -U compinit 
fpath=($XDG_DATA_HOME/zsh/completions $fpath)
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

#--------------------------------------------------------------------------------------
# Key bindings
#--------------------------------------------------------------------------------------
# Use emacs key bindings
bindkey -e

bindkey '^[[5~' up-line-or-history			# PageUp: Up a line of history 
bindkey '^[[6~' down-line-or-history			# PageDown: Down a line of history

# Start typing + Up-Arrow: fuzzy find history forward
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search

# Start typing + Down-Arrow: fuzzy find history backward
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

bindkey '^[[H' beginning-of-line			# Home: Go to beginning of line
bindkey '^[[4~' end-of-line				# End: Go to end of line
bindkey '^[[Z' reverse-menu-complete			# Shift-Tab: move through the completion menu backwards
bindkey '^?' backward-delete-char			# Backspace: delete backward
bindkey '^[[3~' delete-char				# Delete: delete forward
bindkey '^[[M' kill-word				# Ctrl-Delete: delete whole forward-word
bindkey '^[[1;5C' forward-word				# Ctrl-RightArrow: move forward one word 
bindkey '^[[1;5D' backward-word				# Ctrl-LeftArrow: move backward one word

bindkey '\ew' kill-region				# Esc-w: Kill from the cursor to the mark
bindkey '^r' history-incremental-search-backward	# Ctrl-r: Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.
bindkey ' ' magic-space					# Space: don't do history expansion

# Ctrl-e: Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-e' edit-command-line

#--------------------------------------------------------------------------------------
# Install plugins if not present
#--------------------------------------------------------------------------------------
ZSH_PLUGINS="$XDG_DATA_HOME/zsh/plugins"
ZSH_THEMES="$XDG_DATA_HOME/zsh/themes"

if [[ ! -d "$ZSH_THEMES/powerlevel10k" ]]; then
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
	"$ZSH_THEMES/powerlevel10k"
fi

if [[ ! -d "$ZSH_PLUGINS/zsh-syntax-highlighting" ]]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting \
	"$ZSH_PLUGINS/zsh-syntax-highlighting"
fi

if [[ ! -d "$ZSH_PLUGINS/zsh-autosuggestions" ]]; then
	git clone https://github.com/zsh-users/zsh-autosuggestions \
	"$ZSH_PLUGINS/zsh-autosuggestions"
fi

#--------------------------------------------------------------------------------------
# Source initialization scripts
#--------------------------------------------------------------------------------------
## Source powerlevel10k
source "$ZSH_THEMES/powerlevel10k/powerlevel10k.zsh-theme"
source "$ZDOTDIR/.p10k.zsh"

## Source zsh-syntax-highlighting
source "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

## Source zsh-autosuggestions
source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"

## Source common shell configurations
[[ -f "$XDG_CONFIG_HOME/shellrc" ]] && source "$XDG_CONFIG_HOME/shellrc"
