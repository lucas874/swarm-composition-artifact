FROM ubuntu:24.04
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y curl gzip nano python3-pip python3.12-venv just tmux && \
    apt-get clean
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install cargo etc.
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install cargo-criterion

# Set up python virual environment
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv ${VIRTUAL_ENV}
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
COPY process_results/requirements.txt .
RUN pip3 install -r requirements.txt

COPY run-benchmarks-short /bin
RUN chmod +x /bin/run-benchmarks-short

# copy actyx to /bin
COPY ax /bin

# Set up some environment variables
ENV DIR=/ecoop25_artifact
ENV CRITERION_DATA_DIR="${DIR}/machines/machine-check/target/criterion/data/main"
ENV SHORT_CRITERION_DATA_DIR="${CRITERION_DATA_DIR}/General-pattern-algorithm1-vs.-exact-short-run"
ENV FULL_CRITERION_DATA_DIR="${CRITERION_DATA_DIR}/General-pattern-algorithm1-vs.-exact-full-run"
ENV BENCHMARK_DIR="${DIR}/machines/machine-check/bench_and_results"
ENV SHORT_ACCURACY_RESULT_DIR="${BENCHMARK_DIR}/short_subscription_size_benchmarks/general_pattern"
ENV FULL_ACCURACY_RESULT_DIR="${BENCHMARK_DIR}/subscription_size_benchmarks/general_pattern"

# Set up working directory
COPY machines ${DIR}/machines
COPY process_results ${DIR}/process_results
WORKDIR ${DIR}