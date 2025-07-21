#### Goodmem Devcontainer

##### What the container includes: 
- Python 3.10 with GoodMem SDKs and OpenAI support
- Java 17, .NET 8, Go 1.22, Node.js 20, and pnpm
- Preinstalled VS Code extensions for Python, Java, Go, .NET, Node.js, linting, and formatting
- Shell access as a preconfigured `vscode` user
- All settings baked into the image — no configuration needed

##### The benefits: 
- Zero setup time: No need to install compilers, SDKs, linters, or extensions manually.
- Consistency: Everyone uses the exact same environment.
- Upgradable: When a new version is published, just update the image tag and rebuild.
- Rebuild-safe: All logic is pre-baked into the image — no fragile post-create scripts.
- Offline-friendly: Once pulled, you don’t need the internet to re-use the environments 

##### How to use: 
- Open your project in VS Code
- Run Ctrl + Shift + P (or Cmd + Shift + P on Mac)
- Choose “Dev Containers: Add Dev Container Configuration Files”
- Select “From a predefined template”
- Paste ghcr.io/mariamahmad8/templates/goodmem-dev as your template
- Accept default settings or customize as needed
- Reopen in container when promt


##### Updating Version Example:

```json
"image": "ghcr.io/mariamahmad8/goodmem-container:1.0.11"
```

- Open your .devcontainer.json, and find the line above
- Update the version with the newest one. 

```json
"image": "ghcr.io/mariamahmad8/goodmem-container:1.0.12"
```

- Save the changes and rebuild the container. You are now working with the most up to date version of the Goodmem Devcontainer. 