#!/usr/bin/env bash

if [ "$#" -ne 5 ]; then
  echo "Usage: bash monitor_progress_acc.sh <directory> <number of files expected in directory at the end> <message at progress bar> <logfile> <short/full>"
  echo "Exiting."
  exit 1
fi

dir="$1"
target_size="$2"
message="$3"
logfile="$4"
experiment_version="$5"
interval=1  # check every 1 second
prev_size=0
find_cmd=(find "$dir" -type f)
count_cmd=(wc -l)
curr_size=$("${find_cmd[@]}" | "${count_cmd[@]}")

case "$experiment_version" in
  "short")
    process_to_grep="short_run_bench_sub_sizes_general"
    ;;
  "full")
    process_to_grep="full_run_bench_sub_sizes_general"
    ;;
    *)
    echo "Monitor progress accuracy error in experiment version arg: $experiment_version. Should be short or full" >> $logfile
    echo "Error invalid argument: $experiment_version. Positional argument 5 should be short or full" >> $logfile
    echo "Error invalid argument: $experiment_version. Positional argument 5 should be short or full"
    exit 1
    ;;
esac

echo "waiting for process $process_to_grep to start at: $(date)" >> $logfile

# Busy wait for process to begin, break if waiting more than 5 minutes. Should take seconds.
while ! pgrep -f $process_to_grep > /dev/null 2>&1; do
  if [ $(ps -o etimes= -p "$$") -gt $((5 * 60)) ]; then
    break
  fi
done

echo "process $process_to_grep started at: $(date)" >> $logfile

# Loop and update progress bar.
while true; do
  delta=$((curr_size - prev_size))
  if (( delta > 0 )); then
    head -c "$delta" /dev/zero
  fi
  prev_size=$curr_size
  curr_size=$("${find_cmd[@]}" | "${count_cmd[@]}")

  # Terminate loop if monitored process finished.
  if ! pgrep -f $process_to_grep > /dev/null 2>&1; then
    delta=$((curr_size - prev_size))
    head -c "$delta" /dev/zero
    break
  fi
  sleep "$interval"
done | pv -N "$message" -t -p -s "$target_size" > /dev/null