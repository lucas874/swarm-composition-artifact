#!/bin/bash

# Define the list of files to check
#files=("file_a" "file_b" "file_c")
files=("Dockerfile" "machines/" "some_commands.txt")
# Loop through the list of files
for file in "${files[@]}"; do
    if [ ! -e "$file" ]; then
        echo "ERROR"
       	exit 1 
    fi
done
echo "OK"


    


