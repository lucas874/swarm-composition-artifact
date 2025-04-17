#!/usr/bin/env bash

show_help() {
    echo "Available commands:"
    echo "  1 - kick-the-tires"
    echo "  2 - Run experiments"
    echo "  3 - Run warehouse demo"
    echo "  4 - Run warehouse || factory demo"
    echo "  5 - Run warehouse || factory || quality"
    echo "  6 - Run warehouse without branch tracking demo"
    echo "  help - Show this help message"
    echo "  exit - Exit"
    echo
}

kick_the_tires() {
    /ecoop25_artifact/scripts/kick-the-tires.sh
}

run_experiments() {
    /ecoop25_artifact/scripts/run-benchmarks.sh
}

run_warehouse_demo() {
    echo "Starting warehouse demo. It may take a minute to start."
    /ecoop25_artifact/scripts/warehouse-demo.sh
}

run_warehouse_factory_demo() {
    echo "Starting warehouse || factory demo. It may take a minute to start."
    /ecoop25_artifact/scripts/warehouse-factory-demo.sh
}

run_warehouse_factory_quality_demo() {
    echo "Starting warehouse || factory || quality demo. It may take a minute to start."
    /ecoop25_artifact/scripts/warehouse-factory-quality-demo.sh
}

run_warehouse_no_bt_demo() {
    echo "Starting warehouse demo without branch tracking. It may take a minute to start."
    /ecoop25_artifact/scripts/warehouse-demo-no-branch-tracking.sh
}



source $NVM_DIR/nvm.sh

# Show help at startup
show_help

# Start REPL loop
while true; do
    read -rp "> " input
    echo "in repl commmand is $input. $(date)" >> $LOG_DIR/report.log
    case "$input" in
        1)
            kick_the_tires
            ;;
        2)
            run_experiments
            ;;
        3)
            run_warehouse_demo
            ;;
        4)
            run_warehouse_factory_demo
            ;;
        5)
            run_warehouse_factory_quality_demo
            ;;
        6)
            run_warehouse_no_bt_demo
            ;;
        help)
            show_help
            ;;
        exit)
            echo "Goodbye!"
            break
            ;;
        *)
            echo "Unknown command: $input"
            echo "Type 'help' to see available commands."
            ;;
    esac
done
