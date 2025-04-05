#!/bin/bash
date
echo "Running:"
echo "  (1) Shortened performance tests."
echo "  (2) Shortened accuracy tests."
echo "  (3) Warehouse || Factory demo."
printf "\n"
cd $MACHINE_CHECK_DIR
echo "Starting shortened performance test" >> $DIR/logs/perf_short.out
cargo criterion --offline --output-format quiet --plotting-backend disabled --bench composition_benchmark_short >> $DIR/logs/out_perf_short.txt 2>&1 &
bash $DIR/scripts/monitor_progress.sh $MACHINE_CHECK_DIR/target/criterion/data/main/General-pattern-algorithm1-vs.-exact-short-run/ 8
cargo test -- --ignored --nocapture --exact short_run_bench_sub_sizes_general #2>/dev/null
cd $DIR/process_results
python3 process_results.py -p $SHORT_CRITERION_DATA_DIR -a $SHORT_ACCURACY_RESULT_DIR -b $BENCHMARK_DIR --short
cd $DEMO_DIR/warehouse-factory-demo/ && bash demo_run_machines.sh
date