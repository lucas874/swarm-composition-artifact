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
* `scripts/` contains various scripts used to reproduce results and run demos. Stored in the image.
    - `run-benchmarks.sh` runs the experiments reported in the paper and generates plots corresponding to Figure 7 and Figure 8
    - `kick-the-tires.sh` runs a shortened version of the experiments and generates corresponding plots and runs the Warehouse || Factory implemented as described in the article.

This repository should not be submitted. Only a built Docker image and the description is to be submitted.

#### Questions:
* Getting things out of container somewhat awkward but alternative, mounting on some directory, is not very good either. Makes assumptions on host and more files etc.
    - right now you have to run  ```docker ps``` to get the container id and then
    - run ```docker cp <container id>:/ecoop25_artifact/process_results/results/ results``` to copy the results from the container to the host.
    - or the oneline ```sudo docker cp $(sudo docker ps --filter "ancestor=ecoop25_artifact" --format "{{.ID}}"):/ecoop25_artifact/<file> .```
* Changing and editing example, ideas? Reusable badge. Also to claim the reusable badge artifacts have to be "very carefully documented".
* Functional and reusable badges. What type of documentation is requested, comments in code, readmes, good pdf, docs? Readmes awkward given that artifact is a container? What exactly is "appropriate evidence of verification and validation"? "... found to be documented, consistent, complete, exercisable, and include appropriate evidence of verification and validation."
* Readmes are awkward given the format of the artifact. So where to give instructions? In the submission template they say in the appendix of the artifact description.
* Running the demo. Awkward state names and when to exit? Right now a prompt telling user to press Ctrl + C.
* Generally awkard to run extended machines -- no knowledge of statenames and weird casting. Consider making a 'has' function. Similar to current is. state.has(arg) true is when arg enables all the commands enabled in state?
* `run-benchmarks` runs 10 repetitions of each sample. This takes ~8 hours in total on the machine it was tested on. The experiments in paper used 50 repetitions. Is this ok?
* Licenses
* Tested platforms.
* Size of artifact when running, size of image, size of compressed image? Others have done it with the compressed image. The one actually downloaded. Yes also the one we give the md5sum for.
* Storing scripts in home folder of image as xyz.sh or installing them as /usr/local/bin/xyz like now?

#### TODO:
* Remove date command invocation from scripts. DONE
* Output where results are stored in scripts. DONE
* LOG things from demos as well
* Remember to check -- if everything ok then ok otherwise send log file to us blabla
* TEst if everythin works with redirecting stderr to log file so like make rust code not work see if stack trace logged etc.
* Report to same log everywhere? DONE. Except for demos should be separate...
* You may assume bash. Try with mounting. May assume that we can hand in a readme and the artifact itself.
* add more logging so that we can se how/if something goes wrong. look at tracing.
* Pipe to pv instead of dev null. Log everything basically, building and running. Looking is for our sake.
* DONE. Using cargo build --release -all-targets Make build time shorter possibly, when running kick-the-tires? Building more things in dockerfile what does criterion run and what does npm run build build?
	Say this make take a minute...
* Reusable show how to uncomment something to make it fail or not being a proper implementation. And how to implement something.
* Mount things, have a look at https://archive.softwareheritage.org/browse/origin/directory/?origin_url=https://github.com/jolie/lemma2jolie build script.
* Clearer output: Say everything ok or something went wrong please send logfile to us. Both log and long experiment
* Consider not using cargo test for subscription size things. THINK it's fine. Just redirect and monitor as now.
* Write a proper readme. Explaining things like how to change examples etc.
* Check that everything with machines went ok. e.g. by redirecting stderr of machines to some file and then checking if empty or nonexisting.
* checkmarks etc.
* Remove progress prints in rust code