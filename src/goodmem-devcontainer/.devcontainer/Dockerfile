FROM ubuntu:22.04

LABEL org.opencontainers.image.title="GoodMem Dev Environment" \
      org.opencontainers.image.description="Prebuilt DevContainer for GoodMem projects" \
      org.opencontainers.image.version="1.0.20" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.url="https://github.com/PAIR-Systems-Inc/devcontainer" \
      org.opencontainers.image.source="https://github.com/PAIR-Systems-Inc/devcontainer" \
      com.github.devcontainers.template=true \
      com.github.devcontainers.template.version="1.0.20"

SHELL ["/bin/bash", "-c"]

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git sudo build-essential curl wget gnupg \
    software-properties-common ca-certificates \
    apt-transport-https unzip \
  && rm -rf /var/lib/apt/lists/*

# Python SDK
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv python3-dev \
  && rm -rf /var/lib/apt/lists/*
RUN python3 -m pip install --upgrade pip uv && \
    python3 -m pip install goodmem-client psycopg2-binary openai python-dotenv requests pyyaml

# Java (needed by other parts of your image)
RUN apt-get update && apt-get install -y --no-install-recommends openjdk-17-jdk \
  && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# .NET
RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && rm packages-microsoft-prod.deb && \
    apt-get update && apt-get install -y --no-install-recommends dotnet-sdk-8.0 && \
    rm -rf /var/lib/apt/lists/*
ENV DOTNET_ROOT=/usr/share/dotnet
ENV PATH="${DOTNET_ROOT}:${PATH}"

# Go
RUN wget https://go.dev/dl/go1.22.2.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz && rm go1.22.2.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"

# Node.js + pnpm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && npm install -g pnpm && \
    rm -rf /var/lib/apt/lists/*

# Install Docker CLI (so goodmem installer will detect it and skip the full install)
RUN apt-get update && apt-get install -y --no-install-recommends docker.io \
  && rm -rf /var/lib/apt/lists/*

# Create vscode user with passwordless sudo
RUN useradd -m -s /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode-nopasswd && \
    chmod 0440 /etc/sudoers.d/vscode-nopasswd

# Create workspace
RUN mkdir -p /workspace && chown -R vscode:vscode /workspace

# Copy your helper script
COPY setup.sh /usr/local/bin/goodmem-setup.sh
RUN chmod +x /usr/local/bin/goodmem-setup.sh

# **Don’t** run the GoodMem installer here—that will happen interactively on attach.

USER vscode
WORKDIR /workspace
