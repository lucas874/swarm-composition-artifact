#!/usr/bin/env bash

docker rmi -f swarm-composition
docker build -t swarm-composition .