#!/bin/bash

DaySuffix() {
  case $(( 10#`date +"%d"` )) in
    1|21|31) echo "st";;
    2|22)    echo "nd";;
    3|23)    echo "rd";;
    *)       echo "th";;
  esac
}

TimeSeparator() {
  if [ $(( 10#`date +"%S"` % 2 )) -eq 0 ]; then
    echo ":"
  else
    echo " "
  fi
}

date +"%a%e`DaySuffix` %b %Y, %H`TimeSeparator`%M"
