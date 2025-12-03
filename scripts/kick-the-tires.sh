#!/usr/bin/env bash

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
num_files=4
num_files_compositional_vs_ecoop23=18
msg_acc="[1/4] Shortened accuracy experiment"
msg_comp_vs_ecoop23="[2/4] Shortened compositional vs. ECOOP23 experiment"
msg_perf="[3/4] Shortened performance experiment"
rm -rf $SHORT_CRITERION_DATA_DIR
mkdir -p $SHORT_CRITERION_DATA_DIR
rm -rf $SHORT_ACCURACY_RESULT_DIR
mkdir -p $SHORT_ACCURACY_RESULT_DIR

pkill -f "short_run_bench_sub_sizes_general"
pkill -f "composition_benchmark_short"

echo "Starting the kick-the-tires script. It may take a minute to start."

cd $MACHINE_CHECK_DIR
echo "--Shortened accuracy test began at: $(date)--" >> $logfile
cargo test -- --ignored --nocapture --exact short_run_bench_sub_sizes_general 2>&1 | tee -a $logfile | grep --line-buffered "done-special-symbol" | pv -N "$msg_acc" -l -t -p -s $num_files >> $LOG_DIR/matches.log
echo "--Shortened accuracy ended at: $(date)--" >> $logfile
echo "--Shortened compositional vs ecoop23 test began at: $(date)--" >> $logfile
cargo test short_simple_run_bench_sub_sizes_general -- --nocapture --ignored --exact 2>&1 | tee -a $logfile | grep --line-buffered "done-special-symbol" | pv -N "$msg_comp_vs_ecoop23" -l -t -p -s $num_files_compositional_vs_ecoop23 >> $LOG_DIR/matches.log
echo "--Shortened compositional vs ecoop23 ended at: $(date)--" >> $logfile
echo "--Shortened performance test began at: $(date)--" >> $logfile
cargo criterion --offline --output-format quiet --plotting-backend disabled --bench composition_benchmark_short 2>&1 | tee -a $logfile | grep --line-buffered "done-special-symbol" | pv -N "$msg_perf" -l -t -p -s $num_files >> $LOG_DIR/matches.log
echo "--Shortened performance test ended at: $(date)--" >> $logfile
echo "--Entering "$PROCESS_RES_DIR" and generating plots at: $(date)--" >> $logfile
cd $PROCESS_RES_DIR
python3 process_results.py -p $SHORT_CRITERION_DATA_DIR -a $SHORT_ACCURACY_RESULT_DIR -b $BENCHMARK_DIR_GENERAL -o $RES_SHORT_DIR >> $logfile 2>&1
python3 process_compositional_vs_kmt23_results.py -a $SHORT_COMPOSITIONAL_VS_ECOOP23_DIR -o $RES_SHORT_DIR -c $SHORT_COMPOSITIONAL_VS_ECOOP23_CSV >> $logfile 2>&1
echo "--Running demo at: $(date)--" >> $logfile
bash $DIR/scripts/warehouse-factory-demo-kick.sh $machine_logfile $ax_logfile 2>> $logfile
mv $DEMO_DIR/warehouse-factory/transport_log.txt $TLOG
mv $DEMO_DIR/warehouse-factory/door_log.txt $DLOG
mv $DEMO_DIR/warehouse-factory/forklift_log.txt $FLOG
mv $DEMO_DIR/warehouse-factory/robot_log.txt $RLOG

echo "--Demo ended at: $(date)--" >> $logfile
echo "[4/4] Warehouse || Factory demo"

files=("$RES_SHORT_DIR/accuracy_results.csv" "$RES_SHORT_DIR/performance_results.csv" "$RES_SHORT_DIR/figures.pdf" "$RES_SHORT_DIR/short_run_compositional_vs_ecoop23.csv" "$RES_SHORT_DIR/compositional_vs_ecoop23.pdf")
for file in "${files[@]}"; do
    if [ ! -e "$file" ]; then
        echo "ERROR: $file does not exist" >> $logfile
        error_and_exit
    fi
done

if [ $(wc -l < "$RES_SHORT_DIR/performance_results.csv") -ne 5 ]; then
    echo "ERROR: $RES_SHORT_DIR/performance_results.csv not as expected" >> $logfile
    error_and_exit
fi
files=("$RLOG" "$FLOG" "$TLOG" "$DLOG")
for file in "${files[@]}"; do
    if [ ! -e "$file" ]; then
        echo "ERROR: $file does not exist" >> $logfile
        error_and_exit
    elif ! grep "ok" $file > /dev/null 2>&1; then
        echo "ERROR: $file machine did not reach final state" >> $logfile
        error_and_exit
    fi
done

echo -e "kick-the-tires everything is ${green}OK.${color_off} Results are written to "$RES_SHORT_DIR.""