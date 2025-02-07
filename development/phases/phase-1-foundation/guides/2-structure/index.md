# 2. Project Structure Guide

## Overview
This guide details the monorepo project structure for Jadugar, following a bottom-up approach where we start with essential foundations and expand as needed.

## Dependencies
- ✅ [Environment Setup](../1-environment/index.md) completed
- ✅ All tools verified
- ✅ Development environment ready

## Steps Overview
1. [Directory Setup](1-directories.md)
   - Create project structure
   - Set up documentation
   - Initialize Git

2. [Monorepo Configuration](2-monorepo.md)
   - Configure workspaces
   - Set up packages
   - Initialize applications

3. [Verification](3-verification.md)
   - Verify structure
   - Test configuration
   - Validate setup

## Directory Structure
```
jadugar/
├── apps/                   # Application packages
│   └── web/               # Next.js web application
│       ├── pages/         # Next.js pages
│       ├── public/        # Static assets
│       ├── styles/        # CSS styles
│       ├── next.config.js # Next.js configuration
│       ├── package.json   # Package configuration
│       └── tsconfig.json  # TypeScript configuration
├── packages/              # Shared packages
│   └── ui/               # UI component library
│       ├── src/          # Source code
│       └── package.json  # Package configuration
├── docs/                  # Documentation
│   └── development/      # Development documentation
├── scripts/              # Build and utility scripts
├── package.json         # Root package configuration
├── yarn.lock           # Dependency lock file
├── turbo.json         # Turbo configuration
└── README.md         # Project overview
```

## Verification Checklist
- [ ] Directory structure created
- [ ] Git initialized
- [ ] Workspaces configured
- [ ] Packages set up
- [ ] Documentation organized

## Next Steps
1. [Basic Configuration](../3-configuration/index.md)
2. Review the Next.js setup guide
3. Prepare for TypeScript configuration

## Resources
- [Turborepo Documentation](https://turbo.build/repo/docs)
- [Next.js Project Structure](https://nextjs.org/docs/getting-started/project-structure)
- [Yarn Workspaces](https://classic.yarnpkg.com/lang/en/docs/workspaces/)
