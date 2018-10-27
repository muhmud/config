#!/bin/bash

LONDON=`TZ="Europe/London" date +"%H:%M"`
ISLAMABAD=`TZ="Asia/Karachi" date +"%H:%M"`
PHOENIX=`TZ="America/Phoenix" date +"%H:%M"`
TEL_AVIV=`TZ="Asia/Tel_Aviv" date +"%H:%M"`

echo -e " London: $LONDON %{F#FF0}|%{F-} Islamabad: $ISLAMABAD %{F#FF0}|%{F-} Phoenix: $PHOENIX %{F#FF0}|%{F-} Tel Aviv: $TEL_AVIV"
