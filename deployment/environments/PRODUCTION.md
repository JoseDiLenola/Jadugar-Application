# Jadugar Production Environment Guide

## Technology Stack

### Infrastructure Technologies
```yaml
cloud:
  provider: AWS
  regions:
    primary: us-east-1
    secondary: us-west-2
  services:
    compute:
      - EKS (Kubernetes 1.28)
      - EC2 Auto Scaling
    database:
      - Aurora PostgreSQL 15
      - ElastiCache Redis 7.2
    storage:
      - S3
      - EFS
    cdn:
      - CloudFront
    networking:
      - Route53
      - AWS Shield
      - WAF

container:
  orchestration: 
    platform: EKS 1.28
    runtime: containerd
    registry: ECR
    mesh: AWS App Mesh

security:
  ssl: ACM
  firewall: AWS WAF
  ddos: AWS Shield Advanced
  secrets: AWS Secrets Manager
```

### High Availability Technologies
```yaml
database:
  primary: Aurora PostgreSQL (Multi-AZ)
  read_replicas: 2
  backup: Daily + Transaction Logs

cache:
  primary: ElastiCache Redis (Cluster Mode)
  shards: 3
  replicas_per_shard: 2

storage:
  type: S3
  replication: Cross-Region
  lifecycle: Intelligent-Tiering

cdn:
  provider: CloudFront
  edge_locations: Global
  ssl: ACM
```

### Monitoring Technologies
```yaml
observability:
  metrics:
    - Prometheus Enterprise
    - Grafana Enterprise
    - Amazon CloudWatch
  logging:
    - ELK Stack Enterprise
    - CloudWatch Logs
  tracing:
    - AWS X-Ray
    - Jaeger Enterprise
  alerting:
    - PagerDuty
    - OpsGenie

security_monitoring:
  - AWS GuardDuty
  - AWS Security Hub
  - AWS Config
  - AWS CloudTrail
```

## Infrastructure Setup

### 1. Multi-Region Kubernetes
```yaml
# eks-production.yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: jadugar-prod
  region: us-east-1
  version: "1.28"

managedNodeGroups:
  - name: general-compute
    instanceType: m5.2xlarge
    minSize: 3
    maxSize: 10
    desiredCapacity: 3
    volumeSize: 200
    
  - name: build-compute
    instanceType: c5.4xlarge
    minSize: 3
    maxSize: 15
    desiredCapacity: 3
    volumeSize: 200
    labels:
      role: build
    taints:
      - key: dedicated
        value: build
        effect: NoSchedule
        
  - name: memory-optimized
    instanceType: r5.2xlarge
    minSize: 2
    maxSize: 8
    desiredCapacity: 2
    volumeSize: 200
    labels:
      role: cache

iam:
  withOIDC: true
  serviceAccounts:
    - metadata:
        name: aws-load-balancer-controller
        namespace: kube-system
      attachPolicyARNs:
        - "arn:aws:iam::aws:policy/AWSLoadBalancerControllerIAMPolicy"
```

### 2. Database Configuration
```yaml
# aurora-production.yaml
apiVersion: rds.aws.crossplane.io/v1beta1
kind: RDSInstance
metadata:
  name: jadugar-prod-db
spec:
  forProvider:
    region: us-east-1
    engine: aurora-postgresql
    engineVersion: "15.4"
    instanceClass: db.r5.2xlarge
    multiAZ: true
    storageEncrypted: true
    performanceInsightsEnabled: true
    backupRetentionPeriod: 35
    deletionProtection: true
    replicationSourceIdentifier: "arn:aws:rds:us-west-2:..."
    vpcSecurityGroupIds:
      - sg-prod-db
    tags:
      Environment: production
```

### 3. Cache Configuration
```yaml
# redis-production.yaml
apiVersion: cache.aws.crossplane.io/v1beta1
kind: ReplicationGroup
metadata:
  name: jadugar-prod-cache
spec:
  forProvider:
    engine: redis
    engineVersion: "7.2"
    cacheNodeType: cache.r5.xlarge
    numNodeGroups: 3
    replicasPerNodeGroup: 2
    automaticFailoverEnabled: true
    multiAZEnabled: true
    transitEncryptionEnabled: true
    atRestEncryptionEnabled: true
```

## High Availability Setup

### 1. Load Balancing
```yaml
# aws-load-balancer.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: jadugar-prod-ingress
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}]'
    alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:region:account:certificate/certificate-id
    alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-TLS-1-2-2017-01
    alb.ingress.kubernetes.io/healthcheck-path: /health
spec:
  rules:
    - host: api.jadugar.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: jadugar-api
                port:
                  number: 80
```

