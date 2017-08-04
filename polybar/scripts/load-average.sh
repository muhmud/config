#!/bin/bash

load_average=`uptime | awk -F 'load average:' '{ print $2 }' | awk -F ', ' '{ print $1 }'`
echo "$load_average"

