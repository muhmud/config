#/bin/bash

CURRENT_TIMER=$(cat ~/.timer/current)

CURRENT_TIMER_NAME=$(basename $CURRENT_TIMER)
CURRENT_TIMER_DATE=$(timer -D "$CURRENT_TIMER" --status | jq '.timer.datetime' | sed 's/"//g; s/\([^ ]\) \(.*\)/\1 (\2)/g');

echo "$CURRENT_TIMER_DATE" > ~/.timer/base/$CURRENT_TIMER_NAME;

