#!/bin/bash
date
echo "Running:"
echo "  (1) Shortened performance tests."
echo "  (2) Shortened accuracy tests."
echo "  (3) Warehouse || Factory demo."
printf "\n"
perf_log=$DIR/logs/perf_short.out
acc_log=$DIR/logs/acc_short.out
cd $MACHINE_CHECK_DIR
echo "Starting shortened performance test" >> $perf_log
cargo criterion --offline --output-format quiet --plotting-backend disabled --bench composition_benchmark_short >> $perf_log 2>&1 &
bash $DIR/scripts/monitor_progress.sh $SHORT_CRITERION_DATA_DIR 8
#bash $DIR/scripts/mo.sh $SHORT_CRITERION_DATA_DIR 8 'find $SHORT_CRITERION_DATA_DIR -mindepth 2 -type d | wc -l' "Shortened performance test"
echo "Starting shortened performance test" >> $acc_log
cargo test -- --ignored --nocapture --exact short_run_bench_sub_sizes_general >> $acc_log 2>&1 &
bash $DIR/scripts/monitor_sub_size.sh $SHORT_ACCURACY_RESULT_DIR 8
cd $DIR/process_results
python3 process_results.py -p $SHORT_CRITERION_DATA_DIR -a $SHORT_ACCURACY_RESULT_DIR -b $BENCHMARK_DIR --short
cd $DEMO_DIR/warehouse-factory-demo/ && bash demo_run_machines.sh
date