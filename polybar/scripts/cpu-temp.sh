#!/bin/bash

TEMP=`sensors | grep Package | awk -F " " '{ print $4 }'`

echo " ${TEMP:1:128}"

