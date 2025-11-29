FROM ubuntu:24.04
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y build-essential cmake protobuf-compiler curl gzip zip nano python3-pip python3.12-venv pv tmux locales && \
    apt-get clean

# Use bash for the shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Set up some environment variables
ENV DIR=/swarm-composition
ENV MACHINE_CHECK_DIR="${DIR}/machine-check"
ENV MACHINE_RUNNER_DIR="${DIR}/machine-runner"
ENV CRITERION_DATA_DIR="${MACHINE_CHECK_DIR}/target/criterion/data/main"
ENV SHORT_CRITERION_DATA_DIR="${CRITERION_DATA_DIR}/General-pattern-algorithm1-vs.-exact-short-run"
ENV FULL_CRITERION_DATA_DIR="${CRITERION_DATA_DIR}/General-pattern-algorithm1-vs.-exact-full-run"
ENV BENCHMARK_DIR="${MACHINE_CHECK_DIR}/bench_and_results"
ENV BENCHMARK_DIR_GENERAL="${BENCHMARK_DIR}/benchmarks/general_pattern"
ENV SHORT_ACCURACY_RESULT_DIR="${BENCHMARK_DIR}/short_subscription_size_benchmarks/general_pattern"
ENV FULL_ACCURACY_RESULT_DIR="${BENCHMARK_DIR}/subscription_size_benchmarks/general_pattern"
ENV SHORT_COMPOSITIONAL_VS_ECOOP23_DIR="${BENCHMARK_DIR}/short_subscription_size_benchmarks/ecoop23-compositional-comparison"
ENV FULL_COMPOSITIONAL_VS_ECOOP23_DIR="${BENCHMARK_DIR}/subscription_size_benchmarks/ecoop23-compositional-comparison/general_pattern"
ENV SHORT_COMPOSITIONAL_VS_ECOOP23_CSV="short_run_compositional_vs_ecoop23.csv"
ENV FULL_COMPOSITIONAL_VS_ECOOP23_CSV="compositional_vs_ecoop23.csv"
ENV DEMO_DIR="${DIR}/demos"
ENV PROCESS_RES_DIR="${DIR}/process_results"
ENV RES_DIR="${DIR}/results"
ENV RES_FULL_DIR="${RES_DIR}/results_full_run"
ENV RES_SHORT_DIR="${RES_DIR}/results_short_run"
ENV LOG_DIR="${DIR}/logs"
ENV RLOG="${LOG_DIR}/robot.log"
ENV FLOG="${LOG_DIR}/forklift.log"
ENV TLOG="${LOG_DIR}/transporter.log"
ENV DLOG="${LOG_DIR}/door.log"

# Set locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install cargo etc.
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install cargo-criterion
RUN cargo install wasm-pack

# Install ax
RUN cargo install ax

# Set up python virual environment
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv ${VIRTUAL_ENV}
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
COPY process_results/requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Set up nvm, nodejs and npm
ARG NODE_VERSION="20.19.0"
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh -sSf | bash
ENV NVM_DIR=/root/.nvm
RUN source ${NVM_DIR}/nvm.sh && nvm install ${NODE_VERSION}
RUN source ${NVM_DIR}/nvm.sh && npm install typescript -g
ENV PATH="${NVM_DIR}/versions/node/${NODE_VERSION}/bin:${PATH}"

# Set up working directory
WORKDIR ${DIR}
COPY machine-check machine-check
RUN cd machine-check && rm -rf bench_and_results && unzip bench_and_results.zip && rm bench_and_results.zip
COPY machine-runner machine-runner
COPY demos demos
COPY process_results process_results

RUN cd machine-check && cargo build --all-targets
RUN cd machine-check && cargo build --release --all-targets

RUN mkdir logs
RUN mkdir results

RUN source ${NVM_DIR}/nvm.sh && cd machine-check && npm install
RUN source ${NVM_DIR}/nvm.sh && cd machine-check && npm run build
RUN source ${NVM_DIR}/nvm.sh && cd machine-runner && npm install
RUN source ${NVM_DIR}/nvm.sh && cd machine-runner && npm run build

# run npm i in every demo -- even though we want users to mount demos. That way it should still work if not mounted.
RUN source ${NVM_DIR}/nvm.sh && cd demos/warehouse-factory && npm install
RUN source ${NVM_DIR}/nvm.sh && cd demos/car-factory && npm install

# Should they be in workdir instead so that they can easily be reviewed/inspected? Now they are in workdir
COPY scripts scripts
RUN chmod +x scripts/warehouse-demo.sh
RUN chmod +x scripts/warehouse-factory-demo.sh
RUN chmod +x scripts/warehouse-factory-demo-kick.sh
RUN chmod +x scripts/warehouse-factory-quality-demo.sh
RUN chmod +x scripts/car-factory-demo.sh
RUN chmod +x scripts/kick-the-tires.sh
RUN chmod +x scripts/run-benchmarks.sh
RUN chmod +x scripts/repl.sh
