#!/bin/bash

GOLD_PRICE="$(curl -s -H 'x-access-token: goldapi-fv531ukmpy0br7-io' https://www.goldapi.io/api/XAU/GBP)";

XAU_GBP=$(echo $GOLD_PRICE | jq -r '.price');
XAU_GBP_KG=$(bc <<< "scale=4;$XAU_GBP * 32.15075")

echo "{ \"list\": [ { \"from\": \"XAU\", \"to\": \"GBP\", \"value\": \"$XAU_GBP_KG\", \"min\": \"40000\", \"max\": \"46000\", \"amount\": 0.5, \"for\": 22571.66 } ] }" ;
