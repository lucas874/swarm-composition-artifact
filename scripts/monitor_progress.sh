#!/bin/bash

if [ -z "$1" ]
then
  echo "No input path given. Exiting."
  exit 1
fi

if [ -z "$2" ]
then
  echo "No target number of files given. Exiting."
  exit 1
fi
dir="$1"
target_size="$2"
interval=1  # check every 1 second
prev_size=0
curr_size=$(find "$dir" -mindepth 2 -type d | wc -l)
while true; do
  delta=$((curr_size - prev_size))
  if (( delta > 0 )); then
    head -c "$delta" /dev/zero
  fi
  prev_size=$curr_size
  curr_size=$(find "$dir" -mindepth 2 -type d | wc -l)
  if ((prev_size >= target_size));
  then
    break
  fi
  sleep "$interval"
done | pv -N "Shortened performance test" -t -p -s "$target_size" > /dev/null