#!/usr/bin/env bash

show_help() {
    echo "Available commands:"
    echo "  1 - kick-the-tires"
    echo "  2 - Run experiments"
    echo "  3 - Run warehouse demo"
    echo "  help - Show this help message"
    echo "  exit - Exit the REPL"
    echo
}

command_one() {
    /ecoop25_artifact/scripts/kick-the-tires.sh
}

command_two() {
    /ecoop25_artifact/scripts/run-benchmarks.sh
}

command_three() {
    echo "Running command three..."
    # Your logic here
}

source $NVM_DIR/nvm.sh

# Show help at startup
show_help

# Start REPL loop
while true; do
    read -rp "> " input
    case "$input" in
        1)
            command_one
            ;;
        2)
            command_two
            ;;
        3)
            command_three
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

