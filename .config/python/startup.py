#!/usr/bin/env python3
# This entire thing is unnecessary post v3.13.0a3
# https://github.com/python/cpython/issues/73965


def is_vanilla() -> bool:
    """:return: whether running "vanilla" Python <3.13"""
    import sys

    return (
        not hasattr(__builtins__, "__IPYTHON__")
        and "bpython" not in sys.argv[0]
        and sys.version_info < (3, 13)
    )


def setup_history():
    """read and write history from state file"""
    import os
    import atexit
    import readline
    from pathlib import Path

    # Check PYTHON_HISTORY for future-compatibility with Python 3.13
    history = None
    if env_path := os.environ.get("PYTHON_HISTORY"):
        history = Path(env_path)
    else:
        # https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html#variables
        state_home = None
        if state_home_env := os.environ.get("XDG_STATE_HOME"):
            state_home = Path(state_home_env)
        else:
            state_home = Path.home() / ".local" / "state"

        history = state_home / "python" / "history"

    # https://github.com/python/cpython/issues/105694
    if not history.is_file():
        readline.write_history_file(
            str(history)
        )  # breaks on macos + python3  without this.

    readline.read_history_file(history)
    atexit.register(readline.write_history_file, history)


if is_vanilla():
    setup_history()
