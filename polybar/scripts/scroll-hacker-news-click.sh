#!/bin/bash

FILE=/tmp/hacker-news-current
URL=$(cat $FILE | jq --raw-output '.url' 2>/dev/null)

if [[ ! -z "$URL" ]]; then
    /usr/bin/firefox "$URL"
fi

