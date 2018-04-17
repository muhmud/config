#!/bin/bash

TIMER=~/.timer/current

if [[ -f $TIMER ]]; then
  TIMER_DIRECTORY=$(cat $TIMER)
  TIMER_STATUS=$(~/bin/timer --status -D "$TIMER_DIRECTORY")
  STATUS=$(echo $TIMER_STATUS | jq --raw-output '.timer.current.status')
  
  if [[ "$STATUS" != "STOPPED" ]]; then
    if [[ "$STATUS" == "RUNNING" ]]; then
      ~/bin/timer --pause -D "$TIMER_DIRECTORY"
    else
      ~/bin/timer --resume -D "$TIMER_DIRECTORY"
    fi
  else
    TASK_DESCRIPTION=$(eval "zenity --entry --width=500 --title 'Start Timer' --text 'Enter Task Description:' --ok-label='Start' $(~/bin/timer -D "$TIMER_DIRECTORY" --report task --start-date $(date +'%Y-%m-%d' -d '3 months ago') --end-date $(date +'%Y-%m-%d' -d 'next month') | awk -F "\t" '{ gsub(/[ \t]+$/, "", $1); print $1 }' | sort -u | (tasks="";while read t; do tasks="$tasks '$t'"; done;echo $tasks))")
    if [[ ! -z $TASK_DESCRIPTION ]]; then
      ~/bin/timer --go -T "$TASK_DESCRIPTION" -D "$TIMER_DIRECTORY"
    fi
  fi
fi
