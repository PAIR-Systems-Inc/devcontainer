#!/bin/bash

echo "🚀 Welcome to GoodMem Development Environment!"
echo ""
echo "This environment provides:"
echo "  • All GoodMem client libraries pre-installed"
echo "  • Python SDK, OpenAI integration"
echo "  • Ready-to-use development workspace"
echo ""

# Detect CI (GitHub Actions or other automation)
if [[ "$CI" == "true" ]] || [[ "$GITHUB_ACTIONS" == "true" ]] || [[ -n "$RUNNER_OS" ]] || [[ -n "$GITHUB_WORKSPACE" ]]; then
    echo "CI environment detected. Skipping interactive setup."
    echo "Environment is ready for automated testing."
    exit 0
fi

echo "📋 Getting Started:"
echo "  1. Install GoodMem server on your host machine:"
echo "     curl -s https://get.goodmem.ai | bash"
echo "  2. Update .devcontainer/.env with your server details"
echo "  3. Set GOODMEM_SERVER_URL (if not localhost:8080)"
echo "  4. Set your API keys (OPENAI_API_KEY and ADD_API_KEY)"
echo ""

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
echo "Setup complete! Happy coding with GoodMem!"