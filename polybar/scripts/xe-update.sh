#!/bin/bash

USD_MYR=`/home/muhmud/bin/xe USD MYR 2>/dev/null`
GBP_MYR=`/home/muhmud/bin/xe GBP MYR 2>/dev/null`
MYR_PKR=`/home/muhmud/bin/xe MYR PKR 2>/dev/null`

echo "{ \"list\": [ { \"from\": \"\$\", \"to\": \"RM \", \"value\": \"${USD_MYR:8:7}\" }, { \"from\": \"£\", \"to\": \"RM \", \"value\": \"${GBP_MYR:8:7}\" }, { \"from\": \"RM \", \"to\": \"PKR \", \"value\": \"${MYR_PKR:8:7}\" } ] }" > /tmp/currency-all


