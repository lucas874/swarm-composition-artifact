#!/bin/bash
color_off='\033[0m'
green='\033[0;32m'
red='\033[0;31m'

echo "Running:"
echo "  (1) Accuracy test."
echo "  (2) Performance test."

logfile=$LOG_DIR/report.log
num_files=906
mkdir -p $FULL_CRITERION_DATA_DIR
mkdir -p $FULL_ACCURACY_RESULT_DIR

cd $MACHINE_CHECK_DIR
echo "--Accuracy test began at: $(date)--" >> $logfile
cargo test -- --ignored --nocapture --exact full_run_bench_sub_sizes_general >> $logfile 2>&1 &
bash $DIR/scripts/monitor_progress_acc.sh $FULL_ACCURACY_RESULT_DIR $num_files "Accuracy test"
echo "--Accuracy ended at: $(date)--" >> $logfile
echo "--Performance test began at: $(date)--" >> $logfile
cargo criterion --offline --output-format quiet --plotting-backend disabled --bench composition_benchmark_full >> $logfile 2>&1 &
bash $DIR/scripts/monitor_progress_perf.sh $FULL_CRITERION_DATA_DIR $num_files "Performance test"
echo "--Performance test ended at: $(date)--" >> $logfile
echo "--Entering "$PROCESS_RES_DIR" and generating plots at: $(date)--" >> $logfile
cd $PROCESS_RES_DIR
python3 process_results.py -p $FULL_CRITERION_DATA_DIR -a $FULL_ACCURACY_RESULT_DIR -b $BENCHMARK_DIR_GENERAL -o $RES_DIR --short >> $logfile 2>&1
echo "--Entering "$DEMO_DIR/warehouse-factory-demo/" and running demo at: $(date)--" >> $logfile
cd $DEMO_DIR/warehouse-factory-demo/ && bash demo_run_machines.sh 2>> $logfile
echo "--Demo ended at: $(date)--" >> $logfile

files=("$RES_DIR/accuracy_results.csv" "$RES_DIR/performance_results.csv" "$RES_DIR/out.pdf")
for file in "${files[@]}"; do
    if [ ! -e "$file" ]; then
        echo "ERROR. Please send entire contents of $LOG_DIR"
       	exit 1
    fi
done

echo -e "Experiments done. Everything is ${green}OK${color_off}. Results are found in "$RES_DIR""

#date
#echo "Running: (1) full version of execution time experiments. (2) full version of subscription size experiments."
#cd $MACHINE_CHECK_DIR
#cargo criterion --offline --output-format quiet --plotting-backend disabled --bench composition_benchmark_full 2>/dev/null
#cargo test -- --ignored --nocapture --exact full_run_bench_sub_sizes_general 2>/dev/null
#cd $DIR/process_results
#python3 process_results.py -p $FULL_CRITERION_DATA_DIR -a $FULL_ACCURACY_RESULT_DIR -b $BENCHMARK_DIR_GENERAL
#date