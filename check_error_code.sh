#!/bin/bash

if ! pgrep -f subscription_size_experiments > /dev/null 2>&1; then
    echo "Process does not exist!"
else
    echo "Process exists!"
fi
