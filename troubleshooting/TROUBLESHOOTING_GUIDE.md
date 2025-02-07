# Jadugar Troubleshooting Guide

## Development Environment Issues

### 1. Build Issues
```bash
# Problem: Build fails with TypeScript errors
Symptom: tsc fails with type errors
Solution:
1. Check type definitions:
   ```bash
   npm run type-check
   ```
2. Verify @types packages:
   ```bash
   npm ls @types/react @types/node
   ```
3. Check tsconfig.json settings:
   ```bash
   cat tsconfig.json | grep "strict"
   ```

# Problem: Package dependency issues
Symptom: npm install fails
Solution:
1. Clear npm cache:
   ```bash
   npm cache clean --force
   ```
2. Delete node_modules:
   ```bash
   rm -rf node_modules
   rm package-lock.json
   ```
3. Reinstall:
   ```bash
   npm install
   ```

# Problem: Development server not starting
Symptom: vite dev server fails
Solution:
1. Check port conflicts:
   ```bash
   lsof -i :3000
   ```
2. Verify environment:
   ```bash
   cat .env.development
   ```
3. Check vite config:
   ```bash
   cat vite.config.ts
   ```
```

### 2. Database Issues
```sql
-- Problem: Database connection fails
Symptom: ECONNREFUSED error
Solution:
1. Check database status:
   ```bash
   brew services list | grep postgresql
   ```

2. Verify connection:
   ```sql
   SELECT version();
   ```

3. Check connection string:
   ```bash
   echo $DATABASE_URL
   ```

-- Problem: Migration fails
Symptom: Prisma migration error
Solution:
1. Check migration status:
   ```sql
   SELECT * FROM _prisma_migrations ORDER BY finished_at DESC LIMIT 5;
   ```

2. Reset database:
   ```bash
   npx prisma migrate reset
   ```

3. Recreate migration:
   ```bash
   npx prisma migrate dev --name fix_schema
   ```
```

### 3. Docker Issues
```bash
# Problem: Container not starting
Symptom: Container exits immediately
Solution:
1. Check logs:
   ```bash
   docker logs <container_id>
   ```

2. Verify environment:
   ```bash
   docker inspect <container_id> | grep -A 10 "Env"
   ```

3. Check resource limits:
   ```bash
   docker stats <container_id>
   ```

# Problem: Volume mount issues
Symptom: Container can't access files
Solution:
1. Check volume mounts:
   ```bash
   docker inspect <container_id> | grep -A 10 "Mounts"
   ```

2. Verify permissions:
   ```bash
   ls -la /path/to/volume
   ```

3. Recreate volume:
   ```bash
   docker volume rm <volume_name>
   docker-compose up -d
   ```
```

## Staging Environment Issues

### 1. Deployment Issues
```yaml
# Problem: Pipeline failure
Symptom: GitHub Actions pipeline fails
Solution:
1. Check action logs:
   ```bash
   gh run view <run_id> --log
   ```

2. Verify secrets:
   ```bash
   gh secret list
   ```

3. Test locally:
   ```bash
   act -n
   ```

# Problem: Container registry issues
Symptom: Cannot push to ECR
Solution:
1. Check authentication:
   ```bash
   aws ecr get-login-password | docker login --username AWS --password-stdin $ECR_REGISTRY
   ```

2. Verify policy:
   ```bash
   aws ecr get-repository-policy --repository-name jadugar
   ```

3. Check image:
   ```bash
   docker image inspect $IMAGE_ID
   ```
```

### 2. Kubernetes Issues
```bash
# Problem: Pod not starting
Symptom: Pod stuck in Pending/CrashLoopBackOff
Solution:
1. Check pod status:
   ```bash
   kubectl describe pod <pod_name>
   ```

2. Check logs:
   ```bash
   kubectl logs <pod_name> --previous
   ```

3. Check node resources:
   ```bash
   kubectl describe node <node_name>
   ```

# Problem: Service not accessible
Symptom: Cannot reach service
Solution:
1. Check service:
   ```bash
   kubectl get svc <service_name>
   ```

2. Check endpoints:
   ```bash
   kubectl get endpoints <service_name>
   ```

3. Test connectivity:
   ```bash
   kubectl run -i --tty --rm debug --image=busybox --restart=Never -- wget -O- http://service-name:port
   ```
```

