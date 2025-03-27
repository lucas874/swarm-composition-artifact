DOCKER_IMAGE := "ecoop25_artifact"
USER_DIR := "/ecoop25_artifact"
CRITERION_DATA_DIR := "../machines/machine-check/target/criterion/data/main"
SHORT_CRITERION_DATA_DIR := CRITERION_DATA_DIR + "/'General pattern algorithm 1 vs. exact short run'"
FULL_CRITERION_DATA_DIR := CRITERION_DATA_DIR + "/'General pattern algorithm 1 vs. exact full run'"
BENCHMARK_DIR := "../machines/machine-check/bench_and_results"
SHORT_ACCURACY_RESULT_DIR := BENCHMARK_DIR + "/short_subscription_size_benchmarks/general_pattern"
FULL_ACCURACY_RESULT_DIR := BENCHMARK_DIR + "/subscription_size_benchmarks/general_pattern"

docker:
    docker build -t {{DOCKER_IMAGE}} .
    docker run -it --rm -v $(pwd):{{USER_DIR}} -w {{USER_DIR}} {{DOCKER_IMAGE}} /bin/bash

# Run all benchmarks in the docker container
@run-benchmarks-short:
    date
    echo "Running short version of experiments"
    cd machines/machine-check && cargo criterion --offline --output-format quiet --bench composition_benchmark_short 2>err.out
    cd machines/machine-check && cargo test -- --ignored --nocapture short_run_bench_sub_sizes_general 2>err.out
    just process-results-short
    date

@run-benchmarks:
    echo "Running full version of experiments"
    cd machines/machine-check && cargo criterion --offline --output-format quiet --bench composition_benchmark_full 2>err.out
    cd machines/machine-check && cargo test -- --ignored --nocapture full_run_bench_sub_sizes_general 2>err.out
    just process-results

process-results-short:
    #! /bin/bash
    cd process_results
    python3 process_results.py -p {{SHORT_CRITERION_DATA_DIR}} -a {{SHORT_ACCURACY_RESULT_DIR}} --short

process-results:
    #! /bin/bash
    cd process_results
    python3 process_results.py -p {{FULL_CRITERION_DATA_DIR}} -a {{FULL_ACCURACY_RESULT_DIR}}