#!/bin/bash

~/bin/timer-report-tasks.sh $* | sed -E "s/  \+ /$(printf '\t')/g" | sed -E 's/\([0-9]+[.][0-9]+\)//g' | xclip -selection clipboard
