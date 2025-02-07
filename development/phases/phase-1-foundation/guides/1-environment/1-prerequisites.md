# 1.1 Prerequisites

## Overview
This guide covers the prerequisites required before starting the Jadugar project setup.

## Dependencies
None - This is the starting point.

## Requirements

### 1. Operating System
- ✅ macOS Ventura or later
  - System updates installed
  - Developer tools enabled
  - Terminal access

### 2. Command Line Tools
```bash
# Install Xcode Command Line Tools
xcode-select --install

# Verify installation
xcode-select -p  # Should output /Library/Developer/CommandLineTools
```

### 3. System Access
- Administrator privileges
- Terminal access
- Network access for downloads

## Verification

### 1. System Check
```bash
# Check macOS version
sw_vers

# Expected output:
# ProductName:    macOS
# ProductVersion: 13.0.0 or higher
# BuildVersion:   22A380 or higher
```

### 2. Command Line Tools
```bash
# Verify developer tools
xcode-select -p
gcc --version
git --version
```

### 3. Permissions Check
```bash
# Verify admin access
sudo -v

# Check directory permissions
ls -la ~
```

## Common Issues

### 1. Command Line Tools Missing
```bash
# Reinstall if needed
xcode-select --install
```

### 2. Permission Issues
```bash
# Fix home directory permissions
chown -R $(whoami) ~
```

### 3. System Requirements
- Update macOS if below Ventura
- Free up disk space if needed
- Close conflicting applications

## Verification Checklist
- [ ] macOS version verified
- [ ] Command Line Tools installed
- [ ] Administrator access confirmed
- [ ] Directory permissions correct
- [ ] Development tools accessible

## Next Steps
1. Proceed to [Node.js Setup](2-node-setup.md)
2. Prepare for development tools
3. Review system requirements

## Resources
- [macOS Updates](https://support.apple.com/macos)
- [Xcode Downloads](https://developer.apple.com/xcode)
- [Terminal Guide](https://support.apple.com/guide/terminal)
