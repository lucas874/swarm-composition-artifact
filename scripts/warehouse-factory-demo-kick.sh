#!/bin/bash

cd $DEMO_DIR/warehouse-factory-demo-kick/

# Commands to run in each window and pane
START_R="echo 'Starting factory-robot of the Warehouse || Factory protocol.'; npm run start-factory-robot 2>&1 | tee -a $RLOG;exec bash"
START_FL="echo 'Starting forklift of the Warehouse || Factory protocol.'; npm run start-forklift 2>&1 | tee -a $FLOG;exec bash"
START_T="echo 'Starting transporter of the Warehouse || Factory protocol.'; npm run start-transporter 2>&1 | tee -a $TLOG;exec bash"
START_D="echo 'Starting door of the Warehouse || Factory protocol.'; npm run start-door 2>&1 | tee -a $DLOG;exec bash"
START_AX="rm -rf ax-data; echo 'Silently running Actyx middleware in this window. Press Ctrl + C to exit'.; ax run >> $2 2>&1"

date >> $1
date >> $2

# Start a new tmux session with the first command
tmux new-session -d -s demo "$START_AX"

# New window to run actual demo
tmux new-window -n demo-window "$START_R"

# Split into panes and run different machines
tmux split-window -h "$START_FL"

tmux select-pane -t 0
tmux split-window -v "$START_D"

tmux select-pane -t 2
tmux split-window -v "$START_T"

# Attach to the session
tmux attach-session -t demo
tmux select-window demo-window
