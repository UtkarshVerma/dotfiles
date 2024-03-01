#!/bin/sh

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