### 2. Failover Configuration
```yaml
# failover-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: failover-config
data:
  database:
    primary_region: us-east-1
    failover_region: us-west-2
    auto_failover: true
    failover_timeout: 300
    
  cache:
    primary_region: us-east-1
    failover_region: us-west-2
    auto_failover: true
    failover_timeout: 60
    
  application:
    primary_region: us-east-1
    failover_region: us-west-2
    health_check_interval: 10
    failover_threshold: 3
```

## Security Configuration

### 1. Network Security
```yaml
# network-policy.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: jadugar-prod-network-policy
spec:
  podSelector:
    matchLabels:
      app: jadugar-api
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
        - namespaceSelector:
            matchLabels:
              name: ingress-nginx
        - podSelector:
            matchLabels:
              app: jadugar-frontend
      ports:
        - protocol: TCP
          port: 80
  egress:
    - to:
        - namespaceSelector:
            matchLabels:
              name: kube-system
      ports:
        - protocol: TCP
          port: 443
```

### 2. WAF Configuration
```yaml
# waf-rules.yaml
AWSTemplateFormatVersion: '2010-09-09'
Resources:
  WAFWebACL:
    Type: AWS::WAFv2::WebACL
    Properties:
      Name: jadugar-prod-waf
      DefaultAction:
        Allow: {}
      Rules:
        - Name: AWSManagedRulesCommonRuleSet
          Priority: 1
          Statement:
            ManagedRuleGroupStatement:
              VendorName: AWS
              Name: AWSManagedRulesCommonRuleSet
          OverrideAction:
            None: {}
          VisibilityConfig:
            SampledRequestsEnabled: true
            CloudWatchMetricsEnabled: true
            MetricName: AWSManagedRulesCommonRuleSetMetric
        
        - Name: RateLimit
          Priority: 2
          Statement:
            RateBasedStatement:
              Limit: 2000
              AggregateKeyType: IP
          Action:
            Block: {}
          VisibilityConfig:
            SampledRequestsEnabled: true
            CloudWatchMetricsEnabled: true
            MetricName: RateLimitMetric
```

## Monitoring Configuration

### 1. Prometheus Configuration
```yaml
# prometheus-prod.yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - /etc/prometheus/rules/*.yaml

alerting:
  alertmanagers:
    - static_configs:
        - targets:
            - alertmanager:9093

scrape_configs:
  - job_name: 'kubernetes-apiservers'
    kubernetes_sd_configs:
      - role: endpoints
    scheme: https
    tls_config:
      ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token

  - job_name: 'kubernetes-nodes'
    kubernetes_sd_configs:
      - role: node
    relabel_configs:
      - action: labelmap
        regex: __meta_kubernetes_node_label_(.+)

  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true
```

### 2. Logging Configuration
```yaml
# fluentd-prod.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluentd-config
data:
  fluent.conf: |
    <source>
      @type tail
      path /var/log/containers/*.log
      pos_file /var/log/fluentd-containers.log.pos
      tag kubernetes.*
      read_from_head true
      <parse>
        @type json
        time_key time
        time_format %Y-%m-%dT%H:%M:%S.%NZ
      </parse>
    </source>

    <filter kubernetes.**>
      @type kubernetes_metadata
      kubernetes_url "#{ENV['KUBERNETES_URL']}"
      bearer_token_file /var/run/secrets/kubernetes.io/serviceaccount/token
      ca_file /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
      skip_labels false
      skip_container_metadata false
      skip_namespace_metadata false
    </filter>

    <match kubernetes.**>
      @type elasticsearch
      host elasticsearch-master
      port 9200
      logstash_format true
      logstash_prefix k8s-logs
      <buffer>
        @type file
        path /var/log/fluentd-buffers/kubernetes.system.buffer
        flush_mode interval
        retry_type exponential_backoff
        flush_thread_count 2
        flush_interval 5s
        retry_forever false
        retry_max_interval 30
        chunk_limit_size 2M
        queue_limit_length 8
        overflow_action block
      </buffer>
    </match>
```

## Backup and Recovery

### 1. Backup Configuration
```yaml
# backup-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: backup-config
data:
  database:
    schedule: "0 0 * * *"  # Daily at midnight
    retention: 35d
    type: snapshot
    encryption: true
    
  application:
    schedule: "0 1 * * *"  # Daily at 1 AM
    retention: 90d
    type: snapshot
    encryption: true
    
  configuration:
    schedule: "0 */6 * * *"  # Every 6 hours
    retention: 30d
    type: version-controlled
    encryption: true
```

