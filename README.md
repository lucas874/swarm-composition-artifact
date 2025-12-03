# Artifact Submission
Title of the submitted paper: Compositional Design, Implementation, and Verification of Swarms

ECOOP submission number for the paper:

Our paper presents theory and techniques for the compositional specification, implementation and verification of swarm protocols, and for the composition of swarms.
This artifact comprises a Docker image containing:
* our custom open-source extension of the Actyx toolkit supporting the theory presented in the paper,
* scripts to reproduce the experimental results presented in the paper,
* and several example swarms implemented using our tool. The swarms can be executed and their source code can be edited.

## Quick-start guide (kick-the-tires phase)
The following guide assumes a POSIX shell (e.g., bash, zsh). If you use Windows, please use PowerShell to follow this guide. When POSIX shell and PowerShell commands differ this is clearly indicated.

To build the artifact please run:
```bash
bash build.sh
```
The output should like similar to the following:
```bash
.../swarm-composition-artifact$ bash build.sh
bash build.sh
Error response from daemon: No such image: swarm-composition:latest
[+] Building 206.7s (43/43) FINISHED                                                                                                                                            docker:default
 => [internal] load build definition from Dockerfile                                                                                                                                      0.0s
 => => transferring dockerfile: 3.82kB                                                                                                                                                    0.0s
 => [internal] load metadata for docker.io/library/ubuntu:24.04                                                                                                                           0.9s
 => [internal] load .dockerignore                                                                                                                                                         0.0s
 => => transferring context: 2B
 => [ 1/38] FROM docker.io/library/ubuntu:24.04@sha256:c35e29c9450151419d9448b0fd75374fec4fff364a27f176fb458d472dfc9e54                                                                   0.0s

 ...
 => [38/38] RUN chmod +x scripts/repl.sh                                                                                                                                                  0.3s
 => exporting to image                                                                                                                                                                    6.7s
 => => exporting layers                                                                                                                                                                   6.6s
 => => writing image sha256:3ad7ac0026081e2e857bcd63ca4f366f0b52bf24c85422faa6e5a67333175cf3                                                                                              0.0s
 => => naming to docker.io/library/swarm-composition
```

Depending on your Docker system configuration, you may have preface each Docker command with `sudo`. I.e., if you get an output like:

```bash
.../swarm-composition-artifact$ permission denied while trying to connect to the Docker daemon socket ...
```
please instead use:

```bash
sudo bash build.sh
```

Once the image has been built, please run:
* POSIX shell: `bash run.sh`. Similar to the previous command, this command may have to be prefaced with sudo.
* PowerShell: `.\run.ps1`

After running the command, you should see a message similar to the following:

```bash
.../swarm-composition-artifact$ bash run.sh
Available commands:
  1 - kick-the-tires
  2 - Run experiments
  3 - Run warehouse demo
  4 - Run warehouse || factory demo
  5 - Run warehouse || factory || quality
  6 - Run car factory demo (composition of 7 protocols instantiated with 25 machines)
  help - Show this help message
  exit - Exit

>
```

