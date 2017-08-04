#!/bin/bash

sudo yaourt -Sy > /dev/null 2>&1
updates=$(sudo yaourt -Qu | wc -l)
if [ "$updates" -ne "0" ]; then
    echo "Y"
else
    echo ""
fi
