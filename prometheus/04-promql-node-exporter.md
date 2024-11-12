# Install node exporter

```bash
cd /opt
tar -xvzf node_exporter-1.8.2.linux-amd64.tar.gz 
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
```
node_memory_MemAvailable_bytes
node_cpu_seconds_total   - max min count
topk (3,sum(node_cpu_seconds_total) by (mode))
bottomk (3,sum(node_cpu_seconds_total) by (mode))
changes(process_start_time_seconds{job="node_exporter"}[1h])
predict_linear(node_memory_MemFree_bytes{job="node_exporter"}[1h],2*60*60)/1024/1024
(avg by (instance) (irate (node_cpu_seconds_total{mode="system"}[1m]))*100)
```