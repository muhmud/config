#!/bin/bash

UPTIME=`uptime`
TIME=`echo $UPTIME | awk -F ' ' '{ print $3 }' | sed 's/.$//'`

echo -e " $TIME"
