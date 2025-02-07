# Staging Environment Quick Reference

## 🚀 Quick Deploy
```bash
# 1. Deploy to Staging
git push origin staging

# 2. Monitor Pipeline
gh workflow view

# 3. Verify Deployment
curl https://staging.jadugar.com/health
```

## 🔧 Common Commands
```bash
# Kubernetes
kubectl get pods -n jadugar-staging    # Check pods
kubectl get svc -n jadugar-staging     # Check services
kubectl logs -f <pod-name>             # Stream logs

# Database
psql $STAGING_DB_URL                   # Connect to DB
kubectl port-forward svc/db 5432:5432  # Port forward

# Container Registry
aws ecr get-login-password | docker login --username AWS --password-stdin $ECR_URL
docker push $ECR_URL/jadugar:staging
```

## 📝 Key Resources
```yaml
# Namespace
jadugar-staging

# Core Services
jadugar-api-staging
jadugar-web-staging
jadugar-db-staging
jadugar-redis-staging

# Ingress
jadugar-ingress-staging

# ConfigMaps
jadugar-config-staging
```

## 🔑 Access & Credentials
```bash
# AWS Access
aws configure

# Kubernetes
aws eks update-kubeconfig --name jadugar-staging

# Database
export PGPASSWORD=$(aws secretsmanager get-secret-value \
  --secret-id jadugar/staging/db \
  --query SecretString --output text)
```

## 🔍 Monitoring
```bash
# Prometheus
http://prometheus.staging.jadugar.com

# Grafana
http://grafana.staging.jadugar.com

# Kibana
http://kibana.staging.jadugar.com
```

## 🐛 Common Issues

### Pipeline Failures
```bash
# 1. Check Pipeline
gh run list --workflow=deploy-staging.yml

# 2. View Logs
gh run view --log

# 3. Retry Deploy
gh workflow run deploy-staging.yml
```

### Pod Issues
```bash
# 1. Check Status
kubectl get pods -n jadugar-staging

# 2. View Logs
kubectl logs <pod-name> -n jadugar-staging

# 3. Describe Pod
kubectl describe pod <pod-name> -n jadugar-staging
```

### Database Issues
```bash
# 1. Check Connection
kubectl exec -it <pod-name> -- pg_isready

# 2. View Active Queries
psql $STAGING_DB_URL -c "SELECT * FROM pg_stat_activity;"

# 3. Kill Stuck Queries
psql $STAGING_DB_URL -c "SELECT pg_terminate_backend(pid);"
```

## 📊 Health Checks
```bash
# API Health
curl https://api.staging.jadugar.com/health

# Database Health
kubectl exec -it <db-pod> -- pg_isready

# Redis Health
kubectl exec -it <redis-pod> -- redis-cli ping
```

## 🔄 Rollback Procedures
```bash
# 1. Rollback Deployment
kubectl rollout undo deployment/jadugar-api -n jadugar-staging

# 2. Verify Rollback
kubectl rollout status deployment/jadugar-api -n jadugar-staging

# 3. Check Logs
kubectl logs -f deployment/jadugar-api -n jadugar-staging
```

## 📡 Important URLs
```bash
# Application
https://staging.jadugar.com

# API
https://api.staging.jadugar.com

# Monitoring
https://grafana.staging.jadugar.com
https://prometheus.staging.jadugar.com
https://kibana.staging.jadugar.com
```
