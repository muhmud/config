#!/bin/bash

notify-send -a "Timer" "$(~/bin/timer --status -D "$(cat ~/.timer/current)" | jq -r ".timer.current.task")"
