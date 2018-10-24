#!/bin/bash

TIMER=~/.timer/current

if [[ -f $TIMER ]]; then
  TIMER_DIRECTORY=$(cat $TIMER)
  TIMER_STATUS=$(~/bin/timer --status -D "$TIMER_DIRECTORY")
  STATUS=$(echo $TIMER_STATUS | jq --raw-output '.timer.current.status')

  if [[ "$STATUS" == "RUNNING" ]] || [[ "$STATUS" == "PAUSED" ]]; then
    ~/bin/timer --stop -D "$TIMER_DIRECTORY"
  else
    if [[ -f ~/.timer/timers ]]; then
      NEW_TIMER_DIRECTORY=$(eval "zenity --list --column='Timer' --column='Directory' $(names=""; while read t; do names="$names '`basename $t`' '$t'"; done < ~/.timer/timers;echo $names) --width=500 --height=400 --print-column=2 --text='Choose Timer:' --title='Timer'")
      if [[ ! -z $NEW_TIMER_DIRECTORY ]]; then
        NEW_TIMER_STATUS=$(~/bin/timer --status -D "$NEW_TIMER_DIRECTORY")
        NEW_STATUS=$(echo $NEW_TIMER_STATUS | jq --raw-output '.timer.current.status')
        if [[ "$NEW_STATUS" == "PAUSED" ]]; then
          echo "$NEW_TIMER_DIRECTORY" > $TIMER
        else  
          TASK_DESCRIPTION=$(eval "zenity --entry --width=500 --title 'Start Timer ($(basename $NEW_TIMER_DIRECTORY))' --text 'Enter Task Description:' --ok-label='Start' $(~/bin/timer -D "$NEW_TIMER_DIRECTORY" --report task --start-date $(date +'%Y-%m-%d' -d '3 months ago') --end-date $(date +'%Y-%m-%d' -d 'next month') | awk -F "\t" '{ gsub(/[ \t]+$/, "", $1); print $1 }' | sort -u | (tasks="";while read t; do tasks="$tasks '$t'"; done;echo $tasks))")
          if [[ ! -z $TASK_DESCRIPTION ]]; then
            ~/bin/timer --go -T "$TASK_DESCRIPTION" -D "$NEW_TIMER_DIRECTORY"
            echo "$NEW_TIMER_DIRECTORY" > $TIMER
          fi
        fi
      fi
    fi
  fi
fi
