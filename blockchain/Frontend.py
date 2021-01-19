import socket
import subprocess
import tkinter as tk
from tkinter.constants import *
from tkinter import messagebox
import tkinter.font as tkFont


class App:
    def __init__(self, root):
        self.proceses = []
        self.get_ip()

        root.wm_title('EHR | Blockchain Peers Panel')
        root.resizable(False, False)

        # setting window size
        width, height = 450, 300
        difwidth, difheight = (
            (root.winfo_screenwidth()-width)/2), ((root.winfo_screenheight()-height)/2)
        alignstr = '%dx%d+%d+%d'.format() % (width, height, difwidth, difheight)
        root.geometry(alignstr)

        peer_btn = tk.Label(root)
        self.format_widget(peer_btn, None,
                           "Click button below to start node", label=True, width=30)
        peer_btn.pack(side=tk.TOP, padx=10, pady=10)

        peers = [5000, 5001, 5002]
        for peer in peers:
            frame = tk.Frame(root)
            frame.pack()

            peer_label = tk.Label(frame)
            self.format_widget(peer_label, "#a0a0a0",
                               "Node {}".format(peer), label=True)
            peer_label.pack(side=tk.LEFT, padx=10, pady=10)

            peer_btn = tk.Button(frame)
            self.format_widget(peer_btn, "#000000",
                               "Start Node", command=lambda peer=peer: self.onclick(peer))

            peer_btn.pack(side=tk.LEFT, padx=10, pady=15)

        bottomframe = tk.Frame(root)
        bottomframe.pack()
        btn_ipadr = tk.Button(bottomframe)
        self.format_widget(btn_ipadr, "#000000",
                           'Refresh', command=lambda: self.get_ip())
        btn_ipadr.pack(side=tk.BOTTOM, padx=5, pady=5)

    def onclick(self, peer):
        pid = subprocess.Popen(
            "python node.py -p {} --host {}".format(peer, self.ip_address), shell=True).pid
        self.proceses.append(pid)
        # print('output is ', subprocess.check_output([command]))

    def format_widget(self, Widget, color, text, command=None, label=False, width=None):
        Widget["bg"] = color
        Widget["font"] = tkFont.Font(family='Monteserrat', size=10)
        Widget["text"] = text
        Widget["fg"] = "#ffffff"
        if label == True:
            Widget["fg"] = "#000000"
            Widget['bd'] = 5
            Widget["width"] = 20 if width == None else width
        else:
            Widget["width"] = 15
            Widget["command"] = command

    def get_ip(self):
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        self.ip_address = s.getsockname()[0]
        s.close()

    def on_closing(self):
        if tk.messagebox.askokcancel("Quit", "Do you want to quit?"):
            for pid in self.proceses:
                subprocess.Popen("TASKKILL /F /PID {} /T".format(pid))
            root.destroy()


if __name__ == "__main__":
    root = tk.Tk()
    app = App(root)
    root.protocol("WM_DELETE_WINDOW", app.on_closing)
    root.mainloop()
