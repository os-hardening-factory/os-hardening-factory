# Base: Ubuntu 22.04 (we will later replace this with hardened OS)
FROM ubuntu:22.04

LABEL maintainer="os-hardening-factory"
LABEL project="os-hardened-base"

RUN apt-get update && apt-get install -y curl vim && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["bash"]
