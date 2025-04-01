# ECOOP 25 Artifact - Supplementary to *Compositional Design, Implementation, and Verification of Swarms*
## This repository contains the means to build the artifact and *not* the artifact itself. A repository for storing the work in progress for the artifact.

### Files:
* `artifact_description/` contains the artifact description. It uses the latex template listed [here](https://drops.dagstuhl.de/entities/journal/DARTS#author).
* `machines/` is a clone of [machines](https://github.com/lucas874/machines/tree/prepare_benchmarks_for_art). Stored in the image.
* `process_results/` contains scripts that turn the benchmarks results into csvs and pdfs. Stored in the image.
* `Dockerfile` is used to build the image.
    - Building the image: ```sudo docker build -t ecoop25_artifact .``` (from the root of this repo)
    - Running the image: ```sudo docker run -it ecoop25_artifact```
    - More commands in found `some_commands.txt`
* `run-benchmarks` and `kick-the-tires` are installed in the image by Dockerfile

This repository should not be submitted. Only a built Docker image and the description is to be submitted.
