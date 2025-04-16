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
    * `machine-check/`: A Rust library for statically verifying the well-formedness of swarm protocols (expressed as TypeScript data types) and for statically verifying whether a machine implementation (written using `machine-runner`) conforms to a desired projection of a swarm protocol.
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

## Getting the artifact
To artifact is freely available at Zenodo following [this link](https://zenodo.org/records/15223873?preview=1&token=eyJhbGciOiJIUzUxMiJ9.eyJpZCI6ImZjY2UyYTliLWFlMmEtNDdmNi1hNzU3LWE4ODNhNGQ4NWVkYyIsImRhdGEiOnt9LCJyYW5kb20iOiI3MTIyNWQ2OGFmZjIyMmU3YmVjYzc5NGI5Yjc2OGQzZSJ9.8cdbVWxttB6iCsvKCClUxb2DbJdb1WePAyx7PB7dOS_l6WZWZHAwaOdYp7yzRCZtx6ISY9vDU27Hw-cTCpZHBQ). In addition, the artifact is also available at ...

## Quick-start guide (kick-the-tires)
The following guide assumes a POSIX shell (e.g., bash, zsh). For instructions on how to run the artifact using PowerShell, please go to section [Running the artifact with Powershell](#running-the-artifact-with-powershell).

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
.../ecoop25-artifact$ sudo docker load -i ecoop25_artifact_docker_image.tar.gz
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
This will , you should see a message similar to the following:

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
3. Execute a swarm implementing the

**NOTE:** When running the Warehouse || Factory demo **the terminal window is split in four** this is the normal and expected behavior. When the demo is over the user is prompted to press `CTRL+C` to exit the demo. The demo does not close automatically, so the output generated by running the swarms can be inspected. This will, look some

When the kick the tires script has terminated, the output should look similar to the snippet below.

```bash
> 1
[1/3] Shortened accuracy experiment: 0:00:20 [==========================================================================================================================>] 100%
[2/3] Shortened performance experiment: 0:01:37 [=======================================================================================================================>] 100%
Starting warehouse demo. It may take a minute to start.
[exited]
[3/3] Warehouse || Factory demo
kick-the-tires everything is OK. Results are written to /ecoop25_artifact/results/results_short_run.
>
```



## Reproducing the experimental results

## Running and editing example swarms

## Alternative ways of running the artifact

## Running the artifact with PowerShell

```bash
...
Robot reached its final state. Press CTRL + C to exit. │ Forklift reached its final state. Press CTRL + C to exit.
                                                       │
───────────────────────────────────────────────────────┼───────────────────────────────────────────────────────────────
...                                                    │
Door reached its final state. Press CTRL+ C to exit.   │ Transporter reached its final state. Press CTRL + C to exit.
                                                       |
```