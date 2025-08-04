#!/bin/bash

echo "Welcome to GoodMem Development Environment!"
echo ""
echo "This environment provides:"
echo "  • All GoodMem client libraries pre-installed"
echo "  • Python SDK, OpenAI integration"
echo "  • Smart GoodMem server configuration"
echo "  • Ready-to-use development workspace"
echo ""

# Create .env file template if it doesn't exist
WORKSPACE_DIR="/workspaces"
ENV_FILE="$WORKSPACE_DIR/.env"

if [ ! -f "$ENV_FILE" ]; then
    echo "Creating .env configuration file..."
    cat > "$ENV_FILE" << 'EOF'
# GoodMem Configuration
GOODMEM_SERVER_URL=http://localhost:8080

# API Keys (set these for your applications)
# OPENAI_API_KEY=your-openai-key-here
# ADD_API_KEY=your-goodmem-api-key-here

# Development Settings
GOODMEM_DEBUG=true
EOF
    echo "Created .env file at $ENV_FILE"
    echo ""
fi

# Interactive prompt for server setup
echo "GoodMem Server Setup"
echo ""
echo "Do you want to:"
echo "  1) Connect to an existing GoodMem server"
echo "  2) Install a local GoodMem server in this container"
echo ""
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        echo ""
        read -p "Enter your GoodMem server URL (e.g., http://my-server.com:8080): " server_url
        
        if [ -n "$server_url" ]; then
            echo "Testing connection to: $server_url"
            
            if curl -s --max-time 10 "$server_url/v1/system/health" > /dev/null 2>&1; then
                echo "Connected to existing GoodMem server!"
                
                # Update .env file with the server URL
                sed -i "s|GOODMEM_SERVER_URL=.*|GOODMEM_SERVER_URL=$server_url|" "$ENV_FILE"
                
                echo ""
                echo "Configuration updated:"
                echo "  • Server URL: $server_url"
                echo "  • Config file: $ENV_FILE"
                echo ""
                echo "Getting Started:"
                echo "  1. Your server is ready to use"
                echo "  2. Update API keys in .env file as needed"
                echo "  3. Use the pre-configured client libraries"
                echo ""
                echo "Setup Complete..."
                exit 0
            else
                echo "Cannot connect to $server_url"
                echo "   Please check the URL and try again"
                echo "   Falling back to local installation..."
                echo ""
            fi
        fi
        ;;
    2)
        echo ""
        echo "Installing local server..."
        ;;
    *)
        echo ""
        echo "Invalid choice. Installing local server by default..."
        ;;
esac

echo "Installing GoodMem server on your HOST machine..."
echo "   This ensures persistence even if devcontainer is deleted"
echo ""

# Check if GoodMem is already running on host
if curl -s --max-time 5 http://host.docker.internal:8080/v1/system/health > /dev/null 2>&1; then
    echo "GoodMem server already running on host machine!"
    echo "   Using existing installation at http://localhost:8080"
else
    echo "Installing GoodMem server on HOST machine..."
    
    # Install GoodMem server on HOST machine (not inside container)
    # This runs the installer on the host's Docker engine

    # Create persistent volumes on host
    docker volume create goodmem_data || true
    docker volume create goodmem_pgdata || true
    
    # Install GoodMem with volume mounts for persistence
    curl -s https://get.goodmem.ai | bash -s -- --debug-install --no-openai-embedder-registration
fi

echo ""
echo "GoodMem server installation complete!"
echo ""
echo "Access Points:"
echo "  • REST API: http://localhost:8080"
echo "  • gRPC API: localhost:9090"
echo "  • Database: localhost:5432 (accessible for development)"
echo "  • JobRunr Dashboard: http://localhost:8001"
echo ""
echo "Configuration:"
echo "  • Settings file: $ENV_FILE"
echo "  • Data persists between rebuilds (Docker volumes)"
echo ""
echo "Getting Started:"
echo "  1. Your GoodMem server is running and ready to use"
echo "  2. Update API keys in .env file as needed"
echo "  3. Use the pre-installed client libraries to start building"
echo ""

echo "Setup Complete..."