#!/usr/bin/env python
import tkinter as tk
import sys
from PIL import Image, ImageTk

tt = tk.Tk()
tt.geometry("300x300")
tt.resizable(False,False)

if len(sys.argv) < 2:
	v = tk.Label(tt, {"text":"please pass a filename"})
else:
	img = Image.open(sys.argv[1])
	img.resize((300,300))
	v = tk.Label(tt, image=ImageTk.PhotoImage(img))

v.pack()
tt.mainloop()

