#!/usr/bin/env bash

./cmd.sh 2>&1 | \
  tee full_output.log | \
  grep --line-buffered "your-pattern" | \
  pv -l -s 20