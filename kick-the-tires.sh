#!/bin/bash
date
echo "Running: (1) short version of execution time experiments. (2) short version of subscription size experiments. (3) Warehouse || Factory demo."
cd machines/machine-check
cargo criterion --offline --output-format quiet --plotting-backend disabled --bench composition_benchmark_short 2>/dev/null
cargo test -- --ignored --nocapture --exact short_run_bench_sub_sizes_general 2>/dev/null
cd $DIR/process_results
python3 process_results.py -p $SHORT_CRITERION_DATA_DIR -a $SHORT_ACCURACY_RESULT_DIR --short
cd /ecoop25_artifact/machines/warehouse-factory-demo/ && bash demo_run_machines.sh
date