# Artifact Submission
Title of the submitted paper: Compositional Design, Implementation, and Verification of Swarms

Our paper presents theory and techniques for the compositional specification and verification of swarm protocols, and for the composition of swarms.
This artifact comprises a Docker image containing:
* our custom extension of the Actyx toolkit supporting the theory presented in the paper,
* scripts to reproduce the experimental results presented in the paper,
* and several example swarms implemented using our tool. The swarms can be executed and their source code can be edited.

## Content

The artifact package (`ecoop25-artifact.tar.gz`) includes:
* `ecoop25_artifact_docker_image.tar.gz`: a Docker image saved as a gzipped tar file. The image includes the following:
    * `machine-runner/`: A TypeScript library offering a DSL for programming machine implementations, facilities to automatically adapt such machines to different swarms as described in the paper, and to run them using the Actyx middleware.
    * `machine-check/`: A Rust library for statically verifying the well-formedness of swarm protocols (expressed as TypeScript data types) and for statically verifying whether a machine implementation (written using `machine-runner`) conforms to a desired projection of a swarm protocol. This directory also includes the benchmark suite used to perform the experiments.
    * `scripts/`: Contains scripts to run our experiments and demos.
    * `process_results/`: Contains scripts used to process the experimental results and generate CSVs and plots.
    * `demos/`: Contains example implementations of a number of swarms, including examples from the paper.
    * `logs/`: Contains log files generated while running the experiments and demos.
* The same files found in the image and a `Dockerfile`. These are included so that the image can be rebuilt to allow customisation of the `machine-check` and `machine-runner` libraries.
* Script for creating and running a container from our image:
    * `run.sh`: Starts a simple REPL that offers commands to easily run our experiments and demos.
    * `run_shell.sh`: Offers the same functionality as `run.sh`, but from a standard bash shell.
    * `run_no_volume.sh`: The same as `run_shell.sh` except that no volumes from the host are mounted.
* `README.md`: This document.

