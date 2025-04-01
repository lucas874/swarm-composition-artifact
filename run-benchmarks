#!/bin/bash
date
echo "Running: (1) full version of execution time experiments. (2) full version of subscription size experiments."
cd machines/machine-check
cargo criterion --offline --output-format quiet --plotting-backend disabled --bench composition_benchmark_full 2>/dev/null
cargo test -- --ignored --nocapture --exact full_run_bench_sub_sizes_general 2>/dev/null
cd $DIR/process_results
python3 process_results.py -p $FULL_CRITERION_DATA_DIR -a $FULL_ACCURACY_RESULT_DIR
date