## Production Environment Issues

### 1. Performance Issues
```bash
# Problem: High latency
Symptom: API response time > 500ms
Solution:
1. Check metrics:
   ```bash
   kubectl exec -it prometheus-0 -- promql query 'histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))'
   ```

2. Profile application:
   ```bash
   curl http://localhost:3000/debug/pprof/profile > cpu.prof
   ```

3. Analyze database:
   ```sql
   SELECT * FROM pg_stat_activity WHERE state = 'active';
   ```

# Problem: Memory leaks
Symptom: Increasing memory usage
Solution:
1. Check heap:
   ```bash
   node --inspect-brk index.js
   ```

2. Analyze metrics:
   ```bash
   kubectl top pods
   ```

3. Check container limits:
   ```bash
   kubectl describe pod <pod_name> | grep Limits -A 5
   ```
```

### 2. Database Performance Issues
```sql
-- Problem: Slow queries
Symptom: Query time > 1s
Solution:
1. Identify slow queries:
   ```sql
   SELECT * FROM pg_stat_activity 
   WHERE state = 'active' 
   AND now() - query_start > interval '1 second';
   ```

2. Check indexes:
   ```sql
   SELECT schemaname, tablename, indexname, tablespace,
          indexdef FROM pg_indexes
   WHERE tablename = 'your_table';
   ```

3. Analyze query plan:
   ```sql
   EXPLAIN ANALYZE your_query;
   ```

-- Problem: Connection pool exhaustion
Symptom: FATAL: remaining connection slots are reserved
Solution:
1. Check connections:
   ```sql
   SELECT count(*), state 
   FROM pg_stat_activity 
   GROUP BY state;
   ```

2. Kill idle connections:
   ```sql
   SELECT pg_terminate_backend(pid) 
   FROM pg_stat_activity 
   WHERE state = 'idle'
   AND state_change < now() - interval '30 minutes';
   ```

3. Adjust pool size:
   ```typescript
   // prisma/schema.prisma
   datasource db {
     provider = "postgresql"
     url      = env("DATABASE_URL")
     pooling  = {
       max = 20
       min = 5
       idle = 10000
     }
   }
   ```
```

### 3. Network Issues
```bash
# Problem: DNS resolution fails
Symptom: Cannot resolve service names
Solution:
1. Check CoreDNS:
   ```bash
   kubectl get pods -n kube-system | grep coredns
   kubectl logs -n kube-system coredns-xxx
   ```

2. Test resolution:
   ```bash
   kubectl run -i --tty --rm debug --image=busybox --restart=Never -- nslookup kubernetes.default
   ```

3. Verify network policy:
   ```bash
   kubectl get networkpolicy
   ```

# Problem: Load balancer issues
Symptom: 502 Bad Gateway
Solution:
1. Check ALB:
   ```bash
   aws elbv2 describe-load-balancers
   aws elbv2 describe-target-health --target-group-arn $ARN
   ```

2. Verify health checks:
   ```bash
   kubectl describe ingress <ingress_name>
   ```

3. Check service endpoints:
   ```bash
   kubectl get endpoints <service_name>
   ```
```

### 4. Security Issues
```bash
# Problem: Certificate errors
Symptom: SSL handshake failure
Solution:
1. Check certificate:
   ```bash
   openssl x509 -in cert.pem -text -noout
   ```

2. Verify ACM:
   ```bash
   aws acm describe-certificate --certificate-arn $ARN
   ```

3. Check ingress:
   ```bash
   kubectl describe ingress <ingress_name>
   ```

# Problem: Authentication failures
Symptom: 401/403 errors
Solution:
1. Check JWT:
   ```bash
   jwt decode <token>
   ```

2. Verify RBAC:
   ```bash
   kubectl auth can-i --list
   ```

3. Check policies:
   ```bash
   aws iam list-role-policies --role-name $ROLE_NAME
   ```
```

