# Store interactive Python shell history in ~/.cache/python/history
# instead of ~/.python_history.
#
# Create the following .config/pythonstartup.py file
# and export its path using PYTHONSTARTUP environment variable:
#
# export PYTHONSTARTUP="${XDG_CONFIG_HOME:-$HOME/.config}/pythonstartup.py"

# Don't do anything for ipython
import sys
if hasattr(__builtins__, '__IPYTHON__'):
    sys.exit()

import atexit
import os
import readline

histdir = os.path.join(os.getenv("XDG_CACHE_HOME", os.path.expanduser("~/.cache")), "python")
if not os.path.isdir(histdir):
    os.mkdir(histdir)

histfile = os.path.join(histdir, "history")

try:
    readline.read_history_file(histfile)
    h_len = readline.get_current_history_length()
except FileNotFoundError:
    open(histfile, 'wb').close()
    h_len = 0

def save(prev_h_len, histfile):
    new_h_len = readline.get_current_history_length()
    readline.set_history_length(1000)
    readline.append_history_file(new_h_len - prev_h_len, histfile)
atexit.register(save, h_len, histfile)
