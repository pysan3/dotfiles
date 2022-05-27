import os
from pathlib import Path
import atexit
import readline

history_path = Path(os.environ.get('XDG_CACHE_HOME', '~/.cache/')) / 'python' / 'python_history'
history_path.parent.mkdir(parents=True, exist_ok=True)
try:
    readline.read_history_file(history_path)
except OSError:
    pass


def write_history():
    try:
        readline.write_history_file(history_path)
    except OSError:
        pass


atexit.register(write_history)
