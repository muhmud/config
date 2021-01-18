#!/usr/bin/python

import os
import uuid
import socket
import selectors
import threading
import time
from argparse import ArgumentParser

import i3ipc
from cycler import Cycler

SOCKET_FILE = '/tmp/i3_cycle_windows'
MAX_WIN_HISTORY = 512

class FocusWatcher:
    def __init__(self):
        self.i3 = i3ipc.Connection()
        self.i3.on('key_release', self.on_key)
        #self.i3.on('key_press', self.on_key)

    def on_key(self, i3conn, event):
        if event.change == '37':
            self.write_ctrl_up()

    def write_ctrl_up(self):
        f = open("/tmp/ctrl-up","w+")
        f.write(str(uuid.uuid4()))
        f.close()

    def launch_i3(self):
        self.i3.main()

    def run(self):
        t_i3 = threading.Thread(target=self.launch_i3)
        t_i3.start()

if __name__ == '__main__':
    focus_watcher = FocusWatcher()
    focus_watcher.write_ctrl_up()
    focus_watcher.run()
