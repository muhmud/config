#!/bin/bash

sudo pacman -Sy > /dev/null 2>&1
updates=$(sudo pacman -Qu | wc -l)
if [ "$updates" -ne "0" ]; then
    echo ""
else
    echo ""
fi
