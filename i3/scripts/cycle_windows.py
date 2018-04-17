#!/usr/bin/python3

import os
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
        self.i3.on('window::focus', self.on_window_focus)
        self.i3.on('key_release', self.on_key_release)
        self.i3.on('key_press', self.on_key_press)
        self.listening_socket = socket.socket(socket.AF_UNIX,
            socket.SOCK_STREAM)
        if os.path.exists(SOCKET_FILE):
            os.remove(SOCKET_FILE)
        self.listening_socket.bind(SOCKET_FILE)
        self.listening_socket.listen(1)
        self.cycler = Cycler(MAX_WIN_HISTORY)
        self.last_focussed_window = None
        self.key_pressed = False

    def _focus_window(self, window_id):
        # Set focus to the window 
        self.i3.command('[con_id=%s] focus' % window_id)
        
    def on_window_focus(self, i3conn, event):
        window_id = event.container.props.id
        self.last_focussed_window = window_id
        if (not self.key_pressed):
            self.cycler.add(window_id)

    def on_key_press(self, i3conn, event):
        if event.change == '64' or event.change == '133' or event.change == '134':
            self.last_focussed_window = None
            self.key_pressed = True
    
    def on_key_release(self, i3conn, event):
        time.sleep(0.07)
        if event.change == '64' or event.change == '133' or event.change == '134':
            self.cycler.release()

            if (self.last_focussed_window != None):
                self.cycler.add(self.last_focussed_window)
                self.last_focussed_window = None
            self.key_pressed = False
        
    def launch_i3(self):
        self.i3.main()

    def launch_server(self):
        selector = selectors.DefaultSelector()

        def accept(sock):
            conn, addr = sock.accept()
            selector.register(conn, selectors.EVENT_READ, read)

        def read(conn):
            data = conn.recv(1024)

            # Record if we have received a switch command and which type
            forward = data == b'switch'
            reverse = data == b'rev-switch'
            
            if forward or reverse:
                # Get a list of all live windows
                tree = self.i3.get_tree()
                windows = set(w.id for w in tree.leaves())

                # Find the next window to cycle to
                window_id = self.cycler.switch(windows, forward)

                # If we found a valid window to switch to, set focus to it
                if window_id:
                    self._focus_window(window_id)
            elif not data:
                selector.unregister(conn)
                conn.close()

        selector.register(self.listening_socket, selectors.EVENT_READ, accept)

        while True:
            for key, event in selector.select():
                callback = key.data
                callback(key.fileobj)

    def run(self):
        t_i3 = threading.Thread(target=self.launch_i3)
        t_server = threading.Thread(target=self.launch_server)
        for t in (t_i3, t_server):
            t.start()

if __name__ == '__main__':
    parser = ArgumentParser(prog='cycle_windows.py',
        description='''
        Cycle through windows in focus order.

        Then you can bind this script with the `--switch` and `--rev-switch` options to one of your
        i3 keybinding.
        ''')
    parser.add_argument('--switch', dest='switch', action='store_true',
        help='Switch to the next window', default=False)
    parser.add_argument('--rev-switch', dest='rev_switch', action='store_true',
        help='Switch to the previous window', default=False)
    args = parser.parse_args()

    if not args.switch and not args.rev_switch:
        focus_watcher = FocusWatcher()
        focus_watcher.run()
    else:
        client_socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        client_socket.connect(SOCKET_FILE)

        if args.switch:
            client_socket.send(b'switch')
        else:
            client_socket.send(b'rev-switch')
            
        client_socket.close()
