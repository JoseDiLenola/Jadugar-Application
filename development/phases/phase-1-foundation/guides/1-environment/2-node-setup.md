# 1.2 Node.js Setup

## Overview
This guide covers the installation and configuration of Node.js using NVM (Node Version Manager).

## Dependencies
- ✅ [Prerequisites](1-prerequisites.md) completed and verified
- ✅ Command Line Tools installed
- ✅ Administrator access confirmed

## Steps

### 1. NVM Installation
```bash
# Check if nvm is installed
command -v nvm

# If not found, install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Add to shell configuration
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc

# Reload shell configuration
source ~/.zshrc

# Verify installation
command -v nvm  # Should output 'nvm'
```

### 2. Node.js Installation
```bash
# Install Node.js 20.18.2
nvm install 20.18.2

# Set as default version
nvm use 20.18.2
nvm alias default 20.18.2

# Verify installation
node --version  # Should output v20.18.2
```

### 3. NPM Configuration
```bash
# Update npm to latest version
npm install -g npm@latest

# Verify npm installation
npm --version

# Configure npm defaults
npm config set init-author-name "Your Name"
npm config set init-author-email "your.email@example.com"
npm config set init-license "MIT"
```

## Verification

### 1. Version Check
```bash
# Create version verification script
cat > verify-node.sh << 'EOF'
#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Check Node.js version
node_version=$(node --version)
if [[ "$node_version" == "v20.18.2" ]]; then
    echo -e "${GREEN}✓ Node.js version correct: $node_version${NC}"
else
    echo -e "${RED}✗ Node.js version incorrect: $node_version${NC}"
    exit 1
fi

# Check npm installation
if command -v npm >/dev/null; then
    echo -e "${GREEN}✓ npm is installed${NC}"
else
    echo -e "${RED}✗ npm is not installed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ All Node.js checks passed${NC}"
EOF

# Make script executable
chmod +x verify-node.sh

# Run verification
./verify-node.sh
```

### 2. Environment Check
```bash
# Verify NVM
nvm --version

# Check current Node.js
node --version

# Verify npm
npm --version
```

## Common Issues

### 1. NVM Not Found
```bash
# Solution: Reload shell
source ~/.zshrc

# Or reinstall NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```

### 2. Wrong Node.js Version
```bash
# Solution: Switch version
nvm use 20.18.2

# Or reinstall
nvm install 20.18.2
```

### 3. NPM Issues
```bash
# Solution: Reinstall npm
npm install -g npm@latest

# Clear npm cache
npm cache clean --force
```

## Verification Checklist
- [ ] NVM installed and working
- [ ] Node.js v20.18.2 installed
- [ ] Node.js version set as default
- [ ] NPM configured correctly
- [ ] All verification scripts pass

## Next Steps
1. Proceed to [Development Tools](3-verification.md)
2. Prepare for Yarn installation
3. Review Git configuration requirements

## Resources
- [NVM Documentation](https://github.com/nvm-sh/nvm)
- [Node.js Documentation](https://nodejs.org/docs/v20.18.2)
- [NPM Documentation](https://docs.npmjs.com)
