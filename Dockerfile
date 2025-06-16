FROM ubuntu:24.04

# Install dependencies
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    wget ca-certificates bzip2 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /bin/bash Talos
USER Talos

WORKDIR /workspace
COPY . /workspace

SHELL ["/bin/bash", "-l", "-c"]
CMD ["bash"]
