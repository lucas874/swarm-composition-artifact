FROM ubuntu:24.04
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y curl gzip nano python3-pip python3.12-venv just tmux && \
    apt-get clean

# Use bash for the shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Set up some environment variables
ENV DIR=/ecoop25_artifact
ENV CRITERION_DATA_DIR="${DIR}/machines/machine-check/target/criterion/data/main"
ENV SHORT_CRITERION_DATA_DIR="${CRITERION_DATA_DIR}/General-pattern-algorithm1-vs.-exact-short-run"
ENV FULL_CRITERION_DATA_DIR="${CRITERION_DATA_DIR}/General-pattern-algorithm1-vs.-exact-full-run"
ENV BENCHMARK_DIR="${DIR}/machines/machine-check/bench_and_results"
ENV SHORT_ACCURACY_RESULT_DIR="${BENCHMARK_DIR}/short_subscription_size_benchmarks/general_pattern"
ENV FULL_ACCURACY_RESULT_DIR="${BENCHMARK_DIR}/subscription_size_benchmarks/general_pattern"

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

# Should they be in workdir instead so that they can easily be reviewed?
COPY kick-the-tires /usr/local/bin
RUN chmod +x /usr/local/bin/kick-the-tires
COPY run-benchmarks /usr/local/bin
RUN chmod +x /usr/local/bin/run-benchmarks

# Set up nvm, nodejs and npm
ARG NODE_VERSION=20
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh -sSf | bash
ENV NVM_DIR=/root/.nvm
RUN source ${NVM_DIR}/nvm.sh && nvm install ${NODE_VERSION}
RUN source ${NVM_DIR}/nvm.sh && npm install typescript -g
#RUN npm install typescript -g
#RUN node -v
#RUN npm -v

# Set up working directory
WORKDIR ${DIR}
COPY machines ./machines
COPY process_results ./process_results
RUN source ${NVM_DIR}/nvm.sh && cd machines/machine-runner && npm install
RUN source ${NVM_DIR}/nvm.sh && cd machines/machine-runner && npm run build
RUN source ${NVM_DIR}/nvm.sh && cd machines/machine-check && npm install
RUN source ${NVM_DIR}/nvm.sh && cd machines/machine-check && npm run build
RUN source ${NVM_DIR}/nvm.sh && cd machines/demo && npm install