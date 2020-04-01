#!/bin/bash

EXISTING_PROCESS=$(pgrep -f -o 'suppress-screensaver')

if [[ ! -z "$EXISTING_PROCESS" ]]; then
    echo ""
else
    echo ""
fi;
