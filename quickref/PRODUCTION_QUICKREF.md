# Production Environment Quick Reference

## 🚀 Deployment Commands
```bash
# 1. Deploy to Production
git push origin main

# 2. Monitor Deployment
gh workflow view deploy-prod.yml
kubectl get pods -n jadugar-prod -w

# 3. Verify Health
curl https://jadugar.com/health
```

## 🔧 Essential Commands
```bash
# Kubernetes
kubectl get all -n jadugar-prod        # All resources
kubectl top pods -n jadugar-prod       # Resource usage
kubectl logs -f deploy/jadugar-api     # Stream logs

# Database
psql $PROD_DB_URL -c "\dt;"            # List tables
kubectl exec -it <pod> -- pgbench      # Performance test

# Monitoring
kubectl top nodes                      # Node metrics
kubectl get events --sort-by=.metadata.creationTimestamp
```

## 🚨 Emergency Commands
```bash
# 1. Stop Traffic
kubectl scale deployment jadugar-api --replicas=0

# 2. Emergency Rollback
kubectl rollout undo deployment jadugar-api

# 3. Database Failover
aws rds failover-db-cluster --db-cluster-identifier jadugar-prod
```

## 🔑 Access Control
```bash
# AWS Production Access
aws configure --profile jadugar-prod

# Kubernetes Production
aws eks update-kubeconfig --name jadugar-prod

# Database Access
aws secretsmanager get-secret-value \
  --secret-id jadugar/prod/db \
  --query SecretString
```

## 📊 Monitoring Dashboard URLs
```bash
# Main Dashboards
https://grafana.jadugar.com/d/production
https://kibana.jadugar.com/app/production
https://prometheus.jadugar.com

# AWS CloudWatch
https://console.aws.amazon.com/cloudwatch/home
```

## 🔍 Health Checks
```bash
# Application Health
curl -v https://jadugar.com/health

# Database Health
psql $PROD_DB_URL -c "SELECT 1;"

# Cache Health
redis-cli -h $REDIS_HOST ping
```

## 🚑 Critical Issues

### Service Outage
```bash
# 1. Check Status
kubectl get pods,svc,ingress -n jadugar-prod

# 2. Check Logs
kubectl logs -l app=jadugar-api -n jadugar-prod

# 3. Check Events
kubectl get events -n jadugar-prod --sort-by=.metadata.creationTimestamp
```

### Database Issues
```bash
# 1. Check Connections
psql $PROD_DB_URL -c "SELECT count(*) FROM pg_stat_activity;"

# 2. Kill Bad Queries
psql $PROD_DB_URL -c "
SELECT pg_terminate_backend(pid) 
FROM pg_stat_activity 
WHERE state = 'idle' 
AND state_change < now() - interval '30 minutes';"

# 3. Check Replication
psql $PROD_DB_URL -c "SELECT * FROM pg_stat_replication;"
```

### Memory Issues
```bash
# 1. Check Memory
kubectl top pods -n jadugar-prod

# 2. Check OOM Events
kubectl get events -n jadugar-prod | grep OOMKilled

# 3. Increase Limits
kubectl set resources deployment jadugar-api \
  -c=jadugar-api --limits=memory=2Gi
```

## 📡 Important Endpoints
```bash
# Production API
https://api.jadugar.com/v1

# Admin Dashboard
https://admin.jadugar.com

# Metrics
https://metrics.jadugar.com
```

## 🔄 Scaling Commands
```bash
# Manual Scaling
kubectl scale deployment jadugar-api --replicas=5

# Check HPA
kubectl get hpa -n jadugar-prod

# Update HPA
kubectl edit hpa jadugar-api -n jadugar-prod
```

## 🛡️ Security Commands
```bash
# Check Certificate
aws acm describe-certificate --certificate-arn $CERT_ARN

# List Security Groups
aws ec2 describe-security-groups --group-ids $SG_ID

# Check WAF Rules
aws wafv2 get-web-acl --name jadugar-prod --scope REGIONAL
```

## 💾 Backup Commands
```bash
# Manual DB Snapshot
aws rds create-db-cluster-snapshot \
  --db-cluster-identifier jadugar-prod \
  --db-cluster-snapshot-identifier manual-backup-$(date +%Y%m%d)

# List Snapshots
aws rds describe-db-cluster-snapshots \
  --db-cluster-identifier jadugar-prod

# Export Logs
aws s3 sync /var/log/jadugar s3://jadugar-logs/$(date +%Y%m%d)/
```
