#!/bin/bash

CONNECTIVITY=`fping 8.8.8.8 2>&1 1>/dev/null && echo $?`
VPN=`ifconfig | grep "inet 172[.]16[.]133"`
if [[ ! -z "$VPN" ]]; then
    echo ""
elif [[ "$CONNECTIVITY" == "0" ]]; then
    echo ""
else
    echo ""
fi

