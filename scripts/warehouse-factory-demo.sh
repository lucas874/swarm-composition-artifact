#!/bin/bash
cd $DEMO_DIR/warehouse-factory-demo/ && npm i >> $LOG_DIR/report.log 2>&1 && bash demo_run_machines.sh
