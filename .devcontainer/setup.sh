#!/bin/bash

echo "🚀 Welcome to GoodMem Development Environment!"
echo ""
echo "This environment provides:"
echo "  • All GoodMem client libraries pre-installed"
echo "  • Python SDK, OpenAI integration"
echo "  • Ready-to-use development workspace"
echo ""

# Workaround: ensure $USER is defined in non-login shells (e.g., VS Code DevContainer)
if [[ -z "$USER" ]]; then
    export USER=$(whoami)
fi

# Detect CI (GitHub Actions or other automation)
if [[ "$CI" == "true" ]] || [[ "$GITHUB_ACTIONS" == "true" ]] || [[ -n "$RUNNER_OS" ]] || [[ -n "$GITHUB_WORKSPACE" ]]; then
    echo "CI environment detected. Skipping interactive setup."
    echo "Environment is ready for automated testing."
    exit 0
fi

# Decide response interactively or automatically
if [[ "$GOODMEM_AUTOINSTALL" == "y" || "$GOODMEM_AUTOINSTALL" == "n" ]]; then
    response=$GOODMEM_AUTOINSTALL
elif [[ ! -t 0 ]]; then
    echo "Non-interactive shell detected (e.g. Dev Container). Defaulting to YES for local GoodMem install."
    response="y"
else
    echo "Setup Options:"
    echo "  - Use existing GoodMem server: Connect to your remote server"
    echo "  - Install local server: Complete local setup with database + server"
    echo ""
    read -p "Do you want to install a local GoodMem server? (y/n): " response
fi

# Handle response
case $response in
    [Yy]* ) 
        echo "Installing local GoodMem server..."

        sudo apt-get update >/dev/null 2>&1 && sudo apt-get install -y net-tools >/dev/null 2>&1

        find_available_port() {
            local port=$1
            while netstat -tln | grep -q ":$port "; do
                ((port++))
            done
            echo $port
        }

        export GOODMEM_PORT=$(find_available_port 8080)
        export GOODMEM_GRPC_PORT=$(find_available_port 9090)
        export POSTGRES_PORT=$(find_available_port 5432)

        echo "Using ports: REST=$GOODMEM_PORT, gRPC=$GOODMEM_GRPC_PORT, DB=$POSTGRES_PORT"

        # Harden Docker detection
        if ! command -v docker >/dev/null; then
            echo "[WARNING] Docker not found. Will attempt to install it."
        else
            echo "[INFO] Docker already installed."
        fi

        # Ensure usermod works properly
        if getent passwd "$USER" >/dev/null; then
            echo "[INFO] Adding $USER to docker group..."
            sudo usermod -aG docker "$USER"
        else
            echo "[WARNING] Cannot add user to docker group — user not found: $USER"
        fi

        # Run the official GoodMem installer
        echo "[INFO] Running GoodMem install script..."
        curl -s https://get.goodmem.ai | bash -s -- --debug-install

        echo "Local GoodMem server installed successfully."
        echo "Check the VS Code Ports tab to see forwarded ports."
        ;;
    [Nn]* )
        echo "Skipping local server installation."
        echo "You can connect to your existing GoodMem server."
        ;;
    * )
        echo "Invalid response: $response"
        exit 1
        ;;
esac

# Patch .env if needed
ENV_FILE=".devcontainer/.env"
if [[ -f "$ENV_FILE" ]]; then
    echo "[INFO] Found $ENV_FILE. Checking for placeholder API keys..."

    OPENAI_KEY=$(grep OPENAI_API_KEY "$ENV_FILE" | cut -d= -f2-)
    ADD_KEY=$(grep ADD_API_KEY "$ENV_FILE" | cut -d= -f2-)

    if [[ "$OPENAI_KEY" == *"your-openai-api-key-here"* ]]; then
        echo "[WARNING] Placeholder OpenAI key still present in .env."
    fi

    if [[ "$ADD_KEY" == *"your-goodmem-api-key-here"* ]]; then
        echo "[WARNING] Placeholder GoodMem key still present in .env."
    fi
else
    echo "[WARNING] .env file not found at $ENV_FILE. Please create it with API keys."
fi

echo ""
echo "To get started:"
echo "  1. Add your API keys to .devcontainer/.env"
echo "  2. Update OPENAI_API_KEY and ADD_API_KEY"
echo "  3. Start coding with GoodMem"
echo ""
echo "🎉 Setup complete! Happy coding!"
