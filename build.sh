#!/usr/bin/env bash

docker rmi -f ecoop25_artifact
docker build -t ecoop25_artifact .
