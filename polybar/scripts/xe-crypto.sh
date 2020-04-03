#!/bin/bash

BTC_RATE=`curl -s -X GET https://api.coindesk.com/v1/bpi/currentprice.json | jq '.bpi.GBP.rate_float'`
XRP_RATE=`curl https://api.coingecko.com/api/v3/coins/ripple\?localtionization\=false\&tickers\=false\&community_data\=false\&developer_data\=false | jq '.market_data.current_price.gbp'`

DATA=`cat /tmp/currency-all`

BTC_RATE_FINAL=`printf "%.7s" $BTC_RATE`
XRP_RATE_FINAL=`printf "%.7s" $XRP_RATE`

NEW_DATA=`echo $DATA | jq --raw-output ".list[3].value = $BTC_RATE_FINAL"`
NEW_DATA=`echo $NEW_DATA | jq --raw-output ".list[4].value = $XRP_RATE_FINAL"`

echo $NEW_DATA > /tmp/currency-all
