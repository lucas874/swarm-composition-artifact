#!/usr/bin/env bash

docker run -it --rm -v "$(pwd)/demos:/swarm-composition/demos" -v "$(pwd)/results:/swarm-composition/results" -v "$(pwd)/logs:/swarm-composition/logs" swarm-composition