## Getting the Artifact
To artifact is freely available at Zenodo following [this link](https://zenodo.org/records/15223873?preview=1&token=eyJhbGciOiJIUzUxMiJ9.eyJpZCI6ImZjY2UyYTliLWFlMmEtNDdmNi1hNzU3LWE4ODNhNGQ4NWVkYyIsImRhdGEiOnt9LCJyYW5kb20iOiI3MTIyNWQ2OGFmZjIyMmU3YmVjYzc5NGI5Yjc2OGQzZSJ9.8cdbVWxttB6iCsvKCClUxb2DbJdb1WePAyx7PB7dOS_l6WZWZHAwaOdYp7yzRCZtx6ISY9vDU27Hw-cTCpZHBQ). In addition, the artifact is also available at ...

## Quick-start Guide (kick-the-tires)
The following guide assumes a POSIX shell (e.g., bash, zsh). For instructions on how to run the artifact using PowerShell, please go to section [Running the Artifact with Powershell](#running-the-artifact-with-powershell).

To download, please follow the steps listed above in [Getting the artifact](#getting-the-artifact). Once downloaded, please extract the archive, e.g. by running
```bash
tar -xzf ecoop25-artifact.tar.gz
```

Extracting the archive yields the directory `ecoop25-artifact/`. Please move to this directory by running:
```bash
cd ecoop25-artifact
```

From the `ecoop25-artifact/` directory, to load the image and start a container from it please run:
```bash
docker load -i ecoop25_artifact_docker_image.tar.gz
```
This will decompress and load the image on your system.
The output should like similar (TODO: insert updated when all done with image) to the following:
```bash
.../ecoop25-artifact$ docker load -i ecoop25_artifact_docker_image.tar.gz
3abdd8a5e7a8: Loading layer [==================================================>]  80.61MB/80.61MB
bfcb79809e7a: Loading layer [==================================================>]    493MB/493MB
...
c22014a14040: Loading layer [==================================================>]   5.12kB/5.12kB
Loaded image: ecoop25_artifact:latest
```

Depending on your Docker system configuration, you may have preface each Docker command with `sudo`. I.e., if you get an output like:

```bash
.../ecoop25-artifact$ permission denied while trying to connect to the Docker daemon socket ...
```
please instead use:

```bash
sudo docker load -i ecoop25_artifact_docker_image.tar.gz
```

Once the image has been loaded, please run
```bash
bash run.sh
```
After running the command, you should see a message similar to the following:

```bash
.../ecoop25-artifact$ bash run.sh
Available commands:
  1 - kick-the-tires
  2 - Run experiments
  3 - Run warehouse demo
  4 - Run warehouse || factory demo
  5 - Run warehouse || factory || quality
  6 - Run warehouse without branch tracking demo
  help - Show this help message
  exit - Exit the REPL

>
```

Now, please press `1` followed by `Enter` to run the kick-the-tires script. This will run:
1. A shortened version of the accuracy experiment described in the paper.
2. A shortened version of the performance experiment described in the paper.
3. Execute a swarm implementing the Warehouse || Factory protocol, which is given as an example the paper.

The experiments take about 2-3 minutes to run. The demo running after the experiments will not exit on its own -- once the demo has finished the user is instructed to close the window running the demo.

**NOTE:** When running the Warehouse || Factory demo **the terminal window is split in four** this is the normal and expected behavior. When the demo is over, the user is prompted to press `CTRL+C` to exit the demo. The demo does not close automatically, so the output generated by running the swarms can be inspected. When the demo has finished running the output will look like to the following:
```bash
...                                                    | ...
Robot. State is: ...                                   │ Forklift. State is: ...
Robot reached its final state. Press CTRL + C to exit. │ Forklift reached its final state. Press CTRL + C to exit.
───────────────────────────────────────────────────────┼───────────────────────────────────────────────────────────────
...                                                    │ ...
Robot. State is: ...                                   │ Transporter. State is: ...
Door reached its final state. Press CTRL+ C to exit.   │ Transporter reached its final state. Press CTRL + C to exit.
```


When the kick-the-tires script has terminated, the output should look similar to the snippet below:

```bash
...
> 1
Starting the kick-the-tires script. It may take a minute to start.
[1/3] Shortened accuracy experiment: 0:00:22 [==========================================================================================================================>] 100%
[2/3] Shortened performance experiment: 0:01:42 [=======================================================================================================================>] 100%
Starting warehouse demo. It may take a minute to start.
[exited]
[3/3] Warehouse || Factory demo
kick-the-tires everything is OK. Results are written to /ecoop25_artifact/results/results_short_run.
>
```

The experiments generate the files `accuracy_results.csv`,  `performance_results.csv`, and `out.pdf`. They are all located in `ecoop25_artifact/results/results_short_run` on the host machine running the container. The shortened experiments use a reduced input set. In `out.pdf` the results in the CSVs are plotted. The plots should correspond *roughly* in shape to Figure X and Figure Y from the paper.

If the message:
```
ERROR. Please send entire contents of /ecoop25_artifact/logs/
```
appears after running the kick-the-tires script, pleas send the indicated directory, `ecoop25_artifact/logs/` to luccl@dtu.dk. The directory is accessible from the host machine running the container.

## Reproducing the Experimental Results

To reproduce the experiments presented in the paper please `cd` to the directory extracted from the archive package, then run:
```bash
bash run.sh
```

After running the command, you should see a message similar to the following:

```bash
.../ecoop25-artifact$ bash run.sh
Available commands:
  1 - kick-the-tires
  2 - Run experiments
  3 - Run warehouse demo
  4 - Run warehouse || factory demo
  5 - Run warehouse || factory || quality
  6 - Run warehouse without branch tracking demo
  help - Show this help message
  exit - Exit the REPL

>
```
Now, please select option 2. That is press `2` followed by `Enter`. In an example run, the following output could be seen on the screen some seconds after starting the script.

```bash
> 2
Starting the experiments. It may take a minute to start.
[1/2] Accuracy experiment: 0:00:02 [=============>                                                                                                             ]   7%

```

When the experiments are done the output should look similar to:
```bash
...
> 1
Starting the experiments. It may take a minute to start.
[1/2] Accuracy experiment: 0:xx:xx [==========================================================================================================================>] 100%
[2/2] Performance experiment: 0:xx:xx [=======================================================================================================================>] 100%
Experiments done. Everything is OK. Results written to /ecoop25_artifact/results/results_full_run.
>
```

The experiments generate the files `accuracy_results.csv`,  `performance_results.csv`, and `out.pdf`. They are all located in `ecoop25_artifact/results/results_full_run/` on the host machine running the container. In `out.pdf` the results in the CSVs are plotted. The line chart in `out.pdf` comparing the execution times of the Exact algorithm and Algorithm 1 should show the same relationship between the execution times of the Exact algorithm and Algorithm 1 as shown in Figure X in the paper. The absolute values of the execution times, however, may differ from the ones reported in the paper. The boxplot shown in `out.pdf` should match exactly the plot shown in Figure Y of the paper.

The performance experiments described in the paper reported, for each sample, the average of 50 repetitions after 3 seconds of warm-up.
The experiment took more than a day to run, we reduced the number of repetitions to 10. That is, the experimental setup in the image repeats each sample 10 times after 3 seconds of warm-up.
This can be set back to 50 by changing line 75 of `ecoop25-artifact/machines/machine-check/benches/composition_benchmark_full.rs` from
```rust
group.sample_size(10);
```
to
```rust
group.sample_size(50);
```
For the changes to take effect one has to rebuild the image. Please refer to the section for instructions on how to do this.

If the message:
```
ERROR. Please send entire contents of /ecoop25_artifact/logs/
```
appears after running the kick-the-tires script, pleas send the indicated directory, `ecoop25_artifact/logs/` to luccl@dtu.dk. The directory is accessible from the host machine running the container.


## Running and Editing Example Swarms
The script `run.sh` offers four different demos each running an example swarm. To run these select option `3, 4, 5`, or `6` in the REPL.

The Warehouse || Factory demo, for example, consists of machines implementing the projections shown in Figure 5 of the paper and are obtained using the approach presented in Section 6 in the paper.
The source code of the machines in the demo is found in `ecoop25_artifact/demos/warehouse-factory-demo/src/`. The implementation of the machines can be altered and the effect of the changes can be observed without restarting the container, but simply by rerunning the demo.

The machine implementing the forklift role for instance, is implemented for the Warehouse protocol and then automatically adapted to be as outlined in Example 25 in the paper.
The other machines were similarly implemented for their original protocol and adapted to become correct implementation of the composed swarm protocol.

The well-formedness of the subscription used for the composed swarm is generated and checked in the file `ecoop25_artifact/demos/warehouse-factory-demo/src/protocol.ts`.
To make the well-formedness fail and see the results of this, outcomment line 69 in `protocol.ts`, which changes the subscription of the forklift role to just consist of the single event type *pos*.
By rerunning the Warehouse || Factory demo (by running option 4 in the REPL), we get the following error:

```bash
Error: subsequently active role FL does not subscribe to events in transition (0 || 0)--[request@T<partReq>]-->(1 || 1), role FL does not subscribe to event types closingTime, partReq in branching transitions at state 0 || 0, but is involved after transition (0 || 0)--[request@T<partReq>]-->(1 || 1)
```

Indicating that both causal-consistency and determinacy is violated if we change the subscription of forklift to only contain *pos*.

TODO: Add more context do not just refer to causal-consistency... Also suggest other ways to make it fail and things that do not make it fail, but just changes the behavior of the swarm, e.g. changing reaction code.

## Alternative Ways of Running the Artifact
TODO: the idea is this, you can also run the script without mounting a volume and you can run the script mounting a volume and starting a shell in the container. For inspecting the filesystem and running scripts in another way than through the REPL.

## Running the Artifact with PowerShell
TODO. Try out on windows and possibly add scripts for setting things up on windows.

## Altering and Recompiling the Libraries

The `machine-check` and the `machine-runner` libraries are installed in the image, but their source code can also be found in the `machines/` directory included in the artifact package.
To alter the source code of the libraries please make your edits to the source code found in the `machines/` directory and run the command:

```bash docker build -t ecoop25_artifact``` from the `ecoop25-artifact` directory to make the changes take effect. This command rebuilds the Docker image and recompiles the code found in `machines` while doing so.