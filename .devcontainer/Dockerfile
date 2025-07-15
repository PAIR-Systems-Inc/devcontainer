FROM ubuntu:22.04

# Install system dependencies and Python 3 (default version)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    sudo \
    build-essential \
    curl \
    wget \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install pip and uv
RUN python3 -m pip install --upgrade pip uv

# Install Python packages
RUN python3 -m pip install \
    goodmem-client \
    psycopg2-binary \
    openai \
    python-dotenv \
    requests \
    pyyaml



# Create a non-root user 'vscode' and grant passwordless sudo permissions
RUN useradd -m -s /bin/bash vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode-nopasswd \
    && chmod 0440 /etc/sudoers.d/vscode-nopasswd

# Create and set permissions for the workspace folder
RUN mkdir -p /workspace && chown -R vscode:vscode /workspace

#install the correct versoin for the rest of the languages here: 

USER vscode
WORKDIR /workspace

