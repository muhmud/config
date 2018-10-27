#!/bin/bash

FILE=/tmp/hacker-news-top
CURRENT=/tmp/hacker-news-current

while true
do
    if [[ -f "$FILE" ]]; then
        MINUTE=$((10#`date +"%M"`))
        INDEX=$((MINUTE % 30))
        DATA=$(cat $FILE | jq --raw-output ".top[$INDEX]" 2>/dev/null)

        if [[ ! -z "$DATA" ]]; then
            echo $DATA > $CURRENT
            TITLE=$(echo $DATA | jq --raw-output ".title" 2>/dev/null)
            SCORE=$(echo $DATA | jq --raw-output ".score" 2>/dev/null)

            zscroll -l 128 -b "   %{F#0F0}$SCORE%{F-} " -d 0.3 -t 60 -p "                    " "$TITLE" &
            wait
        fi
    else
        sleep 5;
    fi
done
