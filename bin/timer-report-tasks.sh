#!/bin/bash

INSTANCE=$1

if [[ -z "$INSTANCE" ]]; then
    INSTANCE=1
fi

ORIGINAL_TIMER_DATE_LINE=$(timer --report date --start-date $(date +'%Y-%m-%d' -d '3 month ago') --end-date $(date +'%Y-%m-%d' -d 'next month') | tail -n $INSTANCE | head -n 1)
TIMER_DATETIME=$(echo $ORIGINAL_TIMER_DATE_LINE | cut -f1 -d '+' | sed -r 's/ [\(]/T/g' | awk '{$1=$1};1')
END_DATETIME=$(date +"%Y-%m-%dT%H:%M:%S")

if [[ $INSTANCE -ne 1 ]]; then
    let NEXT_INSTANCE=$INSTANCE-1
    END_DATETIME=$(timer --report date --start-date $(date +'%Y-%m-%d' -d '3 month ago') --end-date $(date +'%Y-%m-%d' -d 'next month') | tail -n $NEXT_INSTANCE | head -n 1 | cut -f1 -d '+' | sed -r 's/ [\(]/T/g' | awk '{$1=$1};1')
fi

echo "Timer DateTime: $(echo $ORIGINAL_TIMER_DATE_LINE | cut -f1 -d ')'))"
echo ""
timer --report task -S "$TIMER_DATETIME" -E "$END_DATETIME" -D "$PWD"
