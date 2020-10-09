#!/bin/bash

WEEKS_BACK=$1
if [[ ! -z "$WEEKS_BACK" ]]; then
  WEEKS_BACK=$((WEEKS_BACK+1))
else
  WEEKS_BACK=2
fi;

TIMER_NAME=$(basename "$PWD");
TIMER_BASE_FILE=~/.timer/base/${TIMER_NAME};
TIMER_HISTORY=$(cat $TIMER_BASE_FILE | wc -l)

if [[ $TIMER_HISTORY -ge $WEEKS_BACK ]]; then
  PREVIOUS_TIMER_BASE=$(tail -n $WEEKS_BACK $TIMER_BASE_FILE | head -n 1 | sed 's/[()]//g; s/ +.*//g');
  CURRENT_TIMER_BASE=$(tail -n $WEEKS_BACK $TIMER_BASE_FILE | head -n 2 | tail -n 1 | sed 's/[()]//g; s/ +.*//g');

  echo "Timer DateTime Range: $PREVIOUS_TIMER_BASE - $CURRENT_TIMER_BASE"
  echo ""
  timer --report task -S "$PREVIOUS_TIMER_BASE" -E "$CURRENT_TIMER_BASE" -D "$PWD"
fi;

