#!/bin/bash

OUTPUT_FILE=$1

# Ensure we have an input file, even if one isn't setup
if [[ -z "$EDITOR_FILE" ]]; then
  if [[ ! -z "$DEFAULT_EDITOR_FILE" ]]; then
    EDITOR_FILE=$DEFAULT_EDITOR_FILE 
  else
    EDITOR_FILE=/tmp/tmp.sql
  fi;
fi;

# Set the result file
RESULT_FILE=/tmp/line-edit.data
rm -f $RESULT_FILE

# Edit the input file
tmux split-window $VISUAL $EDITOR_FILE \; resize-pane -Z
while [[ $(tmux list-panes | wc -l) -gt 1 ]]; do
  sleep 0.5;
done;

# Make the result file the requested output file
if [[ -f $RESULT_FILE ]]; then
  mv $RESULT_FILE $OUTPUT_FILE > /dev/null 2>&1
else
  echo ';' > $OUTPUT_FILE;
fi;

