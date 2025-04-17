#!/usr/bin/env bash

git clone --recurse-submodules git@github.com:lucas874/ecoop25-artifact.git
cd ecoop25-artifact
#https://stackoverflow.com/questions/4822321/remove-all-git-files-from-a-directory
( find . -type d -name ".git" \
  && find . -name ".git" \
  && find . -name ".github" \
  && find . -name ".gitignore" \
  && find . -name ".gitmodules" ) | xargs rm -rf
sudo docker rmi -f ecoop25_artifact
sudo docker build -t ecoop25_artifact .
sudo docker save ecoop25_artifact:latest | gzip > ecoop25_artifact_docker_image.tar.gz
cd ..
tar -czvf ecoop25-artifact.tar.gz ecoop25-artifact
rm -rf ecoop25-artifact
sudo docker rmi -f ecoop25_artifact
