#!/bin/bash

if [ "$#" -ne 3 ]; then
  echo "Usage: bash monitor_progress_perf.sh <directory> <number of files expected in directory at the end> <message at progress bar>"
  echo "Exiting."
  exit 1
fi

dir="$1"
target_size="$2"
message="$3"
interval=1  # check every 1 second
prev_size=0
find_cmd=(find "$dir" -mindepth 2 -type d)
count_cmd=(wc -l)
curr_size=$("${find_cmd[@]}" | "${count_cmd[@]}")

while true; do
  delta=$((curr_size - prev_size))
  if (( delta > 0 )); then
    head -c "$delta" /dev/zero
  fi
  prev_size=$curr_size
  curr_size=$("${find_cmd[@]}" | "${count_cmd[@]}")
  if ((prev_size >= target_size));
  then
    break
  fi
  sleep "$interval"
done | pv -N "$message" -t -p -s "$target_size" > /dev/null