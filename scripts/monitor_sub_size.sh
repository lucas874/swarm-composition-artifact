#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: bash monitor_sub_size.sh <directory being monitored> <number of files expected at the end of process>"
  echo "Exiting."
  exit 1
fi

dir="$1"
target_size="$2"
interval=1  # check every 1 second
prev_size=0
curr_size=$(find "$dir" -type f | wc -l)
while true; do
  delta=$((curr_size - prev_size))
  if (( delta > 0 )); then
    head -c "$delta" /dev/zero
  fi
  prev_size=$curr_size
  curr_size=$(find "$dir" -type f | wc -l)
  if ((prev_size >= target_size));
  then
    break
  fi
  sleep "$interval"
done | pv -N "Shortened accuracy test" -t -p -s "$target_size" > /dev/null
