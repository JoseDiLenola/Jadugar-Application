# 1.3 Development Tools

## Overview
This guide covers the installation and configuration of essential development tools including Yarn, Git, and VS Code.

## Dependencies
- ✅ [Prerequisites](1-prerequisites.md) completed
- ✅ [Node.js Setup](2-node-setup.md) completed
- ✅ Node.js v20.18.2 verified

## Steps

### 1. Yarn Installation
```bash
# Install Yarn 1.22.22
npm install -g yarn@1.22.22

# Verify installation
yarn --version  # Should output 1.22.22

# Configure Yarn
yarn config set workspaces-experimental true
```

### 2. Git Configuration
```bash
# Configure Git user
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Configure Git defaults
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.editor "code --wait"

# Configure Git credentials
git config --global credential.helper osxkeychain
```

### 3. VS Code Setup
1. Install VS Code from [https://code.visualstudio.com](https://code.visualstudio.com)

2. Install Extensions:
   ```bash
   # Install required extensions
   code --install-extension dbaeumer.vscode-eslint
   code --install-extension esbenp.prettier-vscode
   code --install-extension ms-vscode.vscode-typescript-next
   code --install-extension orta.vscode-jest
   code --install-extension msjsdiag.vscode-react-native
   code --install-extension eamodio.gitlens
   ```

3. Configure Settings:
   ```jsonc
   {
     "editor.formatOnSave": true,
     "editor.defaultFormatter": "esbenp.prettier-vscode",
     "typescript.tsdk": "node_modules/typescript/lib",
     "javascript.updateImportsOnFileMove.enabled": "always",
     "typescript.updateImportsOnFileMove.enabled": "always"
   }
   ```

## Verification

### 1. Tool Versions
```bash
# Create verification script
cat > verify-tools.sh << 'EOF'
#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

check_command() {
    command -v $1 >/dev/null 2>&1 || { 
        echo -e "${RED}❌ $1 is not installed${NC}"
        return 1
    }
    echo -e "${GREEN}✓ $1 is installed${NC}"
    return 0
}

# Check Node.js
check_command node || exit 1
[[ $(node --version) == "v20.18.2" ]] || { 
    echo -e "${RED}❌ Node.js version mismatch${NC}"
    exit 1
}

# Check Yarn
check_command yarn || exit 1
[[ $(yarn --version) == "1.22.22" ]] || { 
    echo -e "${RED}❌ Yarn version mismatch${NC}"
    exit 1
}

# Check Git
check_command git || exit 1

# Check VS Code
check_command code || exit 1

echo -e "\n${GREEN}✓ All tool checks passed${NC}"
EOF

# Make script executable
chmod +x verify-tools.sh

# Run verification
./verify-tools.sh
```

### 2. VS Code Extensions
```bash
# Verify extensions
code --list-extensions | grep -E 'eslint|prettier|typescript|jest|react-native|gitlens'
```

### 3. Git Configuration
```bash
# Verify Git config
git config --list
```

## Common Issues

### 1. Yarn Installation Failed
```bash
# Solution: Clear npm cache and reinstall
npm cache clean --force
npm install -g yarn@1.22.22
```

### 2. VS Code Extensions
```bash
# Solution: Manual installation
code --install-extension <extension-id>
```

### 3. Git Configuration
```bash
# Solution: Reset Git config
git config --global --unset-all
# Then reconfigure as needed
```

## Verification Checklist
- [ ] Yarn 1.22.22 installed and verified
- [ ] Git configured correctly
- [ ] VS Code installed with extensions
- [ ] All verification scripts passing
- [ ] Development environment ready

## Next Steps
1. Proceed to [Project Structure](../2-structure/index.md)
2. Review the monorepo setup guide
3. Prepare for project initialization

## Resources
- [Yarn Documentation](https://classic.yarnpkg.com/docs)
- [Git Documentation](https://git-scm.com/doc)
- [VS Code Documentation](https://code.visualstudio.com/docs)
