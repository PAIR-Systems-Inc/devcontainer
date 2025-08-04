#!/bin/bash

echo "Welcome to GoodMem Development Environment!"
echo ""
echo "This environment provides:"
echo "  • All GoodMem client libraries pre-installed"
echo "  • Python SDK, OpenAI integration"
echo "  • GoodMem server automatically installed and running"
echo "  • Ready-to-use development workspace"
echo ""

echo "Installing GoodMem server..."
echo "Running: curl -s https://get.goodmem.ai | bash -s -- --debug-install --no-openai-embedder-registration"

# Install GoodMem server in debug mode without OpenAI setup (unattended)
curl -s https://get.goodmem.ai | bash -s -- --debug-install --no-openai-embedder-registration

echo ""
echo "GoodMem server installation complete!"
echo ""
echo "Access Points:"
echo "  • REST API: http://localhost:8080"
echo "  • gRPC API: localhost:9090"
echo "  • Database: localhost:5432 (accessible for development)"
echo "  • JobRunr Dashboard: http://localhost:8001"
echo ""
echo "Getting Started:"
echo "  1. Your GoodMem server is running and ready to use"
echo "  2. Set your API keys in .env file if needed (OPENAI_API_KEY)"
echo "  3. Use the pre-installed client libraries to start building"
echo ""

echo "Setup Complete..."