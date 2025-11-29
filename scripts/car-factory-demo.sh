#!/usr/bin/env bash

cd $DEMO_DIR/car-factory/ && npm i >> $LOG_DIR/report.log 2>&1 && npm run build >> $LOG_DIR/report.log 2>&1 && bash start_car_factory.sh session2