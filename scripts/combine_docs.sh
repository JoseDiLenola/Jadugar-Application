#!/bin/bash

# Create output directory
mkdir -p combined_docs

# Create the combined markdown file
cat > combined_docs/combined.md << 'EOL'
---
title: "Jadugar Project Documentation"
author: "Jadugar Team"
date: "February 7, 2025"
geometry: margin=1in
---

EOL

# Combine files in specific order
echo "# Table of Contents" >> combined_docs/combined.md
echo "" >> combined_docs/combined.md

# 1. Project Overview
echo "## 1. Project Overview" >> combined_docs/combined.md
cat ../INDEX.md >> combined_docs/combined.md
cat ../ABOUT.md >> combined_docs/combined.md
cat ../QUICKSTART.md >> combined_docs/combined.md

# 2. Architecture
echo "## 2. Architecture" >> combined_docs/combined.md
cat ../architecture/ARCHITECTURE.md >> combined_docs/combined.md
cat ../architecture/project-structure.md >> combined_docs/combined.md

# 3. Development
echo "## 3. Development" >> combined_docs/combined.md
cat ../development/STANDARDS.md >> combined_docs/combined.md
cat ../development/PACKAGE_GUIDE.md >> combined_docs/combined.md
cat ../development/TESTING_STRATEGY.md >> combined_docs/combined.md
cat ../development/WORKFLOW.md >> combined_docs/combined.md
cat ../development/SECURITY_GUIDELINES.md >> combined_docs/combined.md
cat ../development/UI_GUIDELINES.md >> combined_docs/combined.md

# 4. API Documentation
echo "## 4. API Documentation" >> combined_docs/combined.md
cat ../api/API_DOCUMENTATION.md >> combined_docs/combined.md
cat ../api/API_SPEC.md >> combined_docs/combined.md

# 5. Deployment
echo "## 5. Deployment" >> combined_docs/combined.md
cat ../deployment/DEPLOYMENT_GUIDE.md >> combined_docs/combined.md
cat ../deployment/CI_CD.md >> combined_docs/combined.md
cat ../deployment/MONITORING.md >> combined_docs/combined.md
cat ../deployment/RELEASE.md >> combined_docs/combined.md

# 6. Build Plan
echo "## 6. Build Plan" >> combined_docs/combined.md
cat ../build-plan/README.md >> combined_docs/combined.md
cat ../build-plan/packages/*.md >> combined_docs/combined.md
cat ../build-plan/integration/*.md >> combined_docs/combined.md
cat ../build-plan/release/*.md >> combined_docs/combined.md

# Convert to PDF using pandoc
pandoc combined_docs/combined.md \
  -f markdown \
  -t pdf \
  --toc \
  --toc-depth=3 \
  --highlight-style=tango \
  --pdf-engine=xelatex \
  -o combined_docs/jadugar_documentation.pdf

echo "Documentation has been combined into combined_docs/jadugar_documentation.pdf"
