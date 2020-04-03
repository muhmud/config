
#!/bin/bash

USD_MYR=`/home/muhmud/bin/xe USD MYR 2>/dev/null`
GBP_MYR=`/home/muhmud/bin/xe GBP MYR 2>/dev/null`
MYR_PKR=`/home/muhmud/bin/xe MYR PKR 2>/dev/null`
XBT_GBP=`curl -s -X GET https://api.coindesk.com/v1/bpi/currentprice.json | jq '.bpi.GBP.rate_float'`
XRP_GBP=`curl https://api.coingecko.com/api/v3/coins/ripple\?localtionization\=false\&tickers\=false\&community_data\=false\&developer_data\=false | jq '.market_data.current_price.gbp'`

echo "{ \"list\": [ { \"from\": \"USD\", \"to\": \"MYR\", \"value\": \"${USD_MYR:8:7}\", \"min\": \"4.05\", \"max\": \"4.15\" }, { \"from\": \"GBP\", \"to\": \"MYR\", \"value\": \"${GBP_MYR:8:7}\", \"min\": \"5.05\", \"max\": \"5.5\" }, { \"from\": \"MYR\", \"to\": \"PKR\", \"value\": \"${MYR_PKR:8:7}\", \"min\": \"35.0\", \"max\": \"40.0\" }, { \"from\": \"XBT\", \"to\": \"GBP\", \"value\": \"${XBT_GBP:0:7}\", \"min\": \"8034\", \"max\": \"9000\", \"amount\": 4.01955038, \"for\": 19850 }, { \"from\": \"XRP\", \"to\": \"GBP\", \"value\": \"${XRP_GBP:0:7}\", \"min\": \"0.14\", \"max\": \"0.2\", \"amount\": 133055.075003, \"for\": 20000 } ] }" > /tmp/currency-all
