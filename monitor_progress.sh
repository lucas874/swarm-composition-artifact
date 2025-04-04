#!/bin/bash

DIR="target/criterion/data/main/General-pattern-algorithm1-vs.-exact-short-run"
TARGET_SIZE=$((9600))
INTERVAL=1  # check every 1 second

prev_size=0
curr_size=$(du -sb "$DIR" | cut -f1)
while ((curr_size < TARGET_SIZE)); do
  delta=$((curr_size - prev_size))
  if (( delta > 0 )); then
    head -c "$delta" /dev/zero
  fi
  prev_size=$curr_size
  curr_size=$(du -sb "$DIR" | cut -f1)
  sleep "$INTERVAL"
done | pv -s "$TARGET_SIZE" > /dev/null

