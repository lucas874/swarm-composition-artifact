#!/usr/bin/env bash

docker run -it --rm -v $(pwd)/demos:/ecoop25_artifact/demos -v $(pwd)/results:/ecoop25_artifact/results -v $(pwd)/logs:/ecoop25_artifact/logs ecoop25_artifact /ecoop25_artifact/scripts/repl.sh
