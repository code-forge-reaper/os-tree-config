#!/usr/bin/env python
import os
import sys
# you should have this be piped into eval or similar
p = os.getenv("PATH").split(":")
f = []
for pp in p:
	if not pp in f :
		#print(pp, pp in f)
		f.append(pp)
#print(f)
def run(*t):
	print(*t)

shell = os.getenv("SHELL")
if shell == "/usr/bin/fish":
	run("set", "-x","PATH" , " ".join(f))
elif "bash" in shell or "zsh" in shell:
    run("export", "PATH=" + ":".join(f))
else:
	assert False, f"TODO: support this shell {shell}"