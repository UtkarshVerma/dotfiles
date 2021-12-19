#!/bin/sh

## Set PATH
export PATH="$HOME/.local/bin:$HOME/.local/bin/statusbar:$PATH"

## Default programs:
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="brave-bin"
export READER="zathura"

## ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npmrc"
export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"
export NPM_CONFIG_CACHE="$NPM_CONFIG_PREFIX"

export LESSHISTFILE="-"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"

export ANDROID_SDK_ROOT="$XDG_DATA_HOME/android-sdk"
export ANDROID_EMULATOR_HOME="$XDG_DATA_HOME/android"
export IPYTHONDIR="$XDG_CONFIG_HOME/jupyter"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export CHROME_EXECUTABLE="$BROWSER"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
export GOPATH="$XDG_DATA_HOME/go"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export MATLAB_PREFDIR="$XDG_DATA_HOME/matlab/R2020b"
export MLM_LICENSE_FILE="$XDG_DATA_HOME/matlab/license.lic"
export MATLAB_LOG_DIR="$XDG_CACHE_HOME/matlab"
export PLATFORMIO_CORE_DIR="$XDG_DATA_HOME/platformio"
export PLATFORMIO_CACHE_DIR="$XDG_CACHE_HOME/platformio"

export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"

export TEXMFHOME="$XDG_DATA_HOME/texmf"
export TEXMFVAR="$XDG_CACHE_HOME/texmf"
export TEXMFCONFIG="$XDG_CONFIG_HOME/texmf"

export ARDUINO_DIRECTORIES_DATA="$XDG_DATA_HOME/Arduino"
export ARDUINO_DIRECTORIES_DOWNLOADS="$ARDUINO_DIRECTORIES_DATA/staging"
export ARDUINO_DIRECTORIES_USER="$HOME/Documents/Arduino"

export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"

export PATH="$PATH:$NPM_CONFIG_PREFIX/bin:/usr/local/go/bin:$GOPATH/bin:$CARGO_HOME/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/tools/bin"

# Add RubyGems to PATH, if installed
command -v gem 2>&1 >/dev/null && export PATH="$PATH:$(gem environment gemdir)/bin"

## Look and feel
export XCURSOR_THEME=Bibata-Modern-Classic
export QT_STYLE_OVERRIDE=kvantum
export LS_COLORS="$(cat $HOME/.config/lscolors)"

## Misc
export BAT_THEME="Monokai Extended"
export NVIM_LISTEN_ADDRESS=/tmp/nvim
export AWT_TOOLKIT="MToolkit"
export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"

## nnn config
export NNN_BMS="h:~;d:~/Downloads;n:~/notes;w:~/Pictures/Wallpapers"
export NNN_PLUG="f:finder;d:dragdrop;o:fzopen;m:nmount;p:preview-tui;i:imgview"
export NNN_ARCHIVE="\\.(7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|rar|rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)$"
export NNN_COLORS="#0a1b2c3d;1234"
export NNN_FCOLORS="c1e2272e006033f7c6d6abc4"
export NNN_FIFO="/tmp/nnn.fifo"

# Disable Ctrl+Shift+u
export GTK_IM_MODULE=xim

# Fix for Java AWT based software (e.g. MATLAB)
export _JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_OPTIONS="$_JAVA_OPTIONS -Dawt.useSystemAAFontSettings=on"

# Start X server if not already running
export DISPLAY=:0.0
[ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg 2>&1 > /dev/null && exec startx $XINITRC 2>&1 > /dev/null
