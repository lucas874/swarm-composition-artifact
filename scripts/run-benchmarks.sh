#!/usr/bin/env bash

color_off='\033[0m'
green='\033[0;32m'
red='\033[0;31m'

error_and_exit() {
    echo -e "${red}ERROR.${color_off} Please send entire contents of $LOG_DIR/"
    exit 1
}

logfile=$LOG_DIR/report.log
num_files=454
msg_acc="[1/2] Accuracy experiment"
msg_perf="[2/2] Performance experiment"
mkdir -p $FULL_CRITERION_DATA_DIR
mkdir -p $FULL_ACCURACY_RESULT_DIR

# if experiments were already running in background for some reason -- terminate them
pkill -f "full_run_bench_sub_sizes_general"
pkill -f "composition_benchmark_full"

echo "Starting the experiments. It may take a minute to start."

cd $MACHINE_CHECK_DIR
echo "--Accuracy test began at: $(date)--" >> $logfile
cargo test -- --ignored --nocapture --exact full_run_bench_sub_sizes_general 2>&1 | tee -a $logfile | grep --line-buffered "done-special-symbol" | pv -N "$msg_acc" -l -t -p -s $num_files >> $LOG_DIR/matches.log
echo "--Accuracy ended at: $(date)--" >> $logfile
echo "--Performance test began at: $(date)--" >> $logfile
cargo criterion --offline --output-format quiet --plotting-backend disabled --bench composition_benchmark_full 2>&1 | tee -a $logfile | grep --line-buffered "done-special-symbol" | pv -N "$msg_perf" -l -t -p -s $num_files >> $LOG_DIR/matches.log
echo "--Performance test ended at: $(date)--" >> $logfile
echo "--Entering "$PROCESS_RES_DIR" and generating plots at: $(date)--" >> $logfile
cd $PROCESS_RES_DIR
python3 process_results.py -p $FULL_CRITERION_DATA_DIR -a $FULL_ACCURACY_RESULT_DIR -b $BENCHMARK_DIR_GENERAL -o $RES_FULL_DIR >> $logfile 2>&1

files=("$RES_FULL_DIR/accuracy_results.csv" "$RES_FULL_DIR/performance_results.csv" "$RES_FULL_DIR/out.pdf")
for file in "${files[@]}"; do
    if [ ! -e "$file" ]; then
        echo "ERROR: $file does not exist" >> $logfile
        error_and_exit
    fi
done
if ! diff "$RES_FULL_DIR/accuracy_results.csv" "$PROCESS_RES_DIR/golden_accuracy_results.csv" >> $logfile 2>&1; then
    echo "ERROR: $RES_FULL_DIR/accuracy_results.csv and $PROCESS_RES_DIR/golden_accuracy_results.csv differ." >> $logfile
    error_and_exit
fi
if [ $(wc -l < "$RES_FULL_DIR/performance_results.csv") -ne 455 ]; then
    echo "ERROR: $RES_FULL_DIR/performance_results.csv not as expected" >> $logfile
    error_and_exit
fi

echo -e "Experiments done. Everything is ${green}OK${color_off}. Results written to "$RES_FULL_DIR.""