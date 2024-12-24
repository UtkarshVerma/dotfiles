# `lf` wrapper that allows changing CWD on exit whenever the command below is
# executed in `lf`.
#
#   # Quit and update the parent shell's current working directory to match lf's.
#   cmd quit-and-cd &{{
#       pwd > $LF_CD_FILE
#       lf -remote "send $id quit"
#   }}

TMPDIR=${TMPDIR:-/tmp}

lf() {
    export LF_CD_FILE="$TMPDIR/lfcd-$$"
    command lf "$@"

    if [ -s "$LF_CD_FILE" ]; then
        dir="$(realpath "$(cat "$LF_CD_FILE")")"
        if [ "$PWD" != "$dir" ]; then
            cd "$dir" || exit
        fi

        rm "$LF_CD_FILE"
    fi

    unset LF_CD_FILE
}
