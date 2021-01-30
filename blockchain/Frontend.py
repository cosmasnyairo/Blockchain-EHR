from datetime import datetime
import json
import os
import socket
import subprocess
import tkinter as tk
from tkinter.constants import *
from tkinter import messagebox
from tkinter import ttk
from ttkthemes import ThemedTk


class App:
    def __init__(self, root):
        self.root = root
        self.path = 'data/peers.json'
        self.proceses = []
        self.assigned_peers, self.unassigned_peers = self.get_peers()
        self.get_ip()

        self.root.wm_title('EHR | Blockchain Peers Panel')
        self.root.resizable(False, False)

        # setting window size
        self.width, self.height = 450, 400
        self.get_window_size()

        style = ttk.Style()
        style.configure('TButton', focuscolor='')

        tabControl = ttk.Notebook(self.root)
        self.tab1, self.tab2 = ttk.Frame(tabControl), ttk.Frame(tabControl)
        tabControl.add(self.tab1, text='Assigned Peers', compound=TOP)
        tabControl.add(self.tab2, text='Unassigned Peers', compound=TOP)

        self.get_assigned_widgets(self.tab1)
        self.get_unassigned_widgets(self.tab2)

        tabControl.pack(expand=1, fill="both")
        ttk.Button(self.root, text='Refresh',
                   command=lambda: self.refresh_details()).pack(padx=10, pady=10)

    def get_assigned_widgets(self, tab1):
        if self.assigned_peers:
            ttk.Label(tab1, text="Manage {} available peer nodes".format(len(self.assigned_peers))).pack(
                side=tk.TOP, padx=10, pady=10)
            for index, peer in enumerate(self.assigned_peers):
                self.assigned_frame = ttk.Frame(tab1)
                self.assigned_frame.pack()
                ttk.Label(self.assigned_frame, text="[{}]. Peer Node {}".format(index+1, peer['assigned_port'],)).grid(
                    padx=10, pady=10, column=0, row=0)
                ttk.Button(self.assigned_frame, text="Start Node", command=lambda peer=peer: self.start_node(peer['assigned_port'])).grid(
                    padx=10, pady=10, column=2, row=0)
        else:
            ttk.Label(tab1, text="No assigned peers to manage").pack(
                side=tk.TOP, padx=10, pady=10)

    def get_unassigned_widgets(self, tab2):

        if self.unassigned_peers:
            self.unassigned_frame = ttk.Frame(tab2)
            self.unassigned_frame.pack()
            ttk.Label(self.unassigned_frame, text="There are {} pending peer nodes".format(len(self.unassigned_peers))).grid(
                padx=10, pady=10, column=0, row=0)
            ttk.Button(self.unassigned_frame, text="Assign peer nodes", command=lambda: self.assign_port(self.unassigned_peers)).grid(
                padx=10, pady=10, column=1, row=0)
            for index, peer in enumerate(self.unassigned_peers):
                ttk.Label(tab2, text="[{}]. Peer node {}. Requested on : {}.".format(index+1,
                                                                                     peer['assigned_port'], datetime.fromtimestamp(peer['date_requested']).strftime("%c"))).pack(padx=10, pady=10)
                ttk.Separator(tab2, orient=HORIZONTAL).pack(padx=10, pady=10)

        else:
            ttk.Label(tab2,  text="No unassigned peers to assign").pack(
                side=tk.TOP, padx=10, pady=10)

    def assign_port(self, peer_details):
        with open(self.path) as json_file:
            data = json.load(json_file)
            assigned, unassigned = data['assigned'], data['unassigned']
            for item in peer_details:
                assigned.append(item)
                unassigned.remove(item)
        with open(self.path, mode='w') as f:
            json.dump(data, f, indent=4)

        for widget in self.tab2.winfo_children():
            widget.destroy()
        self.unassigned_frame.destroy()
        ttk.Label(self.tab2,  text="All peers assigned").pack(
            side=tk.TOP, padx=10, pady=10)

    def refresh_details(self):
        self.get_ip()
        self.assigned_peers, self.unassigned_peers = self.get_peers()
        for widget in self.tab1.winfo_children():
            widget.destroy()
        for widget in self.tab2.winfo_children():
            widget.destroy()
        self.get_assigned_widgets(self.tab1)
        self.get_unassigned_widgets(self.tab2)
        self.root.after(600000, self.refresh_details)

    def get_window_size(self):
        difwidth = self.root.winfo_screenwidth()-self.width
        difheight = self.root.winfo_screenheight()-self.height
        alignstr = '%dx%d+%d+%d'.format() % (self.width, self.height,
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
        # print('output is ', subprocess.check_output([command]))

    def on_closing(self):
        if tk.messagebox.askokcancel("Quit", "Do you want to quit?"):
            for pid in self.proceses:
                subprocess.Popen("TASKKILL /F /PID {} /T".format(pid))
            root.destroy()
# adapta
# breeze
# arc
# yaru

if __name__ == "__main__":
    root = ThemedTk(theme="adapta")
    app = App(root)
    root.protocol("WM_DELETE_WINDOW", app.on_closing)
    root.mainloop()
