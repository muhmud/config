#!/bin/bash

TIMER=~/.timer/current
PREVIOUS=~/.timer/previous

if [[ -f $TIMER ]] && [[ -f $PREVIOUS ]]; then
  TIMER_DIRECTORY=$(cat $TIMER)
  TIMER_STATUS=$(~/bin/timer --status -D "$TIMER_DIRECTORY")
  STATUS=$(echo $TIMER_STATUS | jq --raw-output '.timer.current.status')

  PREVIOUS_TIMER_DIRECTORY=$(cat $PREVIOUS)
  PREVIOUS_TIMER_STATUS=$(~/bin/timer --status -D "$PREVIOUS_TIMER_DIRECTORY")
  PREVIOUS_STATUS=$(echo $PREVIOUS_TIMER_STATUS | jq --raw-output '.timer.current.status')

  if [[ "$STATUS" == "RUNNING" ]] && [[ "$PREVIOUS_STATUS" == "PAUSED" ]]; then
    # Pause the current timer
    ~/bin/timer --pause -D "$TIMER_DIRECTORY"

    # Resume the previous timer
    ~/bin/timer --resume -D "$PREVIOUS_TIMER_DIRECTORY"

    # Switch the timers
    echo "$TIMER_DIRECTORY" > $PREVIOUS
    echo "$PREVIOUS_TIMER_DIRECTORY" > $TIMER
  fi
fi
