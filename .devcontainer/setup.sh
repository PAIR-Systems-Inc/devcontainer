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

echo "📋 Setup Instructions:"
echo "  1. Install GoodMem server outside this container:"
echo "     curl -s https://get.goodmem.ai | bash"
echo "  2. Add your API keys to .devcontainer/.env"
echo "  3. Update OPENAI_API_KEY and ADD_API_KEY"
echo "  4. Start coding with GoodMem!"
echo ""

# Check .env file
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
echo "🎉 Setup complete! Happy coding!"
