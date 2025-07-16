FROM ubuntu:22.04

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    sudo \
    build-essential \
    curl \
    wget \
    gnupg \
    software-properties-common \
    ca-certificates \
    apt-transport-https \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.8+ (Ubuntu 22.04 comes with Python 3.10)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install pip and Python packages
RUN python3 -m pip install --upgrade pip uv
RUN python3 -m pip install \
    goodmem-client \
    psycopg2-binary \
    openai \
    python-dotenv \
    requests \
    pyyaml

# Install Java 8+ (OpenJDK 11)
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-11-jdk \
    && rm -rf /var/lib/apt/lists/*

# Install .NET 8.0
RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends --fix-missing \
    dotnet-sdk-8.0 \
    && rm -rf /var/lib/apt/lists/*

# Install Go 1.22+
RUN wget https://go.dev/dl/go1.22.0.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz \
    && rm go1.22.0.linux-amd64.tar.gz

# Install Node.js (LTS version)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$PATH:/usr/local/go/bin
ENV DOTNET_ROOT=/usr/share/dotnet
ENV PATH=$PATH:$DOTNET_ROOT

# Create a non-root user 'vscode' and grant passwordless sudo permissions
RUN useradd -m -s /bin/bash vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode-nopasswd \
    && chmod 0440 /etc/sudoers.d/vscode-nopasswd

# Create and set permissions for the workspace folder
RUN mkdir -p /workspace && chown -R vscode:vscode /workspace

COPY setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

USER vscode
WORKDIR /workspace

# Set up Go workspace for vscode user
RUN mkdir -p /home/vscode/go/{bin,src,pkg}
ENV GOPATH=/home/vscode/go
ENV PATH=$PATH:$GOPATH/bin

