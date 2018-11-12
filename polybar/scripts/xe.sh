#!/bin/bash

FILE=/tmp/currency-all

while true
do
    if [[ -f "$FILE" ]]; then
        SIZE=$(cat $FILE | jq --raw-output ".list | length" 2>/dev/null)
        MINUTE=$((10#`date +"%M"`))
        INDEX=$(( MINUTE % SIZE ))
        DATA=$(cat $FILE | jq --raw-output ".list[$INDEX]" 2>/dev/null)

        if [[ ! -z "$DATA" ]]; then
            FROM=$(echo $DATA | jq --raw-output ".from" 2>/dev/null)
            TO=$(echo $DATA | jq --raw-output ".to" 2>/dev/null)
            VALUE=$(echo $DATA | jq --raw-output ".value" 2>/dev/null)
            OUTPUT="${FROM}1 = ${TO}${VALUE}"
            FINAL_OUTPUT=`printf "%s" "$OUTPUT"`

            zscroll -l 128 -b " %{F#0f0}%{F-} " -d 0.3 -t 60 -p "                    " "$FINAL_OUTPUT" &
            wait
        fi
    else
        sleep 5;
    fi
done
