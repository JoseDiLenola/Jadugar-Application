# Development Tools

Tracking of all development tools and utilities used in the Jadugar project.

## Documentation Tools

### PDF Generation System
- **Location**: `/tools/pdf-email/`
- **Purpose**: Convert and distribute documentation as PDFs
- **Components**:
  - send-pdf.js: Main conversion and email script
  - package.json: Node.js dependencies
  - .env: Configuration and credentials
- **Usage**: `node scripts/send-pdf.js <input-file> [subject] [body-text]`

## Tool Categories

### 1. Development Environment
- Code editors
- IDEs
- Terminal emulators
- Version control tools

### 2. Build Tools
- Compilers
- Transpilers
- Bundlers
- Package managers

### 3. Testing Tools
- Test runners
- Mocking frameworks
- Coverage tools
- Performance testing

### 4. Documentation Tools
- Documentation generators
- Diagramming tools
- Screenshot/recording tools
- Collaboration platforms

### 5. Deployment Tools
- CI/CD platforms
- Container tools
- Cloud management tools
- Monitoring solutions

## Tool Documentation Template
```yaml
tool_name:
  version: x.y.z
  purpose: Brief description
  installation: Installation steps
  configuration: Config file locations
  usage: Basic usage examples
  documentation: Link to docs
  maintenance: Update/maintenance info
  alternatives: Alternative tools
  notes: Additional information
```
