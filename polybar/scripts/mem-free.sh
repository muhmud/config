#!/bin/bash

MEM_FREE=`grep "MemFree:" /proc/meminfo | awk '{ print $2 }'`
MEM_AVAILABLE=`grep "MemAvailable:" /proc/meminfo | awk '{ print $2 }'`
MEM_TOTAL=`grep "MemTotal:" /proc/meminfo | awk '{ print $2 }'`

MEM_USED_PERCENT=`bc <<< "scale = 2; r = 100 - (($MEM_AVAILABLE)/ $MEM_TOTAL * 100); scale = 0; r / 1"`

if [[ $MEM_USED_PERCENT -ge 50 && $MEM_USED_PERCENT -le 79 ]]; then
    COLOR="%{F#fa0}";
elif [[ $MEM_USED_PERCENT -ge 80 ]]; then
    COLOR="%{F#f00}";
fi

echo -e " $COLOR$MEM_USED_PERCENT%%{F-}"
