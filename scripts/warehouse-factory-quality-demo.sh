#!/usr/bin/env bash

cd $DEMO_DIR/warehouse-factory/ && npm i >> $LOG_DIR/report.log 2>&1 && npm run build >> $LOG_DIR/report.log 2>&1 && bash start_warehouse_factory_quality.sh session1