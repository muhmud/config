#!/bin/bash

LONDON=`TZ="Europe/London" date +"%H:%M"`
ISLAMABAD=`TZ="Asia/Karachi" date +"%H:%M"`
PHOENIX=`TZ="America/Phoenix" date +"%H:%M"`
TEL_AVIV=`TZ="Asia/Tel_Aviv" date +"%H:%M"`
EASTERN=`TZ="America/New_York" date +"%H:%M"`
SYDNEY=`TZ="Australia/Sydney" date +"%H:%M"`

echo -e " London: $LONDON %{F#FF0}|%{F-} Islamabad: $ISLAMABAD %{F#FF0}|%{F-} Phoenix: $PHOENIX %{F#FF0}|%{F-} Tel Aviv: $TEL_AVIV %{F#FF0}|%{F-} Eastern: $EASTERN %{F#FF0}|%{F-} Sydney: $SYDNEY"
