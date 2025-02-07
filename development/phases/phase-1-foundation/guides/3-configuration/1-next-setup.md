# 3.1 Next.js Setup

## Overview
This guide covers the configuration of Next.js with React Native Web integration.

## Dependencies
- ✅ [Project Structure](../2-structure/index.md) completed
- ✅ Dependencies installed
- ✅ Workspace resolution verified

## Steps

### 1. Next.js Configuration
```bash
# Create next.config.js
cat > apps/web/next.config.js << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  webpack: (config) => {
    // Enable React Native Web support
    config.resolve.alias = {
      ...(config.resolve.alias || {}),
      'react-native$': 'react-native-web'
    };
    return config;
  },
  // Enable static exports
  output: 'export',
  // Disable image optimization (not needed for static export)
  images: {
    unoptimized: true
  }
};

module.exports = nextConfig;
EOF
```

### 2. Environment Configuration
```bash
# Create development environment file
cat > apps/web/.env.development << 'EOF'
NEXT_PUBLIC_API_URL=http://localhost:3000
NEXT_PUBLIC_ENV=development
NEXT_PUBLIC_DEBUG=true
EOF

# Create production environment file
cat > apps/web/.env.production << 'EOF'
NEXT_PUBLIC_API_URL=https://api.jadugar.com
NEXT_PUBLIC_ENV=production
NEXT_PUBLIC_DEBUG=false
EOF

# Create example environment file
cat > apps/web/.env.example << 'EOF'
NEXT_PUBLIC_API_URL=http://localhost:3000
NEXT_PUBLIC_ENV=development
NEXT_PUBLIC_DEBUG=false
EOF
```

### 3. Page Setup
```bash
# Create index page
cat > apps/web/pages/index.tsx << 'EOF'
import { View, Text, StyleSheet } from 'react-native';

export default function Home() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Welcome to Jadugar</Text>
      <Text style={styles.subtitle}>Your Next.js app with React Native Web</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  subtitle: {
    fontSize: 16,
    color: '#666',
  },
});
EOF

# Create _app page
cat > apps/web/pages/_app.tsx << 'EOF'
import type { AppProps } from 'next/app';
import '../styles/globals.css';

export default function App({ Component, pageProps }: AppProps) {
  return <Component {...pageProps} />;
}
EOF

# Create global styles
cat > apps/web/styles/globals.css << 'EOF'
html,
body {
  padding: 0;
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Oxygen,
    Ubuntu, Cantarell, Fira Sans, Droid Sans, Helvetica Neue, sans-serif;
}

* {
  box-sizing: border-box;
}
EOF
```

## Verification

### 1. Configuration Check
```bash
# Create verification script
cat > verify-next.sh << 'EOF'
#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "\n${YELLOW}Checking Next.js Configuration${NC}"

# Check configuration files
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓ File exists: $1${NC}"
        return 0
    else
        echo -e "${RED}❌ Missing file: $1${NC}"
        return 1
    }
}

check_file "apps/web/next.config.js" || exit 1
check_file "apps/web/.env.development" || exit 1
check_file "apps/web/.env.production" || exit 1
check_file "apps/web/pages/index.tsx" || exit 1
check_file "apps/web/pages/_app.tsx" || exit 1
check_file "apps/web/styles/globals.css" || exit 1

# Start development server
echo -e "\nStarting development server..."
cd apps/web
yarn dev &
SERVER_PID=$!

# Wait for server to start
sleep 5

# Check if server is running
if curl -s http://localhost:3000 > /dev/null; then
    echo -e "${GREEN}✓ Development server running${NC}"
    kill $SERVER_PID
else
    echo -e "${RED}❌ Development server failed to start${NC}"
    kill $SERVER_PID
    exit 1
fi

echo -e "\n${GREEN}✓ All Next.js checks passed${NC}"
EOF

# Make script executable
chmod +x verify-next.sh

# Run verification
./verify-next.sh
```

### 2. Build Check
```bash
# Create build verification script
cat > verify-build.sh << 'EOF'
#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "\n${YELLOW}Checking Next.js Build${NC}"

cd apps/web

# Run build
echo "Building Next.js app..."
if yarn build; then
    echo -e "${GREEN}✓ Build successful${NC}"
else
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi

# Check build output
if [ -d "out" ]; then
    echo -e "${GREEN}✓ Build output generated${NC}"
else
    echo -e "${RED}❌ Build output missing${NC}"
    exit 1
fi

echo -e "\n${GREEN}✓ All build checks passed${NC}"
EOF

# Make script executable
chmod +x verify-build.sh

# Run verification
./verify-build.sh
```

## Common Issues

### 1. Development Server
```bash
# Solution: Check port availability
lsof -i :3000
# Kill process if needed
kill -9 <PID>
```

### 2. Build Errors
```bash
# Solution: Clean and rebuild
cd apps/web
rm -rf .next out
yarn build
```

### 3. Environment Variables
```bash
# Solution: Verify environment files
cat .env.development
cat .env.production
```

## Verification Checklist
- [ ] Next.js configuration complete
- [ ] Environment files set up
- [ ] Pages created and working
- [ ] Development server running
- [ ] Build process successful
- [ ] React Native Web integration working

## Next Steps
1. Proceed to [TypeScript Configuration](2-typescript.md)
2. Set up type definitions
3. Configure path aliases

## Resources
- [Next.js Documentation](https://nextjs.org/docs)
- [React Native Web](https://necolas.github.io/react-native-web/)
- [Environment Variables](https://nextjs.org/docs/basic-features/environment-variables)
