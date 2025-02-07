# Credentials Management

This directory tracks all credentials and access information for the Jadugar project.

## Current Credentials

### Email Services
1. **Gmail (PDF Distribution)**
   - Service: Gmail SMTP
   - Account: joselaurdil@gmail.com
   - Auth Method: App Password
   - Usage: PDF document distribution
   - Location: `/tools/pdf-email/.env`
   - Setup Date: 2025-02-04

## Credential Templates

### Service Access Template
```yaml
service_name:
  type: [email|api|database|cloud]
  account: user@example.com
  auth_method: [password|token|key|certificate]
  purpose: Brief description of usage
  location: Path to credential storage
  setup_date: YYYY-MM-DD
  renewal_date: YYYY-MM-DD (if applicable)
  owner: Team/person responsible
  access_level: [read|write|admin]
  emergency_contact: Person to contact for access issues
```

## Security Protocols

1. **Credential Storage**
   - Use environment variables for runtime
   - Store encrypted backups
   - Regular rotation schedule
   - Access audit logging

2. **Access Management**
   - Document all access grants
   - Regular access reviews
   - Immediate revocation process
   - Backup access procedures
