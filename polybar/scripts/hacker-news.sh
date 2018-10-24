#!/bin/bash

MINUTE=$((10#`date +"%M"`))

~/.config/polybar/scripts/hacker-news.py > /tmp/hacker-news-top
