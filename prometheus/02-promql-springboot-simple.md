# App Setup
```bash
kubectl create deploy app --image brainupgrade/prometheus-springboot:simple
kubectl expose deploy app --port 80 --target-port 8080
```
# Update prometheus.yaml with the target
```yaml
      - job_name: 'simpleapp'
        metrics_path: '/actuator/prometheus'
        static_configs:
          - targets: ['app']
```
# Load generator
```bash

kubectl create deploy test --image brainupgrade/tshoot
kubectl exec -it deploy/test -- bash
for i in {1..30};do curl -s app/;sleep 2s;done
for i in {1..30};do curl -s app/hello;sleep 2s;done
curl -s app/visits

while true; do curl app;sleep $(($RANDOM%10));done

```

# Successful Visits - Total
```
http_server_requests_seconds_count{uri="/",status="200",job="simpleapp"}
```
## Non successful requests

http_server_requests_seconds_count{status!~"200",job="simpleapp"}

# Total home page visits
visit_counter_total

# Visits / second 
rate(visit_counter_total[5m])

## Error Rate / second
rate(http_server_requests_seconds_count{application="$application",instance="$instance",status!~"200"}[$__rate_interval])

## Homepage visits per second
rate(visit_counter_total[$__rate_interval])
## Request Per URI
http_server_requests_seconds_count{application="$application",instance="$instance"}

# Configure service with annotation - Admin
kubectl apply -f https://raw.githubusercontent.com/brainupgrade-in/obs-graf/refs/heads/main/prometheus/k8s-discovery/02-simpleapp-prometheus-service.yaml