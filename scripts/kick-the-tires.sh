#!/bin/bash

echo "Running:"
echo "  (1) Shortened performance tests."
echo "  (2) Shortened accuracy tests."
echo "  (3) Warehouse || Factory demo."

short_log=$DIR/logs/short_test.log
rm -rf $SHORT_CRITERION_DATA_DIR
mkdir -p $SHORT_CRITERION_DATA_DIR
rm -rf $SHORT_ACCURACY_RESULT_DIR
mkdir -p $SHORT_ACCURACY_RESULT_DIR

cd $MACHINE_CHECK_DIR
echo "--Shortened performance test began at: $(date)--" >> $short_log
cargo criterion --offline --output-format quiet --plotting-backend disabled --bench composition_benchmark_short >> $short_log 2>&1 &
bash $DIR/scripts/monitor_progress_perf.sh $SHORT_CRITERION_DATA_DIR 8 "Shortened performance test"
echo "--Shortened performance test ended at: $(date)--" >> $short_log
echo "--Shortened accuracy test began at: $(date)--" >> $short_log
cargo test -- --ignored --nocapture --exact short_run_bench_sub_sizes_general >> $short_log 2>&1 &
bash $DIR/scripts/monitor_progress_acc.sh $SHORT_ACCURACY_RESULT_DIR 8 "Shortened accuracy test"
echo "--Shortened accuracy ended at: $(date)--" >> $short_log
echo "--Entering "$PROCESS_RES_DIR" and generating plots at: $(date)--" >> $short_log
cd $PROCESS_RES_DIR
python3 process_results.py -p $SHORT_CRITERION_DATA_DIR -a $SHORT_ACCURACY_RESULT_DIR -b $BENCHMARK_DIR --short >> $short_log 2>&1
echo "--Entering "$DEMO_DIR/warehouse-factory-demo/" and running demo at: $(date)--" >> $short_log
cd $DEMO_DIR/warehouse-factory-demo/ && bash demo_run_machines.sh
echo "--Demo ended at: $(date)--" >> $short_log