### GoodMem DevContainer Template

##### What the container includes: 
- Python 3.10+ with GoodMem client libraries and OpenAI integration
- Java 17, .NET 8, Go 1.22, Node.js 20, and pnpm pre-installed
- VS Code extensions for multi-language development, linting, and formatting
- Automatic GoodMem server setup with persistent data storage
- Shell access as preconfigured `vscode` user with sudo privileges
- Auto-generated .env file with API key templates

##### The benefits: 
- **Zero setup time**: Start coding immediately with pre-built environment
- **Consistency**: Everyone uses the exact same development stack
- **Smart setup**: Detects existing Docker, handles interactive/non-interactive modes
- **Persistent data**: GoodMem server data survives container rebuilds
- **Multi-language ready**: Python, Java, Go, .NET, and Node.js all configured
- **Clean workspace**: Internal build files hidden from users

##### How to use: 
- Open your project in VS Code
- Run `Ctrl + Shift + P` (or `Cmd + Shift + P` on Mac)
- Choose "Dev Containers: Add Dev Container Configuration Files"
- Select "Add configuration from a repository or published template"
- **Paste:** `ghcr.io/pair-systems-inc/devcontainer/goodmem-devcontainer`
- Accept default settings or customize as needed
- Reopen in container when prompted

##### Template URL:
```
ghcr.io/pair-systems-inc/devcontainer/goodmem-devcontainer
```

##### Getting Started:
1. **Set your API keys** in the auto-generated `.env` file:
   ```bash
   ADD_API_KEY=your-goodmem-api-key-here
   OPENAI_API_KEY=your-openai-api-key-here
   ANTHROPIC_API_KEY=your-anthropic-api-key-here
   ```

2. **Test your setup**:
   ```bash
   python .devcontainer/test.py
   ```

3. **Start building** with GoodMem!

##### What happens automatically:
- ✅ Multi-language environment loads instantly
- ✅ GoodMem server installs and starts  
- ✅ API key templates created in `.env`
- ✅ Docker volumes configured for data persistence
- ✅ All development tools ready to use

##### Current Version: 0.5.2

The template uses a pre-built Docker image (`ghcr.io/pair-systems-inc/goodmem-dev:latest`) for fast startup times and consistent environments across all users.