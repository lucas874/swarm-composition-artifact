#!/usr/bin/env bash

tail -f /var/log/syslog 2>&1 | \
  tee full_output.log | \
  grep --line-buffered "spotify" | \
  pv -l -s 50