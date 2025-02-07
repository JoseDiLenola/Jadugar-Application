# External Services

Tracking of all external services and APIs used in the Jadugar project.

## Email Services

### Gmail SMTP
- **Purpose**: Documentation distribution
- **Account**: joselaurdil@gmail.com
- **Setup Date**: 2025-02-04
- **Configuration**: 
  - Location: `/tools/pdf-email/.env`
  - Protocol: SMTP
  - Security: TLS
- **Usage**: PDF document distribution
- **Costs**: Free (within Gmail limits)
- **Limits**: 
  - 2000 emails/day
  - 25MB attachments

## Service Categories

### 1. Communication Services
- Email providers
- Notification services
- Chat/messaging platforms
- Video conferencing

### 2. Cloud Services
- Hosting providers
- Storage services
- CDN services
- Database services

### 3. Development Services
- CI/CD platforms
- Code repositories
- Package registries
- Testing services

### 4. Monitoring Services
- Application monitoring
- Error tracking
- Performance monitoring
- Security scanning

## Service Documentation Template
```yaml
service_name:
  purpose: Primary use case
  account_info:
    owner: Primary contact
    access_level: Permission level
    setup_date: YYYY-MM-DD
  configuration:
    location: Config file path
    key_parameters: Important settings
  usage:
    primary_use: Main functionality
    integration_points: Where used
  costs:
    plan: Current plan
    limits: Usage limits
    billing: Billing details
  support:
    documentation: Link to docs
    contact: Support contact
    sla: Service level agreement
  security:
    compliance: Required standards
    backup: Backup procedures
    disaster_recovery: Recovery plans
```