Now, please press `1` followed by `Enter` to run the kick-the-tires script. This will run:
1. A shortened version of the accuracy experiment described in the paper.
2. A shortened version of the performance experiment described in the paper.
3. A shortened version of the experiments comparing sizes subscriptions generated using Definition 10 (p. 10 in the paper) and Algorithm 1 (p. 11 in the paper) with sizes of subscriptions
generated using the definition from the paper [_Behavioural Types for Local-First Software_](https://drops.dagstuhl.de/storage/00lipics/lipics-vol263-ecoop2023/LIPIcs.ECOOP.2023.15/LIPIcs.ECOOP.2023.15.pdf).
4. Execute an example swarm implementing the Warehouse || Factory protocol, which is given as an example the paper.

The experiments take about 2-3 minutes to run. The demonstration running after the experiments will not exit on its own -- once the demonstration has finished the user is instructed to close the window running the demo.

**NOTE:** When running the Warehouse || Factory demo **the terminal window is split in four** this is the normal and expected behavior. When the demonstration is over, the user is prompted to press `CTRL+C` to exit the demo. The demo does not close automatically, so the output generated by running the swarms can be inspected. When the demo has finished running the output will look like to the following:
```bash
...                                           | ...
                                              |
Transport - State: 0. Payload: {}             | Robot - State: 1. Payload: {}
Final state reached, press CTRL + C to quit.  │ Final state reached, press CTRL + C to quit.
──────────────────────────────────────────────┼───────────────────────────────────────────────────────────────
...                                           │ ...
Door - State: 0. Payload: {}                  │ Forklift - State: 0. Payload: {}
Final state reached, press CTRL + C to quit.  │ Final state reached, press CTRL + C to quit.
```

Pressing the CTRL+C four times will close these windows. Pressing CTRL + C once more will close a window running the Actyx middleware (needed to facilitate communication between the machines in the demo). Once all the windows have been closed, the kick-the-tires script is done and the output should look similar to the snippet below:

```bash
...
> 1
Starting the kick-the-tires script. It may take a minute to start.
[1/4] Shortened accuracy experiment: 0:00:22 [===============================================>] 100%
[2/4] Shortened compositional vs. ECOOP23 experiment: 0:00:00 [==============================>] 100%
[2/4] Shortened performance experiment: 0:01:42 [============================================>] 100%
Starting warehouse demo. It may take a minute to start.
[exited]
[4/4] Warehouse || Factory demo
kick-the-tires everything is OK. Results are written to /swarm-composition-artifact/results/results_short_run.
>
```
By invoking `run.sh` the directories `results/` and `logs/` are created and mounted into the container.
The directories are to contain, respectively, CSVs and plots generated by the experiments and various logging information generated by running the image.
Similar to these two directories, the `demos/` directory included in the artifact package is mounted into the container.
The mounted directories are shared between the container and your host system.
This makes it easy to e.g. inspect the figures generated by the experiment and alter the demo code.
If mounting directories into the container is not an option for you or poses any problems, please
see [Running the artifact without volumes](#running-the-artifact-without-volumes).

The experiments generate the files `accuracy_results.csv`,  `performance_results.csv`, `short_run_compositional_vs_ecoop23.csv`, `figures.pdf`, and compositional_vs_ecoop23.pdf.
They are all located in `results/results_short_run` on the host machine running the container.
The shortened experiments use a reduced input set. In `results.pdf` the results in the CSVs are plotted: `accuracy_results.csv` is summarized with a boxplot and `performance_results.csv` with a line chart. The plots should correspond *roughly* in shape to Figure 13 and Figure 14 from the paper.
The file `compositional_vs_ecoop23.pdf` shows boxplots *roughly* corresponding to Figure 15 from the paper generated using `short_run_compositional_vs_ecoop23.csv`.

If running the script generates the message:
```
ERROR. Please send entire contents of /swarm-composition-artifact/logs/
```

## Overview: What does the artifact comprise?

The artifact repository (`swarm-composition-artifact`) contains:
* `machine-runner/`: A TypeScript library offering a DSL for programming machine implementations, facilities to automatically adapt such machines to different swarms as described in the paper, and to run them using the Actyx middleware.
* `machine-check/`: A Rust library for statically verifying the well-formedness of swarm protocols (expressed as TypeScript data types) and for statically verifying whether a machine implementation (written using `machine-runner`) conforms to a desired projection of a swarm protocol. This directory also includes the benchmark suite used to perform the experiments.
* `scripts/`: Contains scripts to run our experiments and demos. Contains the following scripts:
  * `kick-the-tires.sh`: Runs a shortened version of the experiments and an example swarm.
  * `repl.sh`: Offers a REPL for easily running the scripts in the `scripts/` directory.
  * `run-benchmarks.sh`: Runs the experiments presented in Section 6 in the paper.
  * `warehouse-demo.sh`, `warehouse-factory-demo-kick.sh`, `warehouse-factory-demo.sh`, `warehouse-factory-quality-demo.sh`, and `car-factory-demo.sh`: Starts various example swarms, some of which are presented in the paper as examples.
* `process_results/`: Contains scripts used to process the experimental results and generate CSVs and figures.
* `Dockerfile`: Included so that the image can be built.
* `demos/`, `scripts/`, and `process_results/`: Also found in the image. Included so that the image can be rebuilt.
* `build.sh`: Script for building the image.
* Scripts for creating and running a container from our image:
    * `run.(sh/ps1)`: Starts a simple REPL that offers commands to easily run our experiments and demos.
    * `run_shell.(sh/ps1)`: Offers the same functionality as `run.(sh/ps1)`, but from a standard bash shell.
    * `run_shell_volume.(sh/ps1)`: The same as `run_shell.(sh/ps1)` except that no volumes from the host are mounted.
* `README.md`: This document.

## Reproducing the Experimental Results (for the "Artifact Evaluated -- Functional" badge)

Two experimental claims are made in the paper (**Section 6**):
1. In the section **Experiments on Compositional Subscription Computation (p. 22)**, we claim that the compositional Algorithm 1 is faster and more scalable than the "exact" algorithm, which suffers from the the exponential blow-up of the composition. These results are plotted in **Figure 13 (p. 22)**.
2. In the section **Experiments on Compositional Subscription Computation (p. 22)**, we claim that the "exact" algorithm yields smaller subscriptions than Algorithm 1.
For our benchmark suite, we found that the "exact" algorithm requires roles to subscribe to about 22.2% of all events in a protocol on average and Algorithm 1 requires roles 29.8% of all events on average. These results are plotted in **Figure 14 (p. 22)**.
3. In the section **Experiments on Compositional Subscription Computation (p. 22)**, we claim that the "exact" algorithm and Algorithm 1 yields smaller subscriptions than subscriptions
generated using the definition from the paper [_Behavioural Types for Local-First Software_](https://drops.dagstuhl.de/storage/00lipics/lipics-vol263-ecoop2023/LIPIcs.ECOOP.2023.15/LIPIcs.ECOOP.2023.15.pdf).
For our benchmark suite, we found that the "exact" algorithm and Algorithm 1 requires roles to subscribe to about 22.2% of all events in a protocol on average and Algorithm 1 requires roles 47.6% of all event types on average, while the 'old' definition of well-formedness requires about %70.8.
These results are plotted in **Figure 15 (p. 22)**.

To reproduce the experiments presented in Section 6.1, please `cd` to the directory extracted from the archive package, then run:
```bash
bash run.sh
```
or

```powershell
.\run.ps1
```
After running the command, you should see a message similar to the following:

```bash
.../swarm-composition-artifact$ bash run.sh
Available commands:
  1 - kick-the-tires
  2 - Run experiments
  3 - Run warehouse demo
  4 - Run warehouse || factory demo
  5 - Run warehouse || factory || quality
  6 - Run warehouse without branch tracking demo
  help - Show this help message
  exit - Exit

>
```
Now, please select option 2. That is press `2` followed by `Enter`.
This will run the experiments on compositional subscription generation presented in the paper
using the benchmark suite presented in the subsection **Benchmark Selection (p. 23)**.
The script runs:
1. The accuracy experiments.
2. The performance experiments.

On a system with an Intel Core i7-9700K CPU @ 3.60GHz and 16GiB of RAM running Ubuntu 22.04, the experiments took **about 7.5 hours**
(2.5 for the accuracy experiments and 5 hours for the performance experiments).
The benchmark suite is public and open source. It is included in the image and can also be found in `machines/machine-check/bench_and_results/benchmarks`.

In an example run, the following output could be seen on the screen some seconds after starting the script.

```bash
> 2
Starting the experiments. It may take a minute to start.
[1/3] Accuracy experiment: 0:00:02 [==>                                                     ]   7%

```

When the experiments are done the output should look similar to:
```bash
...
> 1
Starting the experiments. It may take a minute to start.
[1/3] Accuracy experiment: 2:23:21 [=======================================================>] 100%
[2/3] Compositional vs. ECOOP23 experiment: 0:00:21 [======================================>] 100%
[2/3] Performance experiment: 4:54:01 [====================================================>] 100%
Experiments done. Everything is OK. Results written to /swarm-composition-artifact/results/results_full_run.
>
```

The experiments generate the files `accuracy_results.csv`,  `performance_results.csv`, `compositional_vs_ecoop23.csv` and `figure.pdf`. They are all located in `results/results_full_run/` on the host machine running the container.
In `figure.pdf` the results in the CSVs are plotted.
The line chart in `figure.pdf` comparing the execution times of the "exact" algorithm and Algorithm 1 should show the same relationship between the execution times of the two algorithms as shown in **Figure 13 (p. 22)**.
The absolute values of the execution times, however, may differ from the ones reported in the paper.
The leftmost boxplot shown in `figures.pdf` should match exactly the plot shown in **Figure 14 (p. 22)**.
The leftmost boxplot shown in `compositional_vs_ecoop23.pdf` should match exactly the plot shown in **Figure 15 (p. 22)**.

If the message:
```
ERROR. Please send entire contents of /swarm-composition-artifact/logs/
```

### Note on the total running time of the experiments
The performance experiments described in the paper reported, for each sample, the average of 50 repetitions after 3 seconds of warm-up.
The experimental setup used in the paper is an Intel Xeon Gold 622R with 32 GiB of RAM running AlmaLinux 9.5.
With this setup the performance experiments took 25 hours with a maximum memory usage of 1.5 GiB and an average memory usage of 165 MiB.
The accuracy experiments took 4.5 hours with a maximum memory usage of 313 MiB and an average memory usage of 186 MiB.

Due to the total run time of the experiments described in the paper, we have reduced the number of repetitions in the performance experiments to 10.
That is, the experimental setup in the image repeats each sample 10 times after 3 seconds of warm-up.
With this configuration, the total run time of the experiments has been about 7.5 hours Intel Core i7-9700K CPU @ 3.60GHz and 16GiB of RAM running Ubuntu 22.04.

To increase the number of samples to get the same number of repetitions of each sample as used in the paper line 75 of `machines/machine-check/benches/composition_benchmark_full.rs` from:
```rust
group.sample_size(10);
```
to
```rust
group.sample_size(50);
```
For the changes to take effect one has to rebuild the image. Please refer to the section for instructions on how to do this.

## Running and editing example swarms (for the "Artifacts Evaluated -- Reusable")
We envision that the `machine-check` and `machine-runner` libraries be used to design, implement, and verify arbitrary swarms compositionally.
We therefore provide examples that show how swarm implementations can be composed, reused and verified.
We suggest alterations to the example implementations that change the verification results or behavior of the swarm to show the robustness of our libraries.
All the examples are executable and their source code is found in demos/. If the container is started using `run.sh` or `run_shell.sh` this directory is mounted into the cointainer, which means that the source code of the examples can be edited and the effects of the changes can be seen immediately be rerunning the examples, i.e. no need for rebuilding the image or restarting the container.

The script `run.sh` offers four different demos each running an example swarm:
* **The Warehouse demo:**
  * Implements the Warehouse swarm protocol that is depicted in Figure 1 (p. 2) and whose projections are shown in Figure 11 (p. 14).
  * The swarm protocol consists of the three roles Transport, Door, and Forklift.
  * The source code for the machine implementations of the roles is found in `demos/warehouse-demo/src`.
  * Select option `3` in the REPL to run a swarm with one instance each of the Transport, Door, and Forklift implementations.
* **The Warehouse || Factory demo:**
  * Implements the Warehouse || Factory protocol that is depicted in Figure 4 (p. 5) and whose projections are shown in Figure 10 (p. 14).
  * The composed swarm protocol consists of the roles Transport, Door, Forklift, and Robot.
  * The implementations of Transport, Door, Forklift are obtained by automatically adapting the machine implementations from the warehouse demo to become correct for the composition. Similarly, the Robot role is implemented for the Factory protocol (shown in Figure 4, p. 2) and automatically adapted for the composition.
  * The source code for the machine implementations of the roles is found in `demos/warehouse-factory-demo/src`.
  * Select option `4` in the REPL to run a swarm with one instance of each of the roles of the composition.
* **The Warehouse || Factory || Quality demo:**
  * This swarm protocol is not given as an example in the paper.
  * It is a composition of the Warehouse and Factory protocols described above and in the paper with a third *quality control* swarm protocol.
  * The Quality protocol interfaces with Warehouse || Factory on the R role. Besides the role R, it consists of the role QualityControl, that observes the assembly process and assesses the quality of newly built cars.
  * The Quality protocol can be summarized as follows: `(0)--[QualityControl<observing>]-->(1)--[Robot<car>]-->(2)--[QualityControl<report>]-->(3)`.
  * The implementation reuses the Transport, Door, Forklift implementations made for the Warehouse protocol and the Robot implementation made for the factory protocol and automatically adapts these to work for the composition of the three protocols. Similarly, the QualityControl role is implemented for the Quality protocol and automatically adapted to the composition.
  * The source code for the machine implementations of the roles is found in `demos/warehouse-factory-quality-demo/src`.
  * Select option `5` in the REPL to run this demo.
* **The car factory demo:**
  * Demonstrates a composition consisting of seven protocols.
  * Instantiates a swarm with 25 machines.
  * Select option `6` in the REPL to run this demo.

The demos can also be started using the `run_shell.sh` and `run_shell_no_volume.sh`.
Please see [Alternative ways of running the artifact](#alternative-ways-of-running-the-artifact) for instructions on how to do this.

### Example: running and altering the Warehouse || Factory demo

The source code of the machines in the Warhouse || Factory demo is found in `swarm-composition-artifact/demos/warehouse-factory-demo/src/`. The implementation of the machines can be altered and the effect of the changes can be observed without restarting the container, but simply by rerunning the demo.

The well-formedness of the subscription used for the composed swarm is generated and checked in the file `swarm-composition-artifact/demos/warehouse-factory/src/protocol.ts`.
To make the well-formedness fail and see the results of this, remove the comments on line 105 in `protocol.ts` so that:
```typescript
//subsWarehouseFactory[Forklift] = [Events.positionEvent.type]
```
becomes
```typescript
subsWarehouseFactory[Forklift] = [Events.positionEvent.type]
```
which changes the subscription of the forklift role to just consist of the single event type *position*.
By rerunning the Warehouse || Factory demo (by running option 4 in the REPL), we get the following error:

```bash
Error: subsequently active role Forklift does not subscribe to events in transition (initialState || initialState)--[request@Transport<partRequest>]-->(requestedState || requestedState), role Forklift does not subscribe to event types closingTime, partRequest in branching transitions at state initialState || initialState, but is involved after transition (initialState || initialState)--[request@Transport<partRequest>]-->(requestedState || requestedState)
```

indicating that both causal-consistency and determinacy is violated if we change the subscription of forklift to only contain *pos*.

The machine implementing the forklift role is implemented for the Warehouse protocol in `swarm-composition-artifact/demos/warehouse-factory/src/machines/forklift_machine.ts` and then automatically adapted to be as outlined in Example 25 in the paper.
To turn the implementation into an incorrect implementation outcomment for instance line 18:
```typescript
initialState.react([Events.closingTimeEvent], closedState, () => closedState.make())
```
This yields the error:
```bash
Error: missing transition closingTime? in state initialState (from reference state initialState)
```
indicating that, compared to the projection of Warehouse, the implementation lacks a transition from the initial state `initialState` consuming an event of type `closingTime`.

**Note**: When the demo terminates with an error, it should be closed using `CTRL + D`.

### Additionally:
The machine-runner and machine-check libraries are open source. For more information on how to compile the libraries please see [Altering and recompiling the libraries](#altering-and-recompiling-the-libraries)

## Alternative ways of running the artifact

### Starting a container offering a standard Bash shell
A Docker container created from the image mounting a volume and starting a Bash shell in the container can be started by running:
* POSIX shell: `bash run_shell.sh`
* PowerShell: `.\run_shell.ps1`
With this option the scripts can be started from the `scripts/` directory in the container.

### Running the artifact without volumes
A Docker container created from the image that starts a Bash shell in the container, but does not mount a volume can be started by running:
* POSIX shell: `bash run_shell_no_volume.sh`
* PowerShell: `.\run_shell_no_volume.ps1`
With this option the scripts can be started from the `scripts/` directory in the container. Files are not shared between the host machine and the container,
which means that the results generated from the experiments must be copied of the container and that edits to the example swarms made from the host machine only become visible after rebuilding the image.
