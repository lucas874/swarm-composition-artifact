#!/bin/bash

# List of directories and their expected sizes (in bytes)
# Format: "dir_path:size_in_bytes"
PROCESS_LIST=(
  "./stage1:1073741824"    # 1GB
  "./stage2:2147483648"    # 2GB
  "./stage3:524288000"     # 500MB
  "./stage4:3145728000"    # 3GB
  "./stage5:157286400"     # 150MB
)

INTERVAL=1  # seconds between size checks

monitor_dir() {
  local dir=$1
  local target_size=$2
  local prev_size=0

  echo "Monitoring $dir until it reaches $(numfmt --to=iec "$target_size")..."

  (
    while true; do
      curr_size=$(du -sb "$dir" 2>/dev/null | cut -f1)
      delta=$((curr_size - prev_size))
      if (( delta > 0 )); then
        head -c "$delta" /dev/zero
      fi
      prev_size=$curr_size

      # Stop if the directory has reached or exceeded the target size
      if (( curr_size >= target_size )); then
        break
      fi
      sleep "$INTERVAL"
    done
  ) | pv -s "$target_size" > /dev/null

  echo "Finished monitoring $dir"
  echo
}

# Loop through the list of stages
for entry in "${PROCESS_LIST[@]}"; do
  IFS=':' read -r dir size <<< "$entry"
  monitor_dir "$dir" "$size"
done

echo "All stages completed!"
