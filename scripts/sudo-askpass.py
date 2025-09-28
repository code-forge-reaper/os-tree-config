#!/usr/bin/env python3
# ~/bin/sudo-askpass.py
# Robust askpass for sudo -A; logs only length+sha256 to /tmp/askpass-debug.log for debugging.
import sys, os, hashlib

PROMPT = sys.argv[1] if len(sys.argv) > 1 else "Password:"

def log_debug(pw):
    try:
        h = hashlib.sha256(pw.encode('utf-8')).hexdigest()
        with open('/tmp/askpass-debug.log', 'a') as f:
            f.write(f"{os.getlogin() if hasattr(os, 'getlogin') else 'user'} pid={os.getpid()} prompt={PROMPT!r} len={len(pw)} sha256={h}\n")
    except Exception:
        pass

def write_and_exit(pw):
    # write password to stdout, newline, flush, log hash, exit 0
    sys.stdout.write(pw + "\n")
    sys.stdout.flush()
    log_debug(pw)
    sys.exit(0)

# Try GUI if DISPLAY exists
if os.environ.get('DISPLAY'):
    try:
        import tkinter as tk
        root = tk.Tk()
        root.title("Password")
        root.geometry("360x100")
        root.resizable(False, False)
        # optional: show the prompt
        label = tk.Label(root, text= PROMPT, anchor='w')
        label.pack(fill='x', padx=8, pady=(8,0))
        entry = tk.Entry(root, show="*", width=40)
        entry.pack(padx=8, pady=(4,6))
        entry.focus_set()
        def submit(event=None):
            pw = entry.get().strip()
            write_and_exit(pw)
        entry.bind("<Return>", submit)
        btn = tk.Button(root, text="OK", command=submit)
        btn.pack(pady=(0,8))
        # try to bring window forward
        try:
            root.lift(); root.attributes("-topmost", True)
        except Exception:
            pass
        root.mainloop()
    except Exception:
        # fallback to console below
        pass

# Fallback: read from /dev/tty (console) using getpass
try:
    import getpass
    # read from /dev/tty if possible
    try:
        with open('/dev/tty'):
            pw = getpass.getpass(PROMPT + " ")
            write_and_exit(pw)
    except Exception:
        pw = getpass.getpass(PROMPT + " ")
        write_and_exit(pw)
except Exception:
    # last resort: exit non-zero
    sys.exit(1)
