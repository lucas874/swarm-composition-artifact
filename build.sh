#!/bin/bash

sudo docker rmi -f ecoop25_artifact
sudo docker build -t ecoop25_artifact .
