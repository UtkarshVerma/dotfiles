#!/bin/zsh
#--------------------------------------------------------------------------------------
# Initialize stuff
#--------------------------------------------------------------------------------------
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
HISTFILE="$XDG_DATA_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
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

## Load widgets
autoload -U compinit history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

## Initialize completions
fpath=($XDG_DATA_HOME/zsh/completions $fpath)
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

## Key bindings
bindkey -e
bindkey '^[[P' delete-char
bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[A' history-beginning-search-backward-end
bindkey '^[[B' history-beginning-search-forward-end

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

## Source aliases
[[ -f "$XDG_CONFIG_HOME/aliasrc" ]] && source "$XDG_CONFIG_HOME/aliasrc"

## Source zsh-syntax-highlighting
source "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

## Source zsh-autosuggestions
source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"
