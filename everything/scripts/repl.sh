#!/usr/bin/env bash

show_help() {
    echo "Available commands:"
    echo "  1 - kick-the-tires"
    echo "  2 - Run experiments"
    echo "  3 - Run warehouse demo"
    echo "  4 - Run warehouse || factory demo"
    echo "  5 - Run warehouse || factory || quality demo"
    echo "  6 - Run car factory demo (composition of 7 protocols instantiated with 25 machines)"
    echo "  help - Show this help message"
    echo "  exit - Exit"
    echo
}

kick_the_tires() {
    /swarm-composition/scripts/kick-the-tires.sh
}

run_experiments() {
    /swarm-composition/scripts/run-benchmarks.sh
}

run_warehouse_demo() {
    echo "Starting warehouse demo. It may take a minute to start."
    /swarm-composition/scripts/warehouse-demo.sh
}

run_warehouse_factory_demo() {
    echo "Starting warehouse || factory demo. It may take a minute to start."
    /swarm-composition/scripts/warehouse-factory-demo.sh
}

run_warehouse_factory_quality_demo() {
    echo "Starting warehouse || factory || quality demo. It may take a minute to start."
    /swarm-composition/scripts/warehouse-factory-quality-demo.sh
}

run_car_factory_demo() {
    echo "Starting car factory demo. It may take a minute to start."
    /swarm-composition/scripts/car-factory-demo.sh
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
            run_car_factory_demo
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
