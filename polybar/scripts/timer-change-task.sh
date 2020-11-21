#!/bin/bash

TIMER=~/.timer/current
TIMER_SWITCH_LAST_CHECK=/tmp/.timer-switch

if [[ -f $TIMER ]]; then
  if [[ -f $TIMER_SWITCH_LAST_CHECK ]]; then
    if [[ $(($(date +%s) - $(cat $TIMER_SWITCH_LAST_CHECK))) -le 1 ]]; then
      exit 1
    fi
  fi
  
  TIMER_DIRECTORY=$(cat $TIMER)
  TIMER_STATUS=$(~/bin/timer --status -D "$TIMER_DIRECTORY")
  STATUS=$(echo $TIMER_STATUS | jq --raw-output '.timer.current.status')

  if [[ "$STATUS" == "PAUSED" ]]; then
    echo $TIMER_DIRECTORY
    TASK_DESCRIPTION=$(eval "zenity --entry --width=500 --title 'Start Timer' --text 'Enter Task Description:' --ok-label='Start' $(~/bin/timer -D "$TIMER_DIRECTORY" --report task --start-date $(date +'%Y-%m-%d' -d '3 month ago') --end-date $(date +'%Y-%m-%d' -d 'next month') | awk -F "\t" '{ gsub(/[ \t]+$/, "", $1); print $1 }' | sort -u | (tasks="";while read t; do tasks="$tasks '$t'"; done;echo $tasks))")
    if [[ ! -z $TASK_DESCRIPTION ]]; then
      ~/bin/timer --resume -T "$TASK_DESCRIPTION" -D "$TIMER_DIRECTORY"
    fi
  fi

  echo $(date +%s) > $TIMER_SWITCH_LAST_CHECK
fi
