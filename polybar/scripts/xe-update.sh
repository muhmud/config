
#!/bin/bash

USD_MYR=`/home/muhmud/bin/xe USD MYR 2>/dev/null`
GBP_MYR=`/home/muhmud/bin/xe GBP MYR 2>/dev/null`
MYR_PKR=`/home/muhmud/bin/xe MYR PKR 2>/dev/null`
XBT_GBP=`curl -s -X GET https://api.coindesk.com/v1/bpi/currentprice.json | jq '.bpi.GBP.rate_float'`

echo "{ \"list\": [ { \"from\": \"USD\", \"to\": \"MYR\", \"value\": \"${USD_MYR:8:7}\", \"min\": \"4.05\", \"max\": \"4.15\" }, { \"from\": \"GBP\", \"to\": \"MYR\", \"value\": \"${GBP_MYR:8:7}\", \"min\": \"5.05\", \"max\": \"5.5\" }, { \"from\": \"MYR\", \"to\": \"PKR\", \"value\": \"${MYR_PKR:8:7}\", \"min\": \"35.0\", \"max\": \"40.0\" }, { \"from\": \"XBT\", \"to\": \"GBP\", \"value\": \"${XBT_GBP:0:7}\", \"min\": \"8034\", \"max\": \"9000\", \"amount\": 2.0312276, \"for\": 15000 } ] }" > /tmp/currency-all
