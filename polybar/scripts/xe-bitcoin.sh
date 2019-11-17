#!/bin/bash

RATE=`curl -s -X GET https://api.coindesk.com/v1/bpi/currentprice.json | jq '.bpi.GBP.rate_float'`
DATA=`cat /tmp/currency-all`

RATE_FINAL=`printf "%.7s" $RATE`
NEW_DATA=`echo $DATA | jq --raw-output ".list[3].value = $RATE_FINAL"`

echo $NEW_DATA > /tmp/currency-all

