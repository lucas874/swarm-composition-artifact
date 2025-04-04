FROM ubuntu:24.04
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y curl gzip zip nano python3-pip python3.12-venv just tmux && \
    apt-get clean

# Use bash for the shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Set up some environment variables
ENV DIR=/ecoop25_artifact
ENV MACHINE_CHECK_DIR="${DIR}/machine-check"
ENV MACHINE_RUNNER_DIR="${DIR}/machine-runner"
ENV CRITERION_DATA_DIR="${MACHINE_CHECK_DIR}/target/criterion/data/main"
ENV SHORT_CRITERION_DATA_DIR="${CRITERION_DATA_DIR}/General-pattern-algorithm1-vs.-exact-short-run"
ENV FULL_CRITERION_DATA_DIR="${CRITERION_DATA_DIR}/General-pattern-algorithm1-vs.-exact-full-run"
ENV BENCHMARK_DIR="${MACHINE_CHECK_DIR}/bench_and_results"
ENV SHORT_ACCURACY_RESULT_DIR="${BENCHMARK_DIR}/short_subscription_size_benchmarks/general_pattern"
ENV FULL_ACCURACY_RESULT_DIR="${BENCHMARK_DIR}/subscription_size_benchmarks/general_pattern"
ENV DEMO_DIR="${DIR}/demos"

# Install cargo etc.
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install cargo-criterion
RUN cargo install wasm-pack

# Set up python virual environment
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv ${VIRTUAL_ENV}
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
COPY process_results/requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Download ax
RUN curl https://axartifacts.blob.core.windows.net/releases/ax-2.18.1-linux-amd64.tar.gz -sSf > ax-2.18.1-linux-amd64.tar.gz
RUN tar -xvf ax-2.18.1-linux-amd64.tar.gz
RUN mv ax /usr/local/bin
RUN rm ax-2.18.1-linux-amd64.tar.gz

# Set up nvm, nodejs and npm
ARG NODE_VERSION=20
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh -sSf | bash
ENV NVM_DIR=/root/.nvm
RUN source ${NVM_DIR}/nvm.sh && nvm install ${NODE_VERSION}
RUN source ${NVM_DIR}/nvm.sh && npm install typescript -g

# Set up working directory
WORKDIR ${DIR}
COPY machines/machine-check machine-check
RUN cd machine-check && rm -rf bench_and_results && unzip bench_and_results.zip
COPY machines/machine-runner machine-runner

COPY machines/warehouse-demo demos/warehouse-demo
COPY new_package_jsons/warehouse-demo/package.json demos/warehouse-demo/

#COPY machines/warehouse-demo-without-branch-tracking demos/warehouse-demo-without-branch-tracking
#COPY new_package_jsons/warehouse-demo-without-branch-tracking/package.json demos/warehouse-demo-without-branch-tracking/

COPY machines/warehouse-factory-demo demos/warehouse-factory-demo
COPY new_package_jsons/warehouse-factory-demo/package.json demos/warehouse-factory-demo/

COPY machines/warehouse-factory-quality-demo demos/warehouse-factory-quality-demo
COPY new_package_jsons/warehouse-factory-quality-demo/package.json demos/warehouse-factory-quality-demo/

COPY process_results ./process_results

RUN cd machine-check && cargo build --all-targets
RUN cd machine-check && cargo build --release --all-targets

RUN source ${NVM_DIR}/nvm.sh && cd machine-runner && npm install
RUN source ${NVM_DIR}/nvm.sh && cd machine-runner && npm run build
RUN source ${NVM_DIR}/nvm.sh && cd machine-check && npm install
RUN source ${NVM_DIR}/nvm.sh && cd machine-check && npm run build
RUN source ${NVM_DIR}/nvm.sh && cd demos/warehouse-demo && npm install
RUN source ${NVM_DIR}/nvm.sh && cd demos/warehouse-factory-demo && npm install
RUN source ${NVM_DIR}/nvm.sh && cd demos/warehouse-factory-quality-demo && npm install

# Should they be in workdir instead so that they can easily be reviewed/inspected? Now they are in workdir
COPY scripts scripts
RUN chmod +x scripts/warehouse-demo.sh
RUN chmod +x scripts/warehouse-factory-demo.sh
RUN chmod +x scripts/warehouse-factory-quality-demo.sh
RUN chmod +x scripts/kick-the-tires.sh
RUN chmod +x scripts/run-benchmarks.sh