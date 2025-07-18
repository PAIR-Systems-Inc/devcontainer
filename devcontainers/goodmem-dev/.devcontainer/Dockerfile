FROM ubuntu:22.04

LABEL org.opencontainers.image.title="GoodMem Dev Environment" \
      org.opencontainers.image.description="Prebuilt DevContainer for GoodMem projects" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.url="https://github.com/mariamahmad8/goodmem-container" \
      org.opencontainers.image.source="https://github.com/mariamahmad8/goodmem-container" \
      com.github.devcontainers.template=true \
      com.github.devcontainers.template.version="1.0.0"

# Use bash as default shell
SHELL ["/bin/bash", "-c"]

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

# Install Python 3.10 + pip + uv
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --upgrade pip uv \
 && python3 -m pip install \
    goodmem-client \
    psycopg2-binary \
    openai \
    python-dotenv \
    requests \
    pyyaml

# Install Java 17
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Install .NET 8.0 SDK
RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    dotnet-sdk-8.0 \
    && rm -rf /var/lib/apt/lists/*

ENV DOTNET_ROOT=/usr/share/dotnet
ENV PATH="${DOTNET_ROOT}:${PATH}"

# Install Go 1.22.2
RUN wget https://go.dev/dl/go1.22.2.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz \
    && rm go1.22.2.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

# Install Node.js 20.x + pnpm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g pnpm \
    && rm -rf /var/lib/apt/lists/*

# Create non-root vscode user
RUN useradd -m -s /bin/bash vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode-nopasswd \
    && chmod 0440 /etc/sudoers.d/vscode-nopasswd

# Set up workspace
RUN mkdir -p /workspace && chown -R vscode:vscode /workspace

# Optional: build GoodMem clients (uncomment if you include clients/ directory)
# COPY ./clients /opt/clients
# RUN chmod +x /opt/clients/build_all.sh && /opt/clients/build_all.sh

# Setup script
COPY setup.sh /setup.sh
RUN chmod +x /setup.sh

USER vscode
WORKDIR /workspace
