#!/bin/bash

SUMMARY=$2

if [[ "$SUMMARY" != *\[Toptal\ Community\]\ in\ #* ]]; then
  wmctrl -r "Slack" -b add,demands_attention
fi
