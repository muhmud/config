#!/bin/bash

updates=$(apt-get -su upgrade | grep '^0' | wc -l)
if [ "$updates" -eq "0" ]; then
    echo ""
else
    echo ""
fi
