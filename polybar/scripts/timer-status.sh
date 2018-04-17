#!/bin/bash

TIMER=~/.timer/current

get_details() {  
  TIMER_STATUS=$(~/bin/timer --status -D "$TIMER_DIRECTORY")
  PROJECT=$(echo $TIMER_STATUS | jq --raw-output '.project' 2>/dev/null)
  STATUS=$(echo $TIMER_STATUS | jq --raw-output '.timer.current.status' 2>/dev/null)
  WORK_DONE=$(echo $TIMER_STATUS | jq --raw-output '.timer.workDone' 2>/dev/null)
}

if [[ -f $TIMER ]]; then
  TIMER_DIRECTORY=$(cat $TIMER)
  get_details
  if [[ "$PROJECT" == "" ]]; then
    sleep 1
    get_details
  fi

  if [[ "$STATUS" == "RUNNING" ]]; then
      echo " $PROJECT - %{F#f00}$WORK_DONE%{F-}"
  elif [[ "$STATUS" == "PAUSED" ]]; then
      echo "$PROJECT - %{F#0f0}$WORK_DONE%{F-}"
  else
      echo "";
  fi
else
    echo "";
fi
