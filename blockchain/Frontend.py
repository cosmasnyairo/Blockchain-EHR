import json
import os
import socket
import subprocess
import tkinter as tk
from tkinter.constants import *
from tkinter import ttk, messagebox
from ttkthemes import ThemedTk


class App:
    def __init__(self, root):
        self.root = root
        self.path = 'data/peers.json'
        self.proceses = []
        self.assigned_peers, self.unassigned_peers = self.get_peers()

        self.get_ip()

        self.root.iconbitmap('background.ico')

        self.root.wm_title('EHR | Administrator Panel')

        # self.root.geometry("400x600")
        # setting window size
        self.get_window_size()
        self.root.resizable(False, False)

        tabControl = ttk.Notebook(self.root)
        self.tab1, self.tab2 = ttk.Frame(tabControl), ttk.Frame(tabControl)
        tabControl.add(self.tab1, text='Assigned Nodes', compound=TOP)
        tabControl.add(self.tab2, text='Unassigned Nodes', compound=TOP)
        tabControl.pack(expand=1, fill="both")

        self.tab_frame1 = self.get_notebook_frame(self.tab1)
        self.tab_frame2 = self.get_notebook_frame(self.tab2)
        self.get_widgets(self.tab_frame1, self.tab_frame2)

        ttk.Button(tabControl, text='Refresh',
                   command=lambda: self.refresh_details()).pack(padx=20, pady=20, side=BOTTOM)

    def get_widgets(self, tabframe1, tabframe2):
        ttk.Label(tabframe1, text="Manage {} available peer nodes" .format(len(self.assigned_peers)) if self.assigned_peers else "No assigned nodes to manage").pack(
            side=tk.TOP, padx=40, pady=20)

        ttk.Label(tabframe2, text="There are {} pending peer nodes" .format(len(self.unassigned_peers)) if self.unassigned_peers else "No unassigned nodes to assign").pack(
            side=tk.TOP, padx=20, pady=20)

        for index, peer in enumerate(self.assigned_peers):
            self.assigned_frame = ttk.Frame(tabframe1)
            self.assigned_frame.pack(fill="both", expand=1)
            ttk.Label(self.assigned_frame, text="{}. Peer Node {}".format(index+1, peer['assigned_port'],)).grid(
                padx=40, pady=10, column=1, row=0)
            ttk.Button(self.assigned_frame, text="Start Node", command=lambda peer=peer: self.start_node(peer['assigned_port'])).grid(
                padx=70, pady=10, column=2, row=0)
            ttk.Separator(self.assigned_frame, orient='horizontal').grid(
                padx=60, pady=10, row=1, columnspan=3, sticky="ew")

        for index, peer in enumerate(self.unassigned_peers):
            self.unassigned_frame = ttk.Frame(tabframe2)
            self.unassigned_frame.pack(fill="both", expand=1)
            ttk.Label(self.unassigned_frame, text="{}. Peer Node {}".format(index+1, peer['assigned_port'],)).grid(
                padx=40, pady=10, column=1, row=0)
            ttk.Button(self.unassigned_frame, text="Assign Node", command=lambda peer=peer: self.assign_port(peer)).grid(
                padx=70, pady=10, column=2, row=0)
            ttk.Separator(self.unassigned_frame, orient='horizontal').grid(
                padx=60, pady=10, row=1, columnspan=3, sticky="ew")

    def assign_port(self, peer_details):
        with open(self.path) as json_file:
            data = json.load(json_file)
            assigned, unassigned = data['assigned'], data['unassigned']
            assigned.append(peer_details)
            unassigned.remove(peer_details)
        with open(self.path, mode='w') as f:
            json.dump(data, f, indent=4)

        for widget in self.tab2.winfo_children():

            widget.destroy()
        self.unassigned_frame.destroy()
        self.refresh_details()

    def refresh_details(self):
        self.get_ip()
        self.assigned_peers, self.unassigned_peers = self.get_peers()
        for widget in self.tab1.winfo_children():
            widget.destroy()
        for widget in self.tab2.winfo_children():
            widget.destroy()

        self.tab_frame1 = self.get_notebook_frame(self.tab1)
        self.tab_frame2 = self.get_notebook_frame(self.tab2)
        self.get_widgets(self.tab_frame1, self.tab_frame2)
        self.root.after(600000, self.refresh_details)

    def get_window_size(self):
        width, height = 400, 600
        difwidth = self.root.winfo_screenwidth()-width
        difheight = self.root.winfo_screenheight()-height
        alignstr = '%dx%d+%d+%d'.format() % (width, height,
                                             difwidth/2, difheight/2)
        root.geometry(alignstr)

    def get_ip(self):
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        self.ip_address = s.getsockname()[0]
        s.close()

    def get_peers(self):
        if os.path.exists(self.path):
            with open(self.path) as json_file:
                loaded = json.load(json_file)
                return loaded['assigned'], loaded['unassigned']

    def start_node(self, peer):
        self.pid = subprocess.Popen(
            "python node.py -p {} --host {}".format(peer, self.ip_address), shell=True).pid
        self.proceses.append(self.pid)

    def on_closing(self):
        if messagebox.askokcancel("Quit", "Do you want to quit?"):
            for pid in self.proceses:
                subprocess.Popen("TASKKILL /F /PID {} /T".format(pid))
            root.destroy()

    def get_notebook_frame(self, frame):
        s = ttk.Style()
        bg = s.lookup('TFrame', 'background')
        canvas = tk.Canvas(frame, height=500, background=bg)
        scrollbar = ttk.Scrollbar(
            frame, orient=VERTICAL, command=canvas.yview)
        canvas.bind('<Configure>', lambda e: canvas.configure(
            scrollregion=canvas.bbox(ALL), highlightthickness=0))
        canvas.focus_set()
        canvas.focus("")
        tab_frame = ttk.Frame(canvas, height=200)
        canvas.create_window((0, 0), window=tab_frame, anchor=NW)
        canvas.pack(side=LEFT, fill="both", expand=1)
        scrollbar.pack(side=RIGHT, fill=Y, anchor=NE)
        return tab_frame


# adapta
# yaru
if __name__ == "__main__":
    root = ThemedTk(theme="adapta")
    style = ttk.Style()
    style.configure('.', focuscolor='', highlightbackground='',
                    font=('Segoe UI', 10))
    app = App(root)
    app.start_node(2)
    root.protocol("WM_DELETE_WINDOW", app.on_closing)
    root.mainloop()