## Monitoring and Logging Issues

### 1. Prometheus Issues
```yaml
# Problem: Metrics not collected
Symptom: No data in Grafana
Solution:
1. Check targets:
   ```bash
   curl http://prometheus:9090/api/v1/targets
   ```

2. Verify service discovery:
   ```bash
   kubectl get servicemonitors
   ```

3. Check configuration:
   ```bash
   kubectl get configmap prometheus-server -o yaml
   ```

# Problem: Alert manager not firing
Symptom: No alerts received
Solution:
1. Check alert rules:
   ```bash
   curl http://prometheus:9090/api/v1/rules
   ```

2. Verify alert manager:
   ```bash
   kubectl port-forward svc/alertmanager 9093:9093
   curl http://localhost:9093/api/v1/alerts
   ```

3. Check receivers:
   ```bash
   kubectl get secret alertmanager-notifications -o yaml
   ```
```

### 2. Logging Issues
```yaml
# Problem: Missing logs
Symptom: Logs not appearing in Elasticsearch
Solution:
1. Check Fluentd:
   ```bash
   kubectl logs -n logging fluentd-xxx
   ```

2. Verify Elasticsearch:
   ```bash
   curl -X GET "localhost:9200/_cat/indices?v"
   ```

3. Check log shipping:
   ```bash
   kubectl exec -it fluentd-xxx -- cat /var/log/fluentd.log
   ```

# Problem: Log storage issues
Symptom: Elasticsearch disk full
Solution:
1. Check indices:
   ```bash
   curl -X GET "localhost:9200/_cat/indices?v&s=store.size:desc"
   ```

2. Delete old indices:
   ```bash
   curator_cli --host elasticsearch delete_indices --filter_list '{"filtertype":"age","source":"creation_date","direction":"older","unit":"days","unit_count":30}'
   ```

3. Adjust retention:
   ```bash
   kubectl edit configmap elasticsearch-config
   ```
```

## Recovery Procedures

### 1. Data Recovery
```bash
# Problem: Data corruption
Symptom: Inconsistent database state
Solution:
1. Stop application:
   ```bash
   kubectl scale deployment jadugar-api --replicas=0
   ```

2. Restore backup:
   ```bash
   aws rds restore-db-cluster-from-snapshot \
     --db-cluster-identifier jadugar-restored \
     --snapshot-identifier $SNAPSHOT_ID
   ```

3. Verify data:
   ```sql
   SELECT COUNT(*) FROM critical_table;
   ```

# Problem: Lost configuration
Symptom: Invalid application state
Solution:
1. Get last config:
   ```bash
   aws s3 cp s3://jadugar-backups/config/latest.yaml ./
   ```

2. Apply config:
   ```bash
   kubectl apply -f latest.yaml
   ```

3. Verify state:
   ```bash
   kubectl get all -n jadugar
   ```
```

### 2. Service Recovery
```bash
# Problem: Service outage
Symptom: Application unavailable
Solution:
1. Check status:
   ```bash
   kubectl get pods,svc,ingress
   ```

2. Check events:
   ```bash
   kubectl get events --sort-by='.lastTimestamp'
   ```

3. Restore service:
   ```bash
   kubectl rollout restart deployment jadugar-api
   kubectl rollout status deployment jadugar-api
   ```

# Problem: Region failure
Symptom: AWS region issues
Solution:
1. Check status:
   ```bash
   aws health describe-events --region us-east-1
   ```

2. Failover to DR:
   ```bash
   ./dr-failover.sh --region us-west-2
   ```

3. Verify failover:
   ```bash
   curl https://jadugar.com/health
   ```
```
