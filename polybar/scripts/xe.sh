#!/bin/bash

FILE=/tmp/currency-all
TICK_TIME=15
XBT_INDEX=3
XRP_INDEX=4

INDEX=-1
while true
do
    if [[ -f "$FILE" ]]; then
        SIZE=$(cat $FILE | jq --raw-output ".list | length" 2>/dev/null)
        INDEX=$((INDEX+1))
        if [[ $INDEX > $SIZE || $INDEX = $SIZE ]]; then
            INDEX=0;
        fi

        DATA=$(cat $FILE | jq --raw-output ".list[$INDEX]" 2>/dev/null)
        if [[ ! -z "$DATA" ]]; then
            FROM=$(echo $DATA | jq --raw-output ".from" 2>/dev/null)
            TO=$(echo $DATA | jq --raw-output ".to" 2>/dev/null)

            VALUE=$(echo $DATA | jq --raw-output ".value" 2>/dev/null)
            COLOUR=
            if [[ -z "$VALUE" ]]; then
                VALUE="???????";
                COLOUR="%{F#ff0}"
            else
                TEST_VALUE=${VALUE/","/""};
                MIN=$(echo $DATA | jq --raw-output ".min" 2>/dev/null);
                LESS_THAN_MIN=$(echo "scale=3; $TEST_VALUE <= $MIN" | bc);

                MAX=$(echo $DATA | jq --raw-output ".max" 2>/dev/null);
                MORE_THAN_MAX=$(echo "scale=3; $TEST_VALUE >= $MAX" | bc);

                if [[ $LESS_THAN_MIN = 1 ]]; then
                    COLOUR="%{F#f00}"
                elif [[ $MORE_THAN_MAX = 1 ]]; then
                    COLOUR="%{F#0f0}"
                fi

                AFTER_DOT=$(echo $VALUE | cut -d '.' -f 2);
                if [[ -z $AFTER_DOT ]]; then
                    VALUE=$(echo $VALUE | cut -d '.' -f 1);
                fi
            fi

            CHANGE=
            XDATA=$(cat $FILE | jq --raw-output ".list[$XBT_INDEX]" 2>/dev/null)
            XVALUE=$(echo $XDATA | jq --raw-output ".value" 2>/dev/null)
            if [[ ! -z "$XVALUE" ]]; then
                XTEST_VALUE=${XVALUE/","/""};
                AMOUNT=$(echo $XDATA | jq --raw-output ".amount" 2>/dev/null)
                FOR=$(echo $XDATA | jq --raw-output ".for" 2>/dev/null)

                if [[ ! -z $AMOUNT && $AMOUNT != 'null' ]]; then
                    AMOUNT_VALUE=$(echo "scale=2; $AMOUNT * ($XTEST_VALUE - $XTEST_VALUE * 0.015)" | bc);
                    AMOUNT_CHANGE=$(printf "%0.2f" $(echo "scale=2; $AMOUNT_VALUE - $FOR" | bc));
                    LESS_THAN_ZERO=$(echo "scale=3; $AMOUNT_CHANGE < 0" | bc);
                    if [[ $LESS_THAN_ZERO = 1 ]]; then
                        AMOUNT_CHANGE=$(printf "%0.2f" $(echo "scale=2; $AMOUNT_CHANGE * -1" | bc));
                        CHANGE=" %{F#FF0}|%{F-} %{F#f00}-£$AMOUNT_CHANGE%{F-}";
                    else
                        CHANGE=" %{F#FF0}|%{F-} %{F#0f0}+£$AMOUNT_CHANGE%{F-}";
                    fi
                fi
            fi

            XRP_CHANGE=
            XRP_XDATA=$(cat $FILE | jq --raw-output ".list[$XRP_INDEX]" 2>/dev/null)
            XRP_XVALUE=$(echo $XRP_XDATA | jq --raw-output ".value" 2>/dev/null)
            if [[ ! -z "$XRP_XVALUE" ]]; then
                XTEST_VALUE=${XRP_XVALUE/","/""};
                AMOUNT=$(echo $XRP_XDATA | jq --raw-output ".amount" 2>/dev/null)
                FOR=$(echo $XRP_XDATA | jq --raw-output ".for" 2>/dev/null)

                if [[ ! -z $AMOUNT && $AMOUNT != 'null' ]]; then
                    AMOUNT_VALUE=$(echo "scale=2; $AMOUNT * ($XTEST_VALUE - $XTEST_VALUE * 0.015)" | bc);
                    AMOUNT_CHANGE=$(printf "%0.2f" $(echo "scale=2; $AMOUNT_VALUE - $FOR" | bc));
                    LESS_THAN_ZERO=$(echo "scale=3; $AMOUNT_CHANGE < 0" | bc);
                    if [[ $LESS_THAN_ZERO = 1 ]]; then
                        AMOUNT_CHANGE=$(printf "%0.2f" $(echo "scale=2; $AMOUNT_CHANGE * -1" | bc));
                        XRP_CHANGE=" %{F#FF0}|%{F-} %{F#f00}-£$AMOUNT_CHANGE%{F-}";
                    else
                        XRP_CHANGE=" %{F#FF0}|%{F-} %{F#0f0}+£$AMOUNT_CHANGE%{F-}";
                    fi
                fi
            fi

            OUTPUT="${FROM} 1 = ${TO} ${COLOUR}${VALUE}%{F-}${CHANGE}${XRP_CHANGE}"
            FINAL_OUTPUT=`printf "%s" "$OUTPUT"`

            zscroll -l 128 -b " %{F#0f0}%{F-} " -d 0.3 -t $TICK_TIME -p "                    " "$FINAL_OUTPUT" &
            echo $! > /tmp/currency.sleep.pid
            wait $!
        fi
    else
        sleep $TICK_TIME &
        echo $! > /tmp/currency.sleep.pid
        wait $!
    fi
done
