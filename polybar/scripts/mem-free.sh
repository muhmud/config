#!/bin/bash

MEM_FREE=`grep "MemFree:" /proc/meminfo | awk '{ print $2 }'`
MEM_TOTAL=`grep "MemTotal:" /proc/meminfo | awk '{ print $2 }'`

MEM_FREE_PERCENT=`bc <<< "scale = 2; r = 100 - ($MEM_FREE / $MEM_TOTAL * 100); scale = 0; r / 1"`

echo " $MEM_FREE_PERCENT%"
