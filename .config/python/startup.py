# Store interactive Python shell history in ~/.cache/python/history
# instead of ~/.python_history.
#
# Create the following .config/pythonstartup.py file
# and export its path using PYTHONSTARTUP environment variable:
#
# export PYTHONSTARTUP="${XDG_CONFIG_HOME:-$HOME/.config}/pythonstartup.py"

import atexit
import os
import readline

histfile = os.path.join(os.getenv("XDG_CACHE_HOME", os.path.expanduser("~/.cache")), "python", "history")
try:
    readline.read_history_file(histfile)
    # default history len is -1 (infinite), which may grow unruly
    readline.set_history_length(1000)
except FileNotFoundError:
    pass

atexit.register(readline.write_history_file, histfile)
