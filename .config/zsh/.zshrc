#!/bin/zsh

# Early loading ---------------------------------------------------------------
function __set_cursor() {
    local code
    case "$1" in
        block) code=1 ;;
        beam) code=5 ;;
    esac
    printf "\033[%d q" "$code"
}

function __emit_osc7_sequence() {
    local temp="$PWD"
    local encoded=""
    while [ -n "$temp" ]; do
        local n="${temp#?}"
        local c="${temp%"$n"}"
        case "$c" in
            [-/:_.!\'\(\)~[:alnum:]]) encoded="$encoded$c" ;;
            *) encoded="${encoded}$(printf '%%%02X' "$c")" ;;
        esac
        temp="$n"
    done

    printf "\033]7;file://%s%s\033\\" "$(hostname)" "$encoded"
}

__set_cursor beam                           # Set cursor on startup.
__emit_osc7_sequence                        # Emit OSC7 on launch.
chpwd_functions+=(__emit_osc7_sequence)     # Emit OSC7 on CWD change.

export GPG_TTY="$TTY"

# Initialise powerlevel10k instant prompt.
P10K="$XDG_CACHE_HOME/p10k-instant-prompt-${(%):-%n}.zsh"
[ -r "$P10K" ] && source "$P10K"
unset P10K

# Plugins ---------------------------------------------------------------------
ZINIT_HOME="$XDG_DATA_HOME/zsh/zinit"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$ZINIT_HOME"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

zinit ice depth=1

zinit light romkatv/powerlevel10k
zinit light chisui/zsh-nix-shell
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab
zinit light nix-community/nix-zsh-completions

zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::terraform
zinit snippet OMZP::azure

# Configurations --------------------------------------------------------------
# Completions
autoload -Uz compinit bashcompinit
fpath=("$XDG_DATA_HOME/zsh/completions" $fpath)

ZSH_CACHE="$XDG_CACHE_HOME/zsh"
[ -d "$ZSH_CACHE" ] || mkdir -p "$ZSH_CACHE"
zstyle ':completion:*' cache-path "$ZSH_CACHE/zcompcache"
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
bashcompinit
_comp_options+=(globdots)       # Include hidden files.
zinit cdreplay -q               # Run compdefs cached by zinit.

# Completion styling
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*' cache-path "$ZSH_CACHE/zcompcache"
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true

# History
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

history_dir="${HISTFILE%/*}"
[ -d "$history_dir" ] || mkdir -p "$history_dir"
unset history_dir

# Retain scrollback history on Ctrl+l.
if [[ "$TERM" =~ "^foot" ]]; then
    function __clear_screen_keep_scrollback() {
        printf "%$((LINES-1))s" | tr ' ' '\n'
        zle .clear-screen
    }
    zle -N clear-screen __clear_screen_keep_scrollback
fi

zmodload zsh/complist
unset ZSH_CACHE

# Vi mode ---------------------------------------------------------------------
bindkey -v  # Use vim bindings.
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case "$KEYMAP" in
        vicmd) __set_cursor block ;;
        viins|main) __set_cursor beam ;;
    esac
}
zle -N zle-keymap-select

# Set beam cursor initlialising a new line.
function zle-line-init() {
    __set_cursor beam
}
zle -N zle-line-init

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

# Ctrl-e: Edit the current command line in $EDITOR.
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-e' edit-command-line

# Aliases ---------------------------------------------------------------------
alias \
    cat="bat" \
    cbcopy="xclip -selection clipboard" \
    cbpaste="xclip -selection clipboard -out" \
    diff="diff --color=auto" \
    dosbox="dosbox -conf \$XDG_CONFIG_HOME/dosbox/dosbox.conf" \
    egrep="egrep --color=auto" \
    fgrep="fgrep --color=auto" \
    grep="grep --color=auto" \
    ll="ls -l" \
    ls="ls --color=auto" \
    ncdu="ncdu --color dark" \
    open="xdg-open" \
    tree="tree -a -I .git" \
    vale='vale --config="$XDG_CONFIG_HOME/vale/config.ini"' \
    vi="nvim" \
    yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'

# Functions -------------------------------------------------------------------
function se() {
    local bin_dir="$HOME/.local/bin"
    cat <<EOF | sed "s|$bin_dir/||g" | fzf | sed "s|^|$bin_dir/|g" | xargs -r "$EDITOR"
$(find "$bin_dir/" -type l -xtype f)
$(find "$bin_dir/statusbar/" -type f)
EOF
}

function snipaste() {
    if local url="$(curl --silent --form file=@- "https://0x0.st")"; then
        printf "%s" "$url" | xclip -selection clipboard &&
            echo "URL \"$url\" copied to clipboard."
    fi
}

# Integrations ----------------------------------------------------------
configs=(
    "$ZDOTDIR/.p10k.zsh"
    "$ZDOTDIR/machine.zsh" # Machine-specific config.
    "$XDG_CONFIG_HOME/lf/lf.sh"
    "$XDG_CONFIG_HOME/yazi/yazi.sh"
    "/usr/bin/virtualenvwrapper_lazy.sh"
)

for config in ${configs}; do
    if [ -f "$config" ]; then
        source "$config"
    fi
done
unset config configs

function command_exists() {
    command -v "$1" >/dev/null 2>&1
}

if command_exists direnv; then
    export DIRENV_LOG_FORMAT="" # Silence direnv
    eval "$(direnv hook zsh)" 
fi

if command_exists pio; then
    eval "$(_PIO_COMPLETE=zsh_source pio)"
fi

if command_exists fzf; then
    # Ctrl-f: cd fzf-selected directory.
    bindkey -s '\C-f' '^ucd "$(dirname "$(fzf)")"\n'

    eval "$(fzf --zsh)"
fi

if command_exists zoxide; then
    eval "$(zoxide init zsh --cmd cd)"
fi

if command_exists atuin; then
    eval "$(atuin init zsh --disable-up-arrow)"
fi

# Ctrl-o: Open a directory using $FILE_MANAGER.
if [ -n "$FILE_MANAGER" ] && command_exists "$FILE_MANAGER"; then
    bindkey -s '\C-o' '^u'"$FILE_MANAGER"'\r'
fi

unset -f command_exists
