#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

timing="$($DIR/timer-status)"

if [ "$timing" != "" ]; then
    echo " ${timing% - *} - %{F#f00}${timing##* - }%{F-}"
else
    echo ""
fi

