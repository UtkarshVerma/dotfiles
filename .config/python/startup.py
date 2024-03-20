# Store interactive Python shell history according to the XDG specification.
# Set the `PYTHONSTARTUP` environment variable to this file.
#
# This entire thing is unnecessary post v3.13.0a3
#   https://github.com/python/cpython/issues/73965


def is_vanilla_python() -> bool:
    import sys

    return not hasattr(__builtins__, "__IPYTHON__") and "bpython" not in sys.argv[0]


def setup_history():
    import atexit
    import os
    import readline
    from pathlib import Path

    # https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html#variables
    state_home = Path(os.environ.get("XDG_STATE_HOME") or "~/.local/state")
    if not state_home.is_dir():
        print("Error: XDG_STATE_HOME does not exist at", state_home)

    history_file = state_home / "python" / "history"

    try:
        readline.read_history_file(history_file)
    except FileNotFoundError:
        Path(history_file.parent).mkdir(parents=False, exist_ok=True)
        open(history_file, "wb").close()

    atexit.register(readline.write_history_file, history_file)


if is_vanilla_python():
    setup_history()
