#!/bin/sh

# Default programs
export EDITOR="nvim"
export BROWSER="brave"
export READER="zathura"
export TERMINAL="st"
export FILE_MANAGER="lf"
export SYSTEM_MONITOR="btop"
export STATUSBAR="dwmblocks"

# XDG paths
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_DIRS="$XDG_DATA_HOME:/usr/local/share:/usr/share"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# ~/ cleanup
export ANDROID_EMULATOR_HOME="$XDG_DATA_HOME/android"
export ANDROID_HOME="$XDG_DATA_HOME/android"
export ANDROID_SDK_ROOT="$XDG_DATA_HOME/android-sdk"
export ARDUINO_DIRECTORIES_DATA="$XDG_DATA_HOME/Arduino"
export ARDUINO_DIRECTORIES_DOWNLOADS="$ARDUINO_DIRECTORIES_DATA/staging"
export ARDUINO_DIRECTORIES_USER="$HOME/Documents/Arduino"
export BUN_HOME="$XDG_DATA_HOME/bun"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export CHROME_EXECUTABLE="$BROWSER"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GOPATH="$XDG_DATA_HOME/go"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export HUGO_CACHES_MODULES_DIR="$XDG_DATA_HOME/hugo"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export IPYTHONDIR="$XDG_CONFIG_HOME/jupyter"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export MATLAB_LOG_DIR="$XDG_CACHE_HOME/matlab"
export MATLAB_PREFDIR="$XDG_DATA_HOME/matlab/R2020b"
export MLM_LICENSE_FILE="$XDG_DATA_HOME/matlab/license.lic"
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node/history"
export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npmrc"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export PLATFORMIO_CACHE_DIR="$XDG_CACHE_HOME/platformio"
export PLATFORMIO_CORE_DIR="$XDG_DATA_HOME/platformio"
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"
export ROS_HOME="$XDG_CACHE_HOME/ros"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export TEXMFCONFIG="$XDG_CONFIG_HOME/texlive/texmf-config"
export TEXMFHOME="$XDG_DATA_HOME/texmf"
export TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
export VAGRANT_ALIAS_FILE="$XDG_DATA_HOME/vagrant/aliases"
export VAGRANT_HOME="$XDG_DATA_HOME/vagrant"
export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"
export W3M_DIR="$XDG_DATA_HOME/w3m"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export WORKON_HOME="$XDG_DATA_HOME/virtualenvs"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
export _Z_DATA="$XDG_DATA_HOME/z"

# Set PATH
export PATH="$PNPM_HOME:\
$NPM_CONFIG_PREFIX/bin:\
$BUN_HOME/bin:\
$GOPATH/bin:\
$CARGO_HOME/bin:\
$ANDROID_SDK_ROOT/emulator:\
$ANDROID_SDK_ROOT/platform-tools:\
$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:\
$HOME/.local/bin/statusbar:\
$HOME/.local/bin:\
$PATH"

# Add RubyGems to PATH, if installed
if command -v ruby >/dev/null 2>&1 && command -v gem >/dev/null 2>&1; then
    export PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

# Misc
export NVIM_LISTEN_ADDRESS="/tmp/nvim"
export AWT_TOOLKIT="MToolkit"
export GOOGLE_APPLICATION_CREDENTIALS="$XDG_DATA_HOME/gcloud/credentials.json"
export SUDO_ASKPASS="$HOME/.local/bin/dmenupass"
export PIPENV_VENV_IN_PROJECT=1

# Look and feel
export QT_QPA_PLATFORMTHEME="qt5ct"

# Colorize `less`
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

# Bus address used by dbus-broker user service on Arch
export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"

# Authentication socket used by the gnome-keyring-daemon user service on Arch
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
