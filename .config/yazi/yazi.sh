# Borrowed from: https://yazi-rs.github.io/docs/quick-start/#shell-wrapper
yazi() {
    cwd_file="$(mktemp -t "yazi-cwd.XXXXXX")"
    command yazi "$@" --cwd-file="$cwd_file"

    if [ -s "$cwd_file" ]; then
        if cwd="$(command cat -- "$cwd_file")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd" || exit
        fi

        rm -f -- "$cwd_file"
    fi

    unset cwd_file cwd
}
