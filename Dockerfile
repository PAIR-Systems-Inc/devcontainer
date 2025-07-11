FROM python:3.12-slim

# The system depdencies
RUN apt-get update && apt-get install -y --no-install-recommends git build-essential && rm -rf /var/lib/apt/lists/*

RUN pip install uv
RUN useradd -m -s /bin/bash vscode && chown -R vscode:vscode /workspace

#install the correct versoin for the rest of the languages here: 

USER vscode
WORKDIR /workspace

