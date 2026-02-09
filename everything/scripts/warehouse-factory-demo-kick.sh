#!/usr/bin/env bash

cd $DEMO_DIR/warehouse-factory/
echo "Starting warehouse demo. It may take a minute to start."
npm i >> $LOG_DIR/report.log 2>&1
npm run build >> $LOG_DIR/report.log 2>&1

date >> $1
date >> $2

bash kick_the_tires.sh session1