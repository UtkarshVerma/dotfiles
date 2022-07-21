#!/bin/sh

## Set PATH
export PATH="$HOME/.local/bin:$HOME/.local/bin/statusbar:$PATH"

## Default programs
export EDITOR="nvim"
export BROWSER="brave"
export READER="zathura"
export TERMINAL="st"
export STATUSBAR="dwmblocks"
export FILE_MANAGER="lf"

## ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DATA_DIRS="$XDG_DATA_HOME:/usr/local/share:/usr/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"

export NODE_REPL_HISTORY="$XDG_STATE_HOME/node/history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npmrc"
# skipping for nvm
# export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"
export PNPM_HOME="$XDG_DATA_HOME/pnpm"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"

export ANDROID_HOME="$XDG_DATA_HOME/android"
export ANDROID_SDK_ROOT="$XDG_DATA_HOME/android-sdk"
export ANDROID_EMULATOR_HOME="$XDG_DATA_HOME/android"
export IPYTHONDIR="$XDG_CONFIG_HOME/jupyter"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export CHROME_EXECUTABLE="$BROWSER"
export NVM_DIR="$XDG_CONFIG_HOME/nvm"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
export GOPATH="$XDG_DATA_HOME/go"
export HUGO_CACHES_MODULES_DIR="$XDG_DATA_HOME/hugo"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export MATLAB_PREFDIR="$XDG_DATA_HOME/matlab/R2020b"
export MLM_LICENSE_FILE="$XDG_DATA_HOME/matlab/license.lic"
export MATLAB_LOG_DIR="$XDG_CACHE_HOME/matlab"
export PLATFORMIO_CORE_DIR="$XDG_DATA_HOME/platformio"
export PLATFORMIO_CACHE_DIR="$XDG_CACHE_HOME/platformio"
export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"

export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"

export TEXMFHOME="$XDG_DATA_HOME/texmf"
export TEXMFVAR="$XDG_CACHE_HOME/texmf"
export TEXMFCONFIG="$XDG_CONFIG_HOME/texmf"

export ARDUINO_DIRECTORIES_DATA="$XDG_DATA_HOME/Arduino"
export ARDUINO_DIRECTORIES_DOWNLOADS="$ARDUINO_DIRECTORIES_DATA/staging"
export ARDUINO_DIRECTORIES_USER="$HOME/Documents/Arduino"

export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"

export PATH="$PATH:$PNPM_HOME:$NPM_CONFIG_PREFIX/bin:/usr/local/go/bin:$GOPATH/bin:$CARGO_HOME/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/tools/bin"

# Add RubyGems to PATH, if installed
if which ruby >/dev/null && which gem >/dev/null; then
    export PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

## Look and feel
export QT_QPA_PLATFORMTHEME=qt5ct
export XCURSOR_THEME=default
export XCURSOR_SIZE=32

## Misc
export NVIM_LISTEN_ADDRESS=/tmp/nvim
export AWT_TOOLKIT="MToolkit"
export GOOGLE_APPLICATION_CREDENTIALS="$XDG_DATA_HOME/gcloud/credentials.json"

## Colorize `less`
export LESS="-R"
export LESSOPEN="| highlight -O ansi %s 2>/dev/null"
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_md=$(tput bold; tput setaf 6)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 4; tput rev)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)

# fcitx
export GTK_IM_MODULE="fcitx5"
export QT_IM_MODULE="fcitx5"
export XMODIFIERS="@im=fcitx5"

# Fix for Java AWT based software (e.g. MATLAB)
export _JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_OPTIONS="$_JAVA_OPTIONS -Dawt.useSystemAAFontSettings=on"

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export TERMINAL="foot"

    export XDG_CURRENT_DESKTOP="sway"
    export STATUSBAR="i3blocks"

    export GDK_BACKEND="wayland"
    export CLUTTER_BACKEND="wayland"
    export QT_QPA_PLATFORM="wayland"
    export SDL_VIDEODRIVER="wayland"
    export ECORE_EVAS_ENGINE="wayland"
    export ELM_ENGINE="wayland"

    export QT_WAYLAND_FORCE_DPI="physical"
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
fi

# Start gnome-keyring-daemon
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(gnome-keyring-daemon --start 2>/dev/null)"
    export SSH_AUTH_SOCK
fi

# Use dbus session bus created by systemd
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
