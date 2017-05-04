#!/usr/bin/python3

import os
import time
import socket
import selectors
import threading
from argparse import ArgumentParser
import i3ipc
from cycler import Cycler

SOCKET_FILE = '/tmp/i3_cycle_workspaces'
MAX_WS_HISTORY = 512

class FocusWatcher:
    def __init__(self):
        self.i3 = i3ipc.Connection()
        self.i3.on('workspace::focus', self.on_workspace_focus)
        self.i3.on('workspace::init', self.on_workspace_focus)
        self.i3.on('key_release', self.on_key_release)
        self.listening_socket = socket.socket(socket.AF_UNIX,
            socket.SOCK_STREAM)
        if os.path.exists(SOCKET_FILE):
            os.remove(SOCKET_FILE)
        self.listening_socket.bind(SOCKET_FILE)
        self.listening_socket.listen(1)
        self.cycler = Cycler(MAX_WS_HISTORY)

    def _focus_workspace(self, workspace_id):
        # Set focus to the workspace
        self.i3.command('workspace %s' % workspace_id)
        
    def on_workspace_focus(self, i3conn, event):
        workspace_id = event.current.props.name
        self.cycler.add(workspace_id)
 
    def on_key_release(self, i3conn, event):
        time.sleep(0.05)
        if event.change == '133' or event.change == '134':
            self.cycler.release()
        
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
                # Get a list of all live workspaces
                tree = self.i3.get_tree()
                workspaces = set(w.name for w in tree.workspaces())

                # Find the next window to cycle to
                workspace_id = self.cycler.switch(workspaces, forward)

                # If we found a valid workspace to switch to, set focus to it
                if workspace_id:
                    self._focus_workspace(workspace_id)
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
    parser = ArgumentParser(prog='cycle_workspaces.py',
        description='''
        Cycle through workspaces in focus order.

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
