#!/bin/bash

ALREADY=$(ps aux | grep '[0-9] /home/muhmud/bin/xbanish$' | grep -v "grep")

if [[ -z "$ALREADY" ]]; then
  ~/bin/xbanish &
fi

