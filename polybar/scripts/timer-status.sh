#!/bin/bash

TIMER=~/.timer/current
TIMER_BASE=~/.timer/base/$(basename $(cat $TIMER))
TIMER_WORK=~/.timer/status

get_details() {  
  TIMER_STATUS=$(~/bin/timer --status -D "$TIMER_DIRECTORY")
  PROJECT=$(echo $TIMER_STATUS | jq --raw-output '.project' 2>/dev/null)
  STATUS=$(echo $TIMER_STATUS | jq --raw-output '.timer.current.status' 2>/dev/null)
  WORK_DONE=$(echo $TIMER_STATUS | jq --raw-output '.timer.workDone' 2>/dev/null)

  if [[ "$STATUS" == "PAUSED" ]]; then
    if [[ -f "$TIMER_BASE" ]]; then
      if [[ ! -f "$TIMER_WORK" ]]; then
        CURRENT_TIMER_DATE=$(tail -n 1 "$TIMER_BASE");
        TOTAL_WORK=$(~/bin/timer -D "$TIMER_DIRECTORY" \
          --report date \
          --start-date $(date +'%Y-%m-%d' -d '6 month ago') \
          --end-date $(date +'%Y-%m-%d' -d 'next month') \
          | sort \
          | awk -v "CURRENT_TIMER_DATE=$CURRENT_TIMER_DATE" -F '  ' '$1 >= CURRENT_TIMER_DATE' \
          | sed 's/.*(\(.*\))$/\1/g' \
          | awk '{ sum += $1 } END { printf "%0.2f", sum }')

        TOTAL_WORK_DONE=" %{F#fff}(%{F#0ff}$TOTAL_WORK%{F#fff})"
        echo "$TOTAL_WORK_DONE" > $TIMER_WORK;
      else
        TOTAL_WORK_DONE=$(cat $TIMER_WORK);
      fi;
    fi;
  fi;
}

if [[ -f $TIMER ]]; then
  TIMER_DIRECTORY=$(cat $TIMER)
  get_details
  if [[ "$PROJECT" == "" ]]; then
    sleep 1
    get_details
  fi

  if [[ "$STATUS" == "RUNNING" ]]; then
    if [[ -f "$TIMER_STATUS" ]]; then
      rm -f $TIMER_STATUS;
    fi;

    echo " $PROJECT - %{F#f00}${WORK_DONE}%{F-}"
  elif [[ "$STATUS" == "PAUSED" ]]; then
      echo "$PROJECT - %{F#0f0}${WORK_DONE}${TOTAL_WORK_DONE}%{F-}"
  else
      echo "";
  fi
else
    echo "";
fi

