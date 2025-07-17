#!/bin/bash

echo "🚀 Welcome to GoodMem Development Environment!"
echo ""
echo "This environment provides:"
echo "  • All GoodMem client libraries pre-installed"
echo "  • Python SDK, OpenAI integration"
echo "  • Docker-in-Docker for local server installation"
echo "  • Ready-to-use development workspace"
echo ""

# Detect CI (GitHub Actions or other automation)
if [[ "$CI" == "true" ]] || [[ "$GITHUB_ACTIONS" == "true" ]] || [[ -n "$RUNNER_OS" ]] || [[ -n "$GITHUB_WORKSPACE" ]]; then
    echo "CI environment detected. Skipping interactive setup."
    echo "Environment is ready for automated testing."
    exit 0
fi

echo "📋 GoodMem Server Setup Options:"
echo "  1. Connect to existing server (remote/external)"
echo "  2. Install local server (in this devcontainer)"
echo ""

# Get user choice
# Determine setup mode: interactive or automated
if [[ "$GOODMEM_SETUP_CHOICE" == "1" || "$GOODMEM_SETUP_CHOICE" == "2" ]]; then
    choice=$GOODMEM_SETUP_CHOICE
elif [[ ! -t 0 ]]; then
    echo "Detected non-interactive shell (e.g. Dev Container). Defaulting to option 2: install local server"
    choice="2"
else
    read -p "Choose option (1 or 2): " choice
fi


case $choice in
    1)
        echo ""
        echo "✅ Using existing GoodMem server"
        echo ""
        echo "📋 Next steps:"
        echo "  1. Update .devcontainer/.env with your server details"
        echo "  2. Set GOODMEM_SERVER_URL (if not localhost:8080)"
        echo "  3. Set your API keys (OPENAI_API_KEY and ADD_API_KEY)"
        echo ""
        ;;
    2)
        echo ""
        echo "🔧 Installing local GoodMem server..."
        
        # Install netstat for port checking
        sudo apt-get update >/dev/null 2>&1 && sudo apt-get install -y net-tools >/dev/null 2>&1
        
        # Function to find available port
        find_available_port() {
            local port=$1
            while netstat -tln | grep -q ":$port "; do
                ((port++))
            done
            echo $port
        }
        
        # Find and export available ports
        export GOODMEM_PORT=$(find_available_port 8080)
        export GOODMEM_GRPC_PORT=$(find_available_port 9090)
        export POSTGRES_PORT=$(find_available_port 5432)
        
        echo "Using ports: REST=$GOODMEM_PORT, gRPC=$GOODMEM_GRPC_PORT, DB=$POSTGRES_PORT"
        
        # Check if server already running
        if curl -sf http://localhost:$GOODMEM_PORT/v1/health > /dev/null 2>&1; then
            echo "✅ GoodMem server already running on port $GOODMEM_PORT"
        else
            echo "📦 Installing GoodMem server..."
            curl -s https://get.goodmem.ai | bash -s -- --debug-install
            
            echo ""
            echo "✅ Local GoodMem server installation complete!"
            echo "🔗 Server running at: http://localhost:$GOODMEM_PORT"
            echo "📊 Database accessible at: localhost:$POSTGRES_PORT"
        fi
        
        echo ""
        echo "📋 Next steps:"
        echo "  1. Update .devcontainer/.env with your API keys"
        echo "  2. Set OPENAI_API_KEY and ADD_API_KEY"
        echo "  3. Server URL is automatically set to localhost:$GOODMEM_PORT"
        echo ""
        ;;
    *)
        echo "❌ Invalid choice. Please run the setup again."
        exit 1
        ;;
esac

# Check .env file
ENV_FILE=".devcontainer/.env"
if [[ -f "$ENV_FILE" ]]; then
    echo "[INFO] Found $ENV_FILE"

    if grep -q "your-openai-api-key-here" "$ENV_FILE"; then
        echo "[TODO] Replace placeholder OpenAI key in .env"
    fi

    if grep -q "your-goodmem-api-key-here" "$ENV_FILE"; then
        echo "[TODO] Replace placeholder GoodMem key in .env"
    fi

    if ! grep -q "your-.*-api-key-here" "$ENV_FILE"; then
        echo "[✓] API keys configured"
    fi
else
    echo "[WARNING] .env file not found at $ENV_FILE"
fi

echo ""
echo "🎉 Setup complete! Happy coding with GoodMem!"
