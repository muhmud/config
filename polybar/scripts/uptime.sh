#!/bin/bash

UPTIME=`uptime`
TIME=`echo $UPTIME | awk -F 'up ' '{ print $2 }' | awk -F ' user,' '{ print $1 }' | sed 's/ day[s]*, /d /g' | sed 's/,.*//g'`

echo -e " $TIME"
