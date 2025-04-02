# ECOOP 25 Artifact - Supplementary to *Compositional Design, Implementation, and Verification of Swarms*
## This repository contains the means to build the artifact and *not* the artifact itself. A repository for storing the work in progress for the artifact.

Clone this repo using `git clone --recurse-submodules ...` to get all dependencies.

### Files:
* `artifact_description/` contains the artifact description. It uses the latex template listed [here](https://drops.dagstuhl.de/entities/journal/DARTS#author).
* `machines/` is a clone of [machines](https://github.com/lucas874/machines/tree/prepare_benchmarks_for_art). Stored in the image.
* `process_results/` contains scripts that turn the benchmarks results into csvs and pdfs. Stored in the image.
* `Dockerfile` is used to build the image.
    - Building the image: ```sudo docker build -t ecoop25_artifact .``` (from the root of this repo)
    - Running the image: ```sudo docker run -it ecoop25_artifact```
    - More commands found in `some_commands.txt`
* The scripts `run-benchmarks` and `kick-the-tires` are installed in the image by `Dockerfile`.
    - `run-benchmarks` runs the experiments reported in the paper and generates plots corresponding to Figure 7 and Figure 8
    - `kick-the-tires` runs a shortened version of the experiments and generates corresponding plots and runs the Warehouse || Factory implemented as described in the article.

This repository should not be submitted. Only a built Docker image and the description is to be submitted.

TODO:
* remove date command invocation from scripts.

Questions:
* Storing scripts in home folder of image as xyz.sh or installing them as /usr/local/bin/xyz like now?
* Getting things out of container somewhat awkward but alternative, mounting on some directory, is not very good either. Makes assumptions on host and more files etc.
    - right now you have to run  ```docker ps``` to get the container id and then
    - run ```docker cp <container id>:/ecoop25_artifact/process_results/results/ results``` to copy the results from the container to the host.
* Changing and editing example, ideas? Reusable badge. Also to claim the reusable badge artifacts have to be "very carefully documented".
* Running the demo. Awkward state names and when to exit? Right now a prompt telling user to press Ctrl + C.
* Generally awkard to run extended machines -- no knowledge of statenames and weird casting. Consider making a 'has' function. Similar to current is. state.has(arg) true is when arg enables all the commands enabled in state?
* `run-benchmarks` runs 10 repetitions of each sample. This takes ~8 hours in total on the machine it was tested on. The experiments in paper used 50 repetitions. Is this ok?
* Licenses
* Functional and reusable badges. What type of documentation is requested, comments in code, readmes, good pdf, docs? Readmes awkward given that artifact is a container? What exactly is "appropriate evidence of verification and validation"?
* Tested platforms.
* Size of artifact when running, size of image, size of compressed image? Others have done it with the compressed image. The one actually downloaded.
* Restructuring directories