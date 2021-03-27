
#!/bin/bash

USD_MYR=`/home/muhmud/bin/xe USD MYR 2>/dev/null`
TRY_USD=`/home/muhmud/bin/xe TRY USD 2>/dev/null`
GBP_MYR=`/home/muhmud/bin/xe GBP MYR 2>/dev/null`
MYR_PKR=`/home/muhmud/bin/xe MYR PKR 2>/dev/null`
XAU_GBP=`/home/muhmud/bin/xe XAU GBP 2>/dev/null`
XAG_GBP=`/home/muhmud/bin/xe XAG GBP 2>/dev/null`
XBT_GBP=`curl -s https://api.coindesk.com/v1/bpi/currentprice.json | jq '.bpi.GBP.rate_float'`
XRP_GBP=`curl -s https://api.coingecko.com/api/v3/coins/ripple\?localtionization\=false\&tickers\=false\&community_data\=false\&developer_data\=false | jq '.market_data.current_price.gbp'`



echo "{ \"list\": [ { \"from\": \"TRY\", \"to\": \"USD\", \"value\": \"${TRY_USD:8:7}\", \"min\": \"0.10\", \"max\": \"0.18\" }, { \"from\": \"USD\", \"to\": \"MYR\", \"value\": \"${USD_MYR:8:7}\", \"min\": \"4.05\", \"max\": \"4.15\" }, { \"from\": \"GBP\", \"to\": \"MYR\", \"value\": \"${GBP_MYR:8:7}\", \"min\": \"5.05\", \"max\": \"5.5\" }, { \"from\": \"MYR\", \"to\": \"PKR\", \"value\": \"${MYR_PKR:8:7}\", \"min\": \"35.0\", \"max\": \"40.0\" }, { \"from\": \"XBT\", \"to\": \"GBP\", \"value\": \"${XBT_GBP:0:7}\", \"min\": \"8034\", \"max\": \"9000\", \"amount\": 4.01955038, \"for\": 19850 }, { \"from\": \"XRP\", \"to\": \"GBP\", \"value\": \"${XRP_GBP:0:7}\", \"min\": \"0.50\", \"max\": \"0.75\", \"amount\": 37513.09998, \"for\": 20000 }, { \"from\": \"XAU\", \"to\": \"GBP\", \"value\": \"${XAU_GBP:8:7}\", \"min\": \"1245\", \"max\": \"1400\", \"amount\": 16.07537, \"for\": 22571.66 }, { \"from\": \"XAG\", \"to\": \"GBP\", \"value\": \"${XAG_GBP:8:7}\", \"min\": \"19\", \"max\": \"20\", \"amount\": 52.79153, \"for\": 1097.02 } ] }" > /tmp/currency-all
