#!/bin/bash
if [ "$#" -ne 4 ]; then
  echo "Usage: bash monitor_progress.sh <directory being monitored> <number of files expected at the end of process> <command to count files>"
  echo "Exiting."
  exit 1
fi

dir="$1"
target_size="$2"
count_cmd="$3"
interval=1  # check every 1 second
prev_size=0
#$3
#$count_cmd
#eval "$count_cmd"
curr_size= eval "$count_cmd"  #(find "$dir" -mindepth 2 -type d | wc -l)
while true; do
  delta=$((curr_size - prev_size))
  if (( delta > 0 )); then
    head -c "$delta" /dev/zero
  fi
  prev_size=$curr_size
  curr_size= eval "$count_cmd" #(find "$dir" -mindepth 2 -type d | wc -l)
  if ((prev_size >= target_size));
  then
    break
  fi
  sleep "$interval"
done | pv -N "$4" -t -p -s "$target_size" > /dev/null