#!/bin/bash

UTC=`TZ="UTC" date +"%H:%M"`
LONDON=`TZ="Europe/London" date +"%H:%M"`
ISLAMABAD=`TZ="Asia/Karachi" date +"%H:%M"`
PHOENIX=`TZ="America/Phoenix" date +"%H:%M"`
MAKKAH=`TZ="Asia/Riyadh" date +"%H:%M"`
TEL_AVIV=`TZ="Asia/Tel_Aviv" date +"%H:%M"`
EASTERN=`TZ="America/New_York" date +"%H:%M"`
SLOVAKIA=`TZ="Europe/Bratislava" date +"%H:%M"`

echo -e " London: $LONDON %{F#FF0}|%{F-} Islamabad: $ISLAMABAD %{F#FF0}|%{F-} UTC: $UTC %{F#FF0}|%{F-} Makkah: $MAKKAH %{F#FF0}|%{F-} Eastern: $EASTERN"
