#!/bin/bash
color_off='\033[0m'
green='\033[0;32m'
red='\033[0;31m'

error_and_exit() {
    echo -e "${red}ERROR.${color_off} Please send entire contents of $LOG_DIR/"
    exit 1
}

logfile=$LOG_DIR/report.log
machine_logfile=$LOG_DIR/machines.log
ax_logfile=$LOG_DIR/ax_all.log
num_files=8
rm -rf $SHORT_CRITERION_DATA_DIR
mkdir -p $SHORT_CRITERION_DATA_DIR
rm -rf $SHORT_ACCURACY_RESULT_DIR
mkdir -p $SHORT_ACCURACY_RESULT_DIR

cd $MACHINE_CHECK_DIR
echo "--Shortened accuracy test began at: $(date)--" >> $logfile
cargo test -- --ignored --nocapture --exact short_run_bench_sub_sizes_general >> $logfile 2>&1 &
bash $DIR/scripts/monitor_progress_acc.sh $SHORT_ACCURACY_RESULT_DIR $num_files "[1/3] Shortened accuracy experiment"
echo "--Shortened accuracy ended at: $(date)--" >> $logfile
echo "--Shortened performance test began at: $(date)--" >> $logfile
cargo criterion --offline --output-format quiet --plotting-backend disabled --bench composition_benchmark_short >> $logfile 2>&1 &
bash $DIR/scripts/monitor_progress_perf.sh $SHORT_CRITERION_DATA_DIR $num_files "[2/3] Shortened performance experiment"
echo "--Shortened performance test ended at: $(date)--" >> $logfile
echo "--Entering "$PROCESS_RES_DIR" and generating plots at: $(date)--" >> $logfile
cd $PROCESS_RES_DIR
python3 process_results.py -p $SHORT_CRITERION_DATA_DIR -a $SHORT_ACCURACY_RESULT_DIR -b $BENCHMARK_DIR_GENERAL -o $RES_SHORT_DIR >> $logfile 2>&1
echo "--Running demo at: $(date)--" >> $logfile
bash $DIR/scripts/warehouse-factory-demo-kick.sh $machine_logfile $ax_logfile 2>> $logfile
echo "--Demo ended at: $(date)--" >> $logfile
echo "[3/3] Warehouse || Factory demo"

files=("$RES_SHORT_DIR/accuracy_results.csv" "$RES_SHORT_DIR/performance_results.csv" "$RES_SHORT_DIR/out.pdf")
for file in "${files[@]}"; do
    if [ ! -e "$file" ]; then
        echo "ERROR: $file does not exist" >> $logfile
        error_and_exit
    fi
done
if ! diff "$RES_SHORT_DIR/accuracy_results.csv" "$PROCESS_RES_DIR/golden_accuracy_results_short.csv" >> $logfile 2>&1; then
    echo "ERROR: $RES_SHORT_DIR/accuracy_results.csv and $PROCESS_RES_DIR/golden_accuracy_results_short.csv differ." >> $logfile
    error_and_exit
fi
if [ $(wc -l < "$RES_SHORT_DIR/performance_results.csv") -ne 5 ]; then
    echo "ERROR: $RES_SHORT_DIR/performance_results.csv not as expected" >> $logfile
    error_and_exit
fi
files=("$RLOG" "$FLOG" "$TLOG" "$DLOG")
for file in "${files[@]}"; do
    if [ ! -e "$file" ]; then
        echo "ERROR: $file does not exist" >> $logfile
        error_and_exit
    elif ! grep "final state" $file > /dev/null 2>&1; then
        echo "ERROR: $file machine did not reach final state" >> $logfile
        error_and_exit
    fi
done

echo -e "kick-the-tires everything is ${green}OK.${color_off} Results are written to "$RES_SHORT_DIR.""