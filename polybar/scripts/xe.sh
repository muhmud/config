#!/bin/bash

RAW_RATE=`/home/muhmud/bin/xe USD MYR 2>/dev/null`

if [[ ! -z "$RAW_RATE" ]]; then
    RATE=${RAW_RATE:8:7}

    echo " \$1 = RM $RATE"
fi
