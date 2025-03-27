FROM ubuntu:24.04
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y curl gzip nano python3-pip python3.12-venv just tmux && \
    apt-get clean
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install cargo-criterion
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv ${VIRTUAL_ENV}
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
COPY process_results/requirements.txt .
RUN pip3 install -r requirements.txt