### 2. Recovery Procedures
```bash
#!/bin/bash

# Database Recovery
recover_database() {
  # Stop application
  kubectl scale deployment jadugar-api --replicas=0
  
  # Restore database
  aws rds restore-db-cluster-from-snapshot \
    --db-cluster-identifier jadugar-prod-restored \
    --snapshot-identifier "$SNAPSHOT_ID" \
    --engine aurora-postgresql
    
  # Verify restoration
  psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "SELECT NOW();"
  
  # Update application configuration
  kubectl set env deployment/jadugar-api \
    DATABASE_URL="postgresql://$DB_USER:$DB_PASS@$NEW_DB_HOST:5432/$DB_NAME"
    
  # Restart application
  kubectl scale deployment jadugar-api --replicas=3
}

# Application Recovery
recover_application() {
  # Identify last known good state
  LAST_GOOD_VERSION=$(aws s3 ls s3://jadugar-backups/app/ | sort | tail -n 1)
  
  # Restore application state
  aws s3 cp s3://jadugar-backups/app/$LAST_GOOD_VERSION ./backup/
  
  # Apply configuration
  kubectl apply -f ./backup/config/
  
  # Restart services
  kubectl rollout restart deployment jadugar-api
}
```

## Performance Optimization

### 1. Resource Optimization
```yaml
# resource-limits.yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: jadugar-prod-limits
spec:
  limits:
    - type: Container
      default:
        cpu: 500m
        memory: 512Mi
      defaultRequest:
        cpu: 200m
        memory: 256Mi
      max:
        cpu: 2
        memory: 4Gi
      min:
        cpu: 100m
        memory: 128Mi
```

### 2. Autoscaling Configuration
```yaml
# autoscaling.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: jadugar-api-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: jadugar-api
  minReplicas: 3
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: 80
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 60
      policies:
        - type: Pods
          value: 2
          periodSeconds: 60
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
        - type: Pods
          value: 1
          periodSeconds: 300
```

## Disaster Recovery

### 1. DR Strategy
```yaml
# dr-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: dr-config
data:
  strategy:
    type: active-passive
    rto: 1h  # Recovery Time Objective
    rpo: 5m  # Recovery Point Objective
    
  regions:
    primary: us-east-1
    dr: us-west-2
    
  components:
    database:
      replication: synchronous
      failover: automatic
      
    cache:
      replication: asynchronous
      failover: automatic
      
    storage:
      replication: cross-region
      failover: automatic
```

### 2. DR Procedures
```bash
#!/bin/bash

# DR Failover
execute_dr_failover() {
  # 1. Verify DR Prerequisites
  check_dr_prerequisites() {
    # Check replication status
    check_database_replication
    check_cache_replication
    check_storage_replication
    
    # Verify DR environment
    verify_dr_environment
  }
  
  # 2. Execute Failover
  perform_failover() {
    # Switch DNS
    update_route53_records
    
    # Promote DR database
    promote_dr_database
    
    # Switch application traffic
    update_load_balancers
    
    # Scale up DR environment
    scale_dr_environment
  }
  
  # 3. Verify Failover
  verify_failover() {
    # Check application health
    check_application_health
    
    # Verify data consistency
    verify_data_consistency
    
    # Monitor performance
    monitor_dr_performance
  }
  
  # Execute DR sequence
  check_dr_prerequisites
  perform_failover
  verify_failover
}
```

## Compliance and Auditing

### 1. Audit Configuration
```yaml
# audit-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: audit-config
data:
  audit_log:
    enabled: true
    level: RequestResponse
    maxAge: 30
    maxBackup: 10
    maxSize: 100
    
  compliance:
    standards:
      - SOC2
      - ISO27001
      - GDPR
    controls:
      - access_control
      - encryption
      - monitoring
      - backup
```

### 2. Compliance Monitoring
```yaml
# compliance-monitoring.yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: compliance-alerts
spec:
  groups:
    - name: compliance
      rules:
        - alert: UnencryptedData
          expr: encryption_status{encrypted="false"} > 0
          for: 5m
          labels:
            severity: critical
            compliance: "true"
          annotations:
            summary: Unencrypted data detected
            
        - alert: UnauthorizedAccess
          expr: unauthorized_access_attempts > 10
          for: 5m
          labels:
            severity: critical
            compliance: "true"
          annotations:
            summary: Multiple unauthorized access attempts detected
```
