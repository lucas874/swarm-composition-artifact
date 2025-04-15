#!/bin/bash

sudo docker rmi -f ecoop25_artifact
sudo docker container prune
if [ "$1" == "-a" ]; then
	sudo docker system prune -a
	sudo docker system prune --volumes
fi

sudo docker build -t ecoop25_artifact .
