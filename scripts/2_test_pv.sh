#!/usr/bin/env bash

tail -f /var/log/syslog 2>&1 | tee -a full_output.log | grep --line-buffered "spotify" | pv -l -s 50 > output_2.log

# cargo test short_run_bench_sub_sizes_general -- --ignored --nocapture 2>lala.err | tee -a full_output.log | grep --line-buffered "done-special-symbol" | pv -l -s 4 > output_2.log

# cargo test full_run_bench_sub_sizes_general -- --ignored --nocapture 2>&1 | tee -a full_output.log | grep --line-buffered "done-special-symbol" | pv -l -s 454 >> output_2.log

# cargo criterion --offline --output-format quiet --plotting-backend disabled --bench composition_benchmark_short 2>&1 | tee -a full_output2.log | grep --line-buffered "done-special-symbol" | pv -l -s 4 >> output_2.log
