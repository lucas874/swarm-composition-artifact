#!/bin/bash
color_off='\033[0m'       # Text Reset
green='\033[0;32m'        # Green
red='\033[0;31m'

echo "Running:"
echo "  (1) Shortened accuracy tests."
echo "  (2) Shortened performance tests."
echo "  (3) Warehouse || Factory demo."

logfile=$LOG_DIR/report.log
rm -rf $SHORT_CRITERION_DATA_DIR
mkdir -p $SHORT_CRITERION_DATA_DIR
rm -rf $SHORT_ACCURACY_RESULT_DIR
mkdir -p $SHORT_ACCURACY_RESULT_DIR

cd $MACHINE_CHECK_DIR
echo "--Shortened accuracy test began at: $(date)--" >> $logfile
cargo test -- --ignored --nocapture --exact short_run_bench_sub_sizes_general >> $logfile 2>&1 &
bash $DIR/scripts/monitor_progress_acc.sh $SHORT_ACCURACY_RESULT_DIR 8 "Shortened accuracy test"
echo "--Shortened accuracy ended at: $(date)--" >> $logfile
echo "--Shortened performance test began at: $(date)--" >> $logfile
cargo criterion --offline --output-format quiet --plotting-backend disabled --bench composition_benchmark_short >> $logfile 2>&1 &
bash $DIR/scripts/monitor_progress_perf.sh $SHORT_CRITERION_DATA_DIR 8 "Shortened performance test"
echo "--Shortened performance test ended at: $(date)--" >> $logfile
echo "--Entering "$PROCESS_RES_DIR" and generating plots at: $(date)--" >> $logfile
cd $PROCESS_RES_DIR
python3 process_results.py -p $SHORT_CRITERION_DATA_DIR -a $SHORT_ACCURACY_RESULT_DIR -b $BENCHMARK_DIR_GENERAL -o $RES_SHORT_DIR --short >> $logfile 2>&1
echo "--Entering "$DEMO_DIR/warehouse-factory-demo/" and running demo at: $(date)--" >> $logfile
cd $DEMO_DIR/warehouse-factory-demo/ && bash demo_run_machines.sh 2>> $logfile
echo "--Demo ended at: $(date)--" >> $logfile

files=("$RES_SHORT_DIR/accuracy_results.csv" "$RES_SHORT_DIR/performance_results.csv" "$RES_SHORT_DIR/out.pdf")
for file in "${files[@]}"; do
    if [ ! -e "$file" ]; then
        echo "ERROR. Please send entire contents of $LOG_DIR"
       	exit 1
    fi
done
if ! diff "$RES_SHORT_DIR/accuracy_results.csv" "$PROCESS_RES_DIR/golden_accuracy_results.csv" >> $logfile 2>&1; then
    echo -e "${red}ERROR. Please send entire contents of $LOG_DIR/${color_off}"
    exit 1
fi

#echo "kick-the-tires everything is OK"
echo -e "${green}kick-the-tires everything is OK${color_off}"

#tput cuu 4; tput el;echo "  (1) Shortened performance tests [X].";tput cud 4