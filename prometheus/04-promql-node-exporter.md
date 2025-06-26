# Install node exporter

```bash
cd /opt
tar -xvzf node_exporter-1.9.1.linux-amd64.tar.gz 
./node-exporter
```

# Update prometheus.yaml
```yaml
        - job_name: 'node-exporter'
          static_configs:
            - targets: ['ubuntu-obs:9100'] 
```            

# Validate on Prometheus UI
- Targets (Node exporter)

# PromQL Expressions - Node Exporter

```node_memory_MemAvailable_bytes
node_cpu_seconds_total   - max min count
topk (3,sum(node_cpu_seconds_total) by (mode))
bottomk (3,sum(node_cpu_seconds_total) by (mode))
```
## Detect restart
Detect whether the node_exporter process was restarted in the last 1 hour
```changes(process_start_time_seconds{job="node_exporter"}[1h])```

## Predict
Estimate (predict) how much free memory will be available 2 hours into the future, based on the trend of the last 1 hour

```predict_linear(node_memory_MemFree_bytes{job="node_exporter"}[1h],2*60*60)/1024/1024```

## Avg system cpu
average percentage of CPU time spent in 'system' mode per instance, over the last 1 minute.
```(avg by (instance) (irate (node_cpu_seconds_total{mode="system"}[1m]))*100)```

# via service discovery configuration
kubectl apply -f https://raw.githubusercontent.com/brainupgrade-in/obs-graf/refs/heads/main/prometheus/k8s-discovery/10-node-exporter-prometheus-service.yaml