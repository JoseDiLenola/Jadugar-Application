# Development Environment Quick Reference

## 🚀 Quick Start
```bash
# 1. Clone and Setup
git clone git@github.com:your-org/jadugar.git
cd jadugar
npm install

# 2. Start Development
npm run dev

# 3. Run Tests
npm test
```

## 🔧 Common Commands
```bash
# Package Management
npm install              # Install dependencies
npm run clean           # Clean build artifacts
npm run build           # Build all packages
npm run type-check      # Check TypeScript

# Development
npm run dev             # Start dev server
npm run lint           # Run linter
npm run format         # Format code

# Testing
npm test               # Run all tests
npm run test:watch     # Watch mode
npm run test:coverage  # Coverage report
```

## 📝 Configuration Files
```bash
# Core Config Files
./tsconfig.json         # TypeScript config
./package.json         # NPM config
./.env.development     # Dev environment vars
./vite.config.ts       # Vite config

# Database
./prisma/schema.prisma # Database schema
./.env                # Database connection
```

## 🗄️ Directory Structure
```
jadugar/
├── packages/           # Monorepo packages
│   ├── types/         # Type definitions
│   ├── utils/         # Shared utilities
│   ├── core/          # Core functionality
│   └── ui/            # UI components
├── apps/              # Applications
│   ├── web/           # Web frontend
│   └── api/           # Backend API
└── docs/              # Documentation
```

## 🐛 Common Issues

### Build Failures
```bash
# 1. TypeScript Errors
npm run type-check     # Check types
npm install @types/* --save-dev  # Install missing types

# 2. Package Issues
rm -rf node_modules
npm install

# 3. Cache Issues
npm cache clean --force
```

### Database Issues
```bash
# 1. Connection Issues
brew services restart postgresql
psql -d jadugar_dev -U postgres

# 2. Migration Issues
npx prisma migrate reset
npx prisma generate
```

### Docker Issues
```bash
# 1. Container Issues
docker-compose down
docker-compose up -d

# 2. Volume Issues
docker volume prune
docker-compose up -d
```

## 📡 API Endpoints
```bash
# Local Development
http://localhost:3000/api/v1/

# Health Check
curl http://localhost:3000/health

# API Documentation
http://localhost:3000/docs
```

## 🔍 Debugging
```bash
# Node Inspector
node --inspect-brk

# VS Code Launch Config
.vscode/launch.json

# Chrome DevTools
chrome://inspect
```

## 📊 Monitoring
```bash
# Local Metrics
http://localhost:9090

# Logs
docker-compose logs -f

# Database
psql jadugar_dev -c "SELECT count(*) FROM pg_stat_activity;"
```
