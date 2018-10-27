#!/bin/bash

function getColor() {
    VALUE_MEDIUM=`bc <<< "scale=2;$1 >= 2"`;
    VALUE_HIGH=`bc <<< "scale=2;$1 >= 4"`;

    if [[ $VALUE_MEDIUM == 0 && $VALUE_HIGH == 0 ]]; then
        echo "";
    elif [[ $VALUE_MEDIUM == 1 && $VALUE_HIGH == 0 ]]; then
        echo "%{F#fa0}";
    elif [[ $VALUE_HIGH == 1 ]]; then
        echo "%{F#f00}";
    fi
}

DATA=`uptime | awk -F 'load average:' '{ print $2 }'`

VALUE_1=`echo $DATA | awk -F ',' '{ print $1 }'`
VALUE_2=`echo $DATA | awk -F ',' '{ print $2 }'`
VALUE_3=`echo $DATA | awk -F ',' '{ print $2 }'`

echo -e " `getColor $VALUE_1`$VALUE_1%{F-},`getColor $VALUE_2`$VALUE_2%{F-},`getColor $VALUE_3`$VALUE_3%{F-}"

