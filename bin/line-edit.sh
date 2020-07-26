#!/bin/bash

OUTPUT_FILE=$1

# Ensure we have an input file, even if one isn't setup
if [[ -z "$EDITOR_FILE" ]]; then
  EDITOR_FILE=/tmp/tmp.sql
fi;

# Set the result file
RESULT_FILE=/tmp/line-edit.data
rm -f $RESULT_FILE

# Edit the input file
$VISUAL $EDITOR_FILE

# Make the result file the requested output file
mv $RESULT_FILE $OUTPUT_FILE > /dev/null 2>&1

