DOCKER_IMAGE:="ecoop25_artifact"
USER_DIR:="/ecoop25_artifact"

docker:
    docker build -t {{DOCKER_IMAGE}} .
    docker run -it --rm -v $(pwd):{{USER_DIR}} -w {{USER_DIR}} {{DOCKER_IMAGE}} /bin/bash

# Run all benchmarks in the docker container
@run-benchmarks-short:
    echo "Running short version of experiments"
    #cd machines/machine-check && cargo criterion --offline --output-format quiet --bench composition_benchmark_short 2>err.out
    #cd machines/machine-check && cargo test -- --ignored --nocapture short_run_bench_sub_sizes_general 2>err.out
    just save-figures

save-figure-1:
    #! /bin/bash
    cd process_results
    python3 process_results.py -t ../machines/machine-check/target/criterion/data -s ../machines/machine-check/bench_and_results/short_subscription_size_benchmarks/general_pattern

@save-figures:
    just save-figure-1