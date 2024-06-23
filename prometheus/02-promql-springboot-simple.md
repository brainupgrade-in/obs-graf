# App Setup
kubectl create deploy app --image brainupgrade/prometheus-springboot:simple
kubectl expose deploy app --port 80 --target-port 8080

# Update prometheus.yaml with the target
      - job_name: 'simpleapp'
        metrics_path: '/actuator/prometheus'
        static_configs:
          - targets: ['app']

# Load generator
kubectl create deploy test --image brainupgrade/tshoot
kubectl exec -it deploy/test -- bash
for i in {1..30};do curl -s app/;done
curl -s app/visits


# Successful Visits - Total
http_server_requests_seconds_count{uri="/",status="200",job="simpleapp"}

## Non successful requests
http_server_requests_seconds_count{status!~"200",job="simpleapp"}

# Total home page visits
visit_counter_total

# Visits / second 
rate(visit_counter_total[